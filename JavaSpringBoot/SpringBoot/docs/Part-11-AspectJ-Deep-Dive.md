# Part 11: AspectJ Deep Dive

> **Source:** *AspectJ in Action* (2nd Edition) — Manning Publications

---

## 🎯 Learning Objectives

- Understand AOP concepts: crosscutting concerns, join points, pointcuts, advice
- Master AspectJ syntax and the join point model
- Apply aspects for logging, security, transactions, and caching
- Integrate AspectJ with Spring Framework
- Design reusable, maintainable crosscutting solutions

---

## 1. Aspect-Oriented Programming Concepts

### 1.1 The Problem — Crosscutting Concerns

```
Traditional code has concerns scattered across modules:

  UserService          OrderService         PaymentService
  ┌──────────┐         ┌──────────┐         ┌──────────┐
  │ security │         │ security │         │ security │  ← Crosscutting
  │ logging  │         │ logging  │         │ logging  │  ← Crosscutting
  │ ──────── │         │ ──────── │         │ ──────── │
  │ BUSINESS │         │ BUSINESS │         │ BUSINESS │  ← Core concern
  │ LOGIC    │         │ LOGIC    │         │ LOGIC    │
  │ ──────── │         │ ──────── │         │ ──────── │
  │ caching  │         │ caching  │         │ caching  │  ← Crosscutting
  │ tx mgmt  │         │ tx mgmt  │         │ tx mgmt  │  ← Crosscutting
  └──────────┘         └──────────┘         └──────────┘
```

AOP modularizes these crosscutting concerns into **aspects**.

### 1.2 Core AOP Terminology

| Term | Definition | Example |
|------|-----------|---------|
| **Aspect** | Module encapsulating a crosscutting concern | `LoggingAspect`, `SecurityAspect` |
| **Join Point** | A point in program execution | Method call, field access, exception throw |
| **Pointcut** | A predicate selecting specific join points | "All methods in `*Service` classes" |
| **Advice** | Code executed at a join point | Before, After, Around |
| **Weaving** | Process of applying aspects to target code | Compile-time, load-time, or runtime |
| **Introduction** | Adding new methods/fields to existing classes | Adding `Auditable` interface |

---

## 2. The Join Point Model

### 2.1 Types of Join Points

| Join Point | AspectJ | Spring AOP |
|-----------|---------|------------|
| Method execution | ✅ | ✅ |
| Method call | ✅ | ❌ |
| Constructor execution | ✅ | ❌ |
| Field access (get/set) | ✅ | ❌ |
| Exception handler | ✅ | ❌ |
| Static initialization | ✅ | ❌ |

### 2.2 Pointcut Designators

```java
// Method execution pointcut
@Pointcut("execution(* com.example.service.*.*(..))")
public void serviceLayerMethods() {}

// Common pointcut patterns:

// Any public method
execution(public * *(..))

// Any method starting with "get"
execution(* get*(..))

// Any method in a specific package
execution(* com.example.service.*.*(..))

// Any method with specific return type
execution(String *(..))

// Any method with specific parameter types
execution(* *(String, int))

// Within a specific class
within(com.example.service.UserService)

// Within a package
within(com.example.service..*)

// Target object type
target(com.example.service.UserService)

// Method annotated with a specific annotation
@annotation(org.springframework.transaction.annotation.Transactional)

// Class annotated with a specific annotation
@within(org.springframework.stereotype.Service)

// Bean name (Spring AOP only)
bean(userService)
bean(*Service)
```

### 2.3 Combining Pointcuts

```java
@Pointcut("execution(* com.example.service.*.*(..))")
public void inServiceLayer() {}

@Pointcut("execution(* com.example.dao.*.*(..))")
public void inDataAccessLayer() {}

@Pointcut("inServiceLayer() || inDataAccessLayer()")
public void inBusinessLayer() {}

@Pointcut("inServiceLayer() && !execution(* get*(..))")
public void nonGetterServiceMethods() {}
```

---

## 3. Advice Types

### 3.1 Before Advice

```java
@Aspect
@Component
public class LoggingAspect {

    @Before("execution(* com.example.service.*.*(..))")
    public void logBefore(JoinPoint joinPoint) {
        String method = joinPoint.getSignature().toShortString();
        Object[] args = joinPoint.getArgs();
        System.out.println("→ Entering " + method + " with args: " + Arrays.toString(args));
    }
}
```

### 3.2 After Advice

```java
// After returning (success)
@AfterReturning(
    pointcut = "execution(* com.example.service.UserService.findById(..))",
    returning = "result"
)
public void logAfterReturning(JoinPoint joinPoint, Object result) {
    System.out.println("← " + joinPoint.getSignature().toShortString() + " returned: " + result);
}

// After throwing (exception)
@AfterThrowing(
    pointcut = "execution(* com.example.service.*.*(..))",
    throwing = "ex"
)
public void logAfterThrowing(JoinPoint joinPoint, Exception ex) {
    System.err.println("✗ " + joinPoint.getSignature().toShortString() + " threw: " + ex.getMessage());
}

// After (finally — runs always)
@After("execution(* com.example.service.*.*(..))")
public void logAfter(JoinPoint joinPoint) {
    System.out.println("◆ " + joinPoint.getSignature().toShortString() + " completed");
}
```

### 3.3 Around Advice — Most Powerful

```java
@Around("execution(* com.example.service.*.*(..))")
public Object measureExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
    long start = System.currentTimeMillis();

    try {
        Object result = joinPoint.proceed();  // Call the actual method
        return result;
    } finally {
        long elapsed = System.currentTimeMillis() - start;
        System.out.println("⏱ " + joinPoint.getSignature().toShortString()
            + " took " + elapsed + "ms");
    }
}
```

