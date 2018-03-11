package com.cnid.springboot.queue;

import java.util.List;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

    @RestController
    public class CustomerController {
        private static final Logger logger = LoggerFactory.getLogger(QueueApplication.class);

        @Autowired
        private CustomerRepository customerRepository;

        @Autowired
        private RabbitTemplate rabbitTemplate;

        @RequestMapping(value = "/customers", method = RequestMethod.POST)
        public ResponseEntity<Customer> putCustomer(@RequestParam String firstName, @RequestParam String lastName) {
            Customer customer = new Customer(firstName, lastName);
            this.customerRepository.save(customer);
            return ResponseEntity.ok().body(customer);
        }

        @GetMapping(value = "/customers/{lastName}")
        public ResponseEntity<List<Customer>> getCustomer(@PathVariable String lastName) {
            List<Customer> customer = customerRepository.findByLastName(lastName);
            this.rabbitTemplate.convertAndSend("foo", customer.get(0).getFirstName() + ' ' + customer.get(0).getLastName());
            return ResponseEntity.ok().body(customer);
        }

        @GetMapping(value = "/customers")
        public ResponseEntity<List<Customer>> getCustomers() {
            List<Customer> customerList = customerRepository.findAll();
            this.rabbitTemplate.convertAndSend("foo", "Process All");
            return ResponseEntity.ok().body(customerList);
        }
}
