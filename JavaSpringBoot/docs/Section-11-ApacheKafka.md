# Section 11: Apache Kafka Integration with Spring Boot

This guide provides a complete, copy-pasteable tutorial for integrating **[Apache Kafka](https://kafka.apache.org/documentation/)** into a Spring Boot application. 

Apache Kafka is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, and data integration.

By following this guide, you will build a runnable Spring Boot application that acts as both a **Kafka Producer** (sending messages) and a **Kafka Consumer** (receiving messages), fully containerized via Docker.

---

## 1. Project Setup (Maven `pom.xml`)

We need the Spring Boot Web starter (to expose an endpoint to trigger messages) and the Spring Kafka starter.

```xml
    <dependencies>
        <!-- Spring Boot Web (For our REST Controller) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Spring Kafka -> Official Spring integration for Apache Kafka -->
        <dependency>
            <groupId>org.springframework.kafka</groupId>
            <artifactId>spring-kafka</artifactId>
        </dependency>
    </dependencies>
```

---

## 2. Docker Setup

We will configure a multi-container environment including Kafka (using KRaft, meaning Zookeeper is no longer required) and our Spring Boot application.

### `docker-compose.yml`

Create this in the root of your project.

```yaml
version: '3.8'

services:
  kafka:
    image: confluentinc/cp-kafka:7.4.0
    container_name: demo_kafka_broker
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:29092,PLAINTEXT_HOST://localhost:9092
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:29092,PLAINTEXT_HOST://0.0.0.0:9092
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@kafka:29093
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      # A consistent cluster ID for KRaft mode
      CLUSTER_ID: 'MkU3OEVBNTcwNTJENDM2Qk'
    ports:
      - "9092:9092"

  app:
    build: .
    container_name: kafka_spring_app
    ports:
      - "8080:8080"
    depends_on:
      - kafka
    environment:
      # Pass the Dockerized Kafka broker address to Spring Boot
      - SPRING_KAFKA_BOOTSTRAP_SERVERS=kafka:29092
```

### `Dockerfile`

```dockerfile
# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the execution environment
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 3. Configuration (`application.properties`)

Spring Boot auto-configures Kafka using properties. We point the broker URL to the environment variable set by Docker Compose. We also set up generic String serialization for both sending and receiving.

```properties
# Connection to the broker
spring.kafka.bootstrap-servers=${SPRING_KAFKA_BOOTSTRAP_SERVERS:localhost:9092}

# Consumer group ID (Required for @KafkaListener)
spring.kafka.consumer.group-id=my-app-consumer-group

# Ensure consumers start reading from the earliest unread message
spring.kafka.consumer.auto-offset-reset=earliest

# Key/Value Serializers (Converting Java Strings to Kafka Bytes)
spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.producer.value-serializer=org.apache.kafka.common.serialization.StringSerializer

# Key/Value Deserializers (Converting Kafka Bytes back to Java Strings)
spring.kafka.consumer.key-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.value-deserializer=org.apache.kafka.common.serialization.StringDeserializer
```

---

## 4. The Code

### 1. The Kafka Producer (Sending Events)

We use Spring's `KafkaTemplate` to send messages to a specific topic.

```java
package com.luv2code.springboot.kafka;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
public class KafkaProducerService {

    private static final Logger LOGGER = LoggerFactory.getLogger(KafkaProducerService.class);
    private final KafkaTemplate<String, String> kafkaTemplate;

    public KafkaProducerService(KafkaTemplate<String, String> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void sendMessage(String message) {
        LOGGER.info(String.format("$$$ -> Producing message --> %s", message));
        
        // Send the message to incredibly fast distributed log called "my-demo-topic"
        kafkaTemplate.send("my-demo-topic", message);
    }
}
```

### 2. The Kafka Consumer (Listening for Events)

We use the `@KafkaListener` annotation. Spring instantly wraps this method in a background thread that constantly polls the broker. The moment the Producer sends a message to `my-demo-topic`, this method triggers.

```java
package com.luv2code.springboot.kafka;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class KafkaConsumerService {

    private static final Logger LOGGER = LoggerFactory.getLogger(KafkaConsumerService.class);

    @KafkaListener(topics = "my-demo-topic", groupId = "my-app-consumer-group")
    public void consume(String message) {
        LOGGER.info(String.format("$$$ -> Consumer received message <-- %s", message));
    }
}
```

### 3. The REST Controller (Triggering the process)

We expose an API endpoint so a user can push a message to Kafka via HTTP.

```java
package com.luv2code.springboot.kafka;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class KafkaController {

    private final KafkaProducerService producerService;

    public KafkaController(KafkaProducerService producerService) {
        this.producerService = producerService;
    }

    // Example URL: http://localhost:8080/kafka/publish?message=HelloWorld
    @GetMapping("/kafka/publish")
    public ResponseEntity<String> publishMessage(@RequestParam("message") String message) {
        producerService.sendMessage(message);
        return ResponseEntity.ok("Message sent to the Apache Kafka Broker successfully!");
    }
}
```

### 4. The Application Entry Point

```java
package com.luv2code.springboot.kafka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class KafkaDemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(KafkaDemoApplication.class, args);
    }
}
```

---

## 5. Running & Testing

1. **Boot up the cluster:** Start entirely automated environment via Docker:
   ```bash
   docker compose up --build
   ```

2. Wait for the `app` container to finish initializing Tomcat on port 8080 and connect to the Kafka broker on port 29092.

3. **Publish a message:** Open your browser or use `curl` to fire an HTTP request. This request is instantly sent by our `KafkaProducerService` into the Kafka Broker.
   ```bash
   curl "http://localhost:8080/kafka/publish?message=Hello+Apache+Kafka"
   ```

4. **Verify the Consumer:** Look at the Docker terminal logs. Within milliseconds, you should see the `KafkaConsumerService` pulling the message back out of your local Kafka cluster:
   ```text
   $$$ -> Producing message --> Hello Apache Kafka
   $$$ -> Consumer received message <-- Hello Apache Kafka
   ```
