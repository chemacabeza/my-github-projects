package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Minimal Spring Boot Application
 *
 * This demonstrates the simplest possible Spring Boot REST API.
 * The @SpringBootApplication annotation enables:
 * - Auto-configuration
 * - Component scanning
 * - Configuration properties
 *
 * @author José María Cabeza Rodríguez
 * @version 1.0.0
 */
@SpringBootApplication
public class MinimalApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(MinimalApiApplication.java, args);
    }
}
