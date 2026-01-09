package com.example.demo;

import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Simple REST Controller demonstrating basic Spring Boot REST endpoints
 *
 * Endpoints:
 * - GET  /api/hello          - Simple hello message
 * - GET  /api/hello/{name}   - Personalized greeting
 * - POST /api/hello          - Echo with timestamp
 * - GET  /api/status         - Application status
 *
 * @author José María Cabeza Rodríguez
 */
@RestController
@RequestMapping("/api")
public class HelloController {

    /**
     * Simple GET endpoint
     * Example: GET http://localhost:8080/api/hello
     */
    @GetMapping("/hello")
    public Map<String, Object> hello() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Hello from Spring Boot!");
        response.put("timestamp", LocalDateTime.now());
        response.put("version", "1.0.0");
        return response;
    }

    /**
     * GET endpoint with path variable
     * Example: GET http://localhost:8080/api/hello/John
     */
    @GetMapping("/hello/{name}")
    public Map<String, Object> helloName(@PathVariable String name) {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Hello, " + name + "!");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    /**
     * POST endpoint with request body
     * Example: POST http://localhost:8080/api/hello
     *          Body: {"name": "John", "message": "Hi there"}
     */
    @PostMapping("/hello")
    public Map<String, Object> helloPost(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        response.put("received", request);
        response.put("echo", "Received: " + request.get("message"));
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    /**
     * Application status endpoint
     * Example: GET http://localhost:8080/api/status
     */
    @GetMapping("/status")
    public Map<String, Object> status() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("application", "Minimal Spring Boot API");
        response.put("timestamp", LocalDateTime.now());
        response.put("javaVersion", System.getProperty("java.version"));
        response.put("springBootVersion", "3.2.1");
        return response;
    }
}