### Advice Execution Order

```
@Around (before proceed)
  @Before
    ─── Target Method Executes ───
  @AfterReturning (if no exception)
  @AfterThrowing (if exception)
  @After (always)
@Around (after proceed)
```

---

## 4. Spring AOP vs. AspectJ

| Feature | Spring AOP | AspectJ |
|---------|-----------|---------|
| Mechanism | Runtime proxies | Bytecode weaving |
| Join points | Method execution only | All (fields, constructors, etc.) |
| Performance | Slight proxy overhead | Zero overhead after weaving |
| Configuration | Annotation-based | @AspectJ or .aj files |
| Self-invocation | ❌ (proxy bypassed) | ✅ |
| Requires | Spring context | AspectJ compiler |

### Spring AOP Proxy Limitation

```java
@Service
public class OrderService {
    @Transactional
    public void placeOrder(Order order) {
        // ...
        validateOrder(order);  // ⚠️ Self-invocation — NOT proxied!
    }

    @Transactional
    public void validateOrder(Order order) {
        // This @Transactional is IGNORED when called from placeOrder()
    }
}

// Fix: Inject self-reference or restructure
```

---

## 5. Practical AOP Patterns

### 5.1 Annotation-Driven Aspects

```java
// Custom annotation
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Timed {}

// Aspect using the annotation
@Aspect
@Component
public class TimingAspect {
    @Around("@annotation(com.example.annotation.Timed)")
    public Object timeMethod(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.nanoTime();
        try {
            return joinPoint.proceed();
        } finally {
            long elapsed = System.nanoTime() - start;
            System.out.printf("⏱ %s: %.2f ms%n",
                joinPoint.getSignature().toShortString(),
                elapsed / 1_000_000.0);
        }
    }
}

// Usage — just annotate the method
@Timed
public List<User> findAllUsers() {
    return userRepository.findAll();
}
```

### 5.2 Retry Aspect

```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Retry {
    int maxAttempts() default 3;
    long delayMs() default 1000;
}

@Aspect
@Component
public class RetryAspect {
    @Around("@annotation(retry)")
    public Object retryOnFailure(ProceedingJoinPoint jp, Retry retry) throws Throwable {
        int attempts = 0;
        while (true) {
            try {
                attempts++;
                return jp.proceed();
            } catch (Exception e) {
                if (attempts >= retry.maxAttempts()) throw e;
                Thread.sleep(retry.delayMs());
                System.out.println("Retrying " + jp.getSignature().toShortString()
                    + " attempt " + (attempts + 1));
            }
        }
    }
}
```

### 5.3 Caching Aspect

```java
@Aspect
@Component
public class SimpleCacheAspect {
    private final Map<String, Object> cache = new ConcurrentHashMap<>();

    @Around("@annotation(org.springframework.cache.annotation.Cacheable)")
    public Object cacheResult(ProceedingJoinPoint jp) throws Throwable {
        String key = jp.getSignature().toShortString() + Arrays.toString(jp.getArgs());
        return cache.computeIfAbsent(key, k -> {
            try {
                return jp.proceed();
            } catch (Throwable t) {
                throw new RuntimeException(t);
            }
        });
    }
}
```

### 5.4 Security Aspect

```java
@Aspect
@Component
public class SecurityAspect {

    @Before("@annotation(requiresRole)")
    public void checkRole(JoinPoint jp, RequiresRole requiresRole) {
        String currentRole = SecurityContext.getCurrentUserRole();
        if (!requiresRole.value().equals(currentRole)) {
            throw new AccessDeniedException(
                "Method " + jp.getSignature().toShortString()
                + " requires role: " + requiresRole.value());
        }
    }
}
```

---

## 6. Aspect Ordering

```java
@Aspect
@Component
@Order(1)  // Lower number = higher priority (runs first)
public class SecurityAspect { /* ... */ }

@Aspect
@Component
@Order(2)
public class LoggingAspect { /* ... */ }

@Aspect
@Component
@Order(3)
public class PerformanceAspect { /* ... */ }

// Execution order:
// Security → Logging → Performance → METHOD → Performance → Logging → Security
```

---

## 7. Best Practices

1. **Keep aspects focused** — one concern per aspect
2. **Use annotation-driven pointcuts** (`@annotation`) for clarity
3. **Be precise with pointcuts** — avoid `execution(* *(..))`
4. **Order aspects explicitly** with `@Order`
5. **Don't use `@Around` when `@Before`/`@After` suffice** — simpler is better
6. **Be aware of Spring AOP limitations** — no self-invocation, method execution only
7. **Test aspects independently** — verify pointcuts match expected join points
8. **Don't put business logic in aspects** — only crosscutting concerns
9. **Log the aspect name** in output for debugging

---

## 8. Exercises

1. **Audit Aspect:** Create an `@Auditable` annotation + aspect that logs who changed what and when
2. **Rate Limiting:** Build a `@RateLimit(requests=10, periodSeconds=60)` annotation that throttles method calls
3. **Validation Aspect:** Create an aspect that validates `@NotNull`-annotated parameters before method execution
4. **Performance Dashboard:** Build an aspect that collects execution time statistics per method, queryable via an endpoint
5. **Circuit Breaker:** Implement a `@CircuitBreaker` annotation that opens after N consecutive failures

---

## 📖 References

- *AspectJ in Action* (2nd Ed), Ramnivas Laddad — Complete AspectJ reference
- [Spring AOP Documentation](https://docs.spring.io/spring-framework/reference/core/aop.html)
- [AspectJ Programming Guide](https://www.eclipse.org/aspectj/doc/released/progguide/)

---

[← Part 10: Hibernate Deep Dive](Part-10-Hibernate-Deep-Dive.md) | [Back to Course Index](../README.md)
