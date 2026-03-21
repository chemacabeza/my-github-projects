# Spring Modulith — Introduction & Complete Tutorial

> **Framework:** Spring Modulith 1.x (requires Spring Boot 3.x)
> **Reference project:** [`Tests-with-Modular-SpringBoot`](https://github.com/chemacabeza/Tests-with-Modular-SpringBoot)

---

## 1. The Problem Spring Modulith Solves

A standard Spring Boot application puts everything in one package tree. After a few months it devolves into a **Big Ball of Mud**: every class can call every other class, business boundaries dissolve, and adding a feature in one area silently breaks another.

The usual escape route is to split the monolith into **microservices** — but that trades spaghetti code for network latency, distributed transactions, and operational complexity you may not need yet.

Spring Modulith sits in between: it imposes **module boundaries inside a single Spring Boot application** and enforces them at compile/test time. You get the development simplicity of a monolith with the logical separation of microservices — and you can externalize modules to real services later if needed.

<p align="center">
  <img src="../images/modulith_architecture_spectrum.png" alt="The Architecture Spectrum — Monolith vs Spring Modulith vs Microservices" width="800"/>
</p>

---

## 2. Docker Setup (Mac & Ubuntu)

To make this project completely reproducible locally, we provide a containerized environment. Modulith relies heavily on a database (for the `event_publication` log) and optionally a message broker (like Kafka) if you are externalizing events.

Place these files in your project root to spin up PostgreSQL, Kafka, and the app seamlessly.

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  db:
      image: postgres:15-alpine
      container_name: modulith_db
      environment:
        POSTGRES_USER: modulith_user
        POSTGRES_PASSWORD: modulith_password
        POSTGRES_DB: modulith_system
      ports:
        - "5432:5432"
      volumes:
        - pg_modulith_data:/var/lib/postgresql/data

  kafka:
    image: confluentinc/cp-kafka:7.4.0
    container_name: modulith_kafka
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:29092,PLAINTEXT_HOST://localhost:9092
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:29092,PLAINTEXT_HOST://0.0.0.0:9092
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka:29093
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      CLUSTER_ID: 'MkU3OEVBNTcwNTJENDM2Qk'
    ports:
      - "9092:9092"

  app:
    build: .
    container_name: modulith_app
    ports:
      - "8080:8080"
    depends_on:
      - db
      - kafka
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/modulith_system
      - SPRING_KAFKA_BOOTSTRAP_SERVERS=kafka:29092

volumes:
  pg_modulith_data:
```

### `Dockerfile`

```dockerfile
# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the final lightweight image
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 3. Setting Up (`pom.xml` & `Application.java`)

To get started, add the **Spring Modulith BOM (Bill of Materials)** management to your build, and then include the starters you need. 

Here are the essential additions for your **`pom.xml`** dependencies section:

```xml
<!-- Core (module detection, validation, documentation) -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-starter-core</artifactId>
</dependency>

<!-- Transactional event publication with JPA -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-starter-jpa</artifactId>
</dependency>

<!-- Forward events to Kafka (optional, if you want external events) -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-kafka</artifactId>
</dependency>

<!-- Actuator endpoint: /actuator/modulith -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-actuator</artifactId>
</dependency>

<!-- Test support for JUnit 5 verifying rules -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

### The `@Modulithic` Entry Point

Replace nothing — just add the `@Modulithic` annotation to your main `@SpringBootApplication` class. This tells Spring Modulith to map your top-level sub-packages to structural modules.

```java
package com.example.modular;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.modulith.Modulithic;

@SpringBootApplication
@Modulithic(
        systemName = "Spring Modulith Reference App",
        useFullyQualifiedModuleNames = false
)
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

---

## 4. Package Structure: Modules = Java Packages

Each **top-level sub-package** of your main application package is a module. No XML, no separate `.jar` files — just standard folder structure.

<p align="center">
  <img src="../images/modulith_module_dependency_graph.png" alt="Spring Modulith — Module Dependency Graph" width="700"/>
</p>

> Solid arrows = direct service calls (allowed if a class is public). Dashed arrows = event-based communication.

---

## 5. Building the Catalog Module (Public vs Private)

By default, only **public types in the module's root package** form the public API. If you create a sub-package (e.g., `catalog/internal/`), those classes are strictly private to that module and inaccessible by others.

<p align="center">
  <img src="../images/modulith_module_boundaries.png" alt="Module Boundary Rules — Public API vs Internal" width="750"/>
</p>

Instead of exposing the JPA Entity (`Product`), we expose a public `ProductDto` out of the Catalog module, ensuring that the internal database model remains isolated.

### `catalog/ProductDto.java` (Public API)
This is what other modules (`orders`, for example) get when they query the Catalog module.

```java
package com.example.modular.catalog;

import java.io.Serializable;
import java.math.BigDecimal;

public record ProductDto(Long id, String name, String description, BigDecimal price, boolean available) implements Serializable {
    static ProductDto from(Product p) {
        return new ProductDto(p.getId(), p.getName(), p.getDescription(), p.getPrice(), p.isAvailable());
    }
}
```

### `catalog/Product.java` (Internal JPA Entity)
This class stays inside the module and connects directly to the DB. Notice how we use package-visibility (or protected) where we can.

```java
package com.example.modular.catalog;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "product_seq")
    @SequenceGenerator(name = "product_seq", sequenceName = "product_seq", allocationSize = 50)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(nullable = false, length = 1000)
    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(nullable = false)
    private boolean available = true;

    protected Product() {}

    public Product(String name, String description, BigDecimal price) {
        this.name = name;
        this.description = description;
        this.price = price;
    }

    public Long getId() { return id; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public BigDecimal getPrice() { return price; }
    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }
}
```

### `catalog/CatalogService.java` (Public Service)
Other modules (like `orders`) can autowire this service and interact with it directly since it is public and in the root package of module `catalog`.

```java
package com.example.modular.catalog;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional(readOnly = true)
public class CatalogService {

    private final ProductRepository productRepository; // Standard Spring Data JPA repo

    public CatalogService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductDto> findAllAvailable() {
        return productRepository.findByAvailableTrue().stream().map(ProductDto::from).toList();
    }

    public Optional<ProductDto> findById(Long id) {
        return productRepository.findById(id).map(ProductDto::from);
    }
    
    // (Other methods like create product)
}
```

---

## 6. Domain Events — Decoupling Modules

While direct service calls (like `OrderService` calling `CatalogService`) are fine for reading data, **state-changing operations should use Domain Events**. 

Spring Modulith upgrades Spring's standard `ApplicationEventPublisher`:
1. **Transactional publication**: events are saved to an `event_publication` database table in the exact same transaction that saves your business data.
2. **Guaranteed delivery**: if the app crashes, the event publication stays in the DB, and Modulith replays it once the server restarts.
3. **Externalization**: use `@Externalized("topic-name")` to automatically dump the event onto Kafka without writing extra generic publisher code.

<p align="center">
  <img src="../images/modulith_event_publication_sequence.png" alt="Transactional Event Publication Lifecycle" width="750"/>
</p>

### Publishing the Event: `orders/OrderPlacedEvent.java`

Keep event records completely free of references to other modules. They are plain data (primitives, strings). 

```java
package com.example.modular.orders;

import org.springframework.modulith.events.Externalized;

/**
 * Domain event published when an order is placed.
 * The @Externalized annotation automatically pushes this to the Kafka topic "orders.placed".
 */
@Externalized("orders.placed")
public record OrderPlacedEvent(Long orderId, Long productId, int quantity, String customerEmail) {
    static OrderPlacedEvent from(Order order) {
        return new OrderPlacedEvent(
                order.getId(),
                order.getProductId(),
                order.getQuantity(),
                order.getCustomerEmail());
    }
}
```

### Triggering the Event: `orders/OrderService.java`

Notice how `OrderService` uses standard Spring core `ApplicationEventPublisher`. It has ZERO idea who will be listening. It simply does its main job (creating the order) and publishes the event.

```java
package com.example.modular.orders;

import com.example.modular.catalog.CatalogService;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class OrderService {

    private final OrderRepository orderRepository;
    private final CatalogService catalogService; // Direct dependency on Catalog allowed for reading
    private final ApplicationEventPublisher eventPublisher;

    public OrderService(OrderRepository orderRepository, CatalogService catalogService, ApplicationEventPublisher eventPublisher) {
        this.orderRepository = orderRepository;
        this.catalogService = catalogService;
        this.eventPublisher = eventPublisher;
    }

    @Transactional
    public OrderSummary placeOrder(PlaceOrderRequest request) {
        // 1. Ask Catalog for price
        var product = catalogService.findById(request.productId())
                .orElseThrow(() -> new IllegalArgumentException("Product not found"));

        if (!product.available()) {
            throw new IllegalStateException("Product is not available");
        }

        // 2. Persist order
        var totalPrice = product.price().multiply(java.math.BigDecimal.valueOf(request.quantity()));
        var order = new Order(request.productId(), request.quantity(), request.customerEmail(), totalPrice);
        order = orderRepository.save(order);

        // 3. Modulith persists this event to event_publication within the same TX,
        // and safely dispatches to Kafka and internal listeners asynchronously.
        eventPublisher.publishEvent(OrderPlacedEvent.from(order));

        return OrderSummary.from(order);
    }
}
```

---

## 7. Listening to Events — `@ApplicationModuleListener`

Instead of `@EventListener` or `@TransactionalEventListener`, use `@ApplicationModuleListener`. It runs asynchronously in a **new transaction**, ensuring your main request thread is never held back by downstream notification tasks.

### `inventory/InventoryService.java` (Reduces stock on order)

This module listens to `OrderPlacedEvent` asynchronously to update warehouse inventory.

```java
package com.example.modular.inventory;

import com.example.modular.orders.OrderPlacedEvent;
import org.springframework.modulith.events.ApplicationModuleListener;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class InventoryService {

    private final StockItemRepository stockItemRepository;

    public InventoryService(StockItemRepository stockItemRepository) {
        this.stockItemRepository = stockItemRepository;
    }

    // Runs in the background, in an independent transaction
    @ApplicationModuleListener
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void onOrderPlaced(OrderPlacedEvent event) {
        stockItemRepository.findByProductId(event.productId()).ifPresentOrElse(
                stock -> {
                    boolean reserved = stock.reserve(event.quantity());
                    if (!reserved) {
                        // We could publish another event here (e.g. StockDepletedEvent)
                    }
                },
                () -> System.err.println("No stock item found!")
        );
    }
}
```

### `notifications/NotificationService.java` (Emails out alerts)

Another completely detached module that acts on the same event. We can completely delete the `notifications` package without modifying a single line of `orders` or `inventory`.

```java
package com.example.modular.notifications;

import com.example.modular.orders.OrderPlacedEvent;
import org.springframework.modulith.events.ApplicationModuleListener;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    @ApplicationModuleListener
    public void onOrderPlaced(OrderPlacedEvent event) {
        System.out.println("[NOTIFICATION] Sending order confirmation to " + event.customerEmail() + 
                           " for order #" + event.orderId());
        // Integrated with AWS SES, SendGrid, Twilio etc.
    }
}
```

---

## 8. Verifying Modularity with Tests (The Safety Net)

All of these boundaries mean nothing if developers can still accidentally import private `internal` classes or create circular dependencies (`catalog` imports `orders`, `orders` imports `catalog`).

Add this **JUnit 5 test**. If anyone breaks your architecture, the CI/CD build fails immediately.

```java
package com.example.modular;

import org.junit.jupiter.api.Test;
import org.springframework.modulith.core.ApplicationModules;
import org.springframework.modulith.docs.Documenter;

class ModularityTest {

    // Analyzes bytecode from application class root down
    static final ApplicationModules modules = ApplicationModules.of(Application.class);

    @Test
    void verifiesModuleStructure() {
        // Will throw an exception and fail the test if: 
        // 1. Module internals are accessed directly
        // 2. Circular dependencies exist
        modules.verify();
    }

    @Test
    void writeDocumentationSnippets() {
        // Automatically generates PlantUML diagrams and text maps in the target/ folder!
        new Documenter(modules).writeModulesAsPlantUml();
    }
}
```

---

## 9. The `event_publication` Table

When you include `spring-modulith-starter-jpa`, you must create an `event_publication` table in your database schema. If not enabled via auto-generation, it typically looks like this (in PostgreSQL/Flyway format):

```sql
CREATE TABLE IF NOT EXISTS event_publication (
    id               UUID         NOT NULL PRIMARY KEY,
    listener_id      TEXT         NOT NULL,
    event_type       TEXT         NOT NULL,
    serialized_event TEXT         NOT NULL,
    publication_date TIMESTAMPTZ  NOT NULL,
    completion_date  TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_event_pub_completion ON event_publication(completion_date);
```

When an event is fired, a row is inserted (`completion_date = NULL`). After a listener successfully finishes, Modulith updates the `completion_date`. Unfinished ones are what Modulith re-triggers when the app comes back online after a crash.

---

## 10. Full Architecture Map & Actuator

The complete application behaves like miniature microservices sharing a single JVM, network port, and database instance. 

<p align="center">
  <img src="../images/modulith_full_system_map.png" alt="Full System Interaction Map" width="800"/>
</p>

By activating `spring-modulith-actuator` in your properties, you expose a live `/actuator/modulith` JSON endpoint describing how everything connects.

---

## When to Use Spring Modulith

| Scenario | Good fit? |
|----------|----------|
| Monolith that is growing chaotic | ✅ Yes — enforce boundaries without the ops cost of microservices |
| Team wants clear domain ownership | ✅ Yes — each module maps to a bounded context |
| You plan to extract services later | ✅ Yes — modules are ready-made extraction units |
| Tiny app with 2–3 controllers | ⚠️ Overkill — plain layered architecture is sufficient |
| Already a distributed system | ⚠️ Better to apply patterns per-service than add Modulith on top |

---

## Further Reading

- [Spring Modulith Reference Documentation](https://docs.spring.io/spring-modulith/reference/)
- [Spring Modulith GitHub](https://github.com/spring-projects/spring-modulith)
- [Reference project: `Tests-with-Modular-SpringBoot`](https://github.com/chemacabeza/Tests-with-Modular-SpringBoot) — the live codebase these examples come from.
