package com.example.sales;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class SalesApplication {

    public static void main(String[] args) {
        SpringApplication.run(SalesApplication.class, args);
    }
}

@RestController
class SalesController {

    @GetMapping("/api/sales")
    public String getSales() {
        return "Sales Service - List of Sales";
    }

    @GetMapping("/api/sales/health")
    public String health() {
        return "Sales Service is running";
    }
}
