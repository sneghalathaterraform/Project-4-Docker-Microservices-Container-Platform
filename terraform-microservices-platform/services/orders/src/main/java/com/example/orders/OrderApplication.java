package com.example.orders;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class OrderApplication {

    public static void main(String[] args) {
        SpringApplication.run(OrderApplication.class, args);
    }
}

@RestController
class OrderController {

    @GetMapping("/api/orders")
    public String getOrders() {
        return "Orders Service - List of Orders";
    }

    @GetMapping("/api/orders/health")
    public String health() {
        return "Orders Service is running";
    }
}
