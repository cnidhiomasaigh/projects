package com.cnid.springboot.postgres;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@SpringBootApplication
public class Application implements CommandLineRunner {
private static final Logger logger = LoggerFactory.getLogger(Application.class);
	@Autowired
	private CustomerRepository customerRepository;

	public static void main(String[] args) {
		logger.debug("--Application Started--");
		SpringApplication.run(Application.class, args);
	}

	@Override
	public void run(String... strings) throws Exception {
		Customer customer = new Customer();
		customer.setFirstName("Jane");
		customer.setLastName("Doe");
		
		customerRepository.save(customer);
	}

	@RestController
	public static class CustomerController {

		@Autowired
		private CustomerRepository customerRepository;

		@GetMapping(value = "/customers/{name}")
		public ResponseEntity<List<Customer>> applicationData(@PathVariable String lastName) {
			logger.debug("--Get By Name--");
			List<Customer> customer = customerRepository.findByLastName(lastName);
			return ResponseEntity.ok().body(customer);
		}

		@GetMapping(value = "/customers")
		public ResponseEntity<List<Customer>> apps() {
			logger.debug("--Get all Customers--");
			List<Customer> customerList = customerRepository.findAll();
			return ResponseEntity.ok(customerList);
		}
	}
}
