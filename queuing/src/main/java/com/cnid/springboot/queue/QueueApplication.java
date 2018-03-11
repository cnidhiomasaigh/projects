package com.cnid.springboot.queue;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.annotation.RabbitHandler;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.messaging.handler.annotation.Payload;


@SpringBootApplication
@RabbitListener(queues = "foo")
public class QueueApplication implements CommandLineRunner {

private static final Logger logger = LoggerFactory.getLogger(QueueApplication.class);

	@Autowired
	private CustomerRepository customerRepository;

	@Autowired
	private ConfigurableApplicationContext context;

	@Value("${app.property.env.name}")
	private  String envName;

	@Bean
	public Queue fooQueue() {
		return new Queue("foo");
	}
	
	public static void main(String[] args) {
		logger.debug("--Application Started --");
		SpringApplication.run(QueueApplication.class, args);
	}

	@Override
	public void run(String... strings) throws Exception {
		logger.debug("--Application Running " + envName + " --");
		this.customerRepository.save(new Customer("Alice", "Smith"));
		this.customerRepository.save(new Customer("Bob", "Smith"));
		this.customerRepository.save(new Customer("Mary", "Dempsey"));
	}

	@RabbitHandler
	public void process(@Payload String payload) {
		logger.debug("PROCESS QUEUE DATA: " + new Date() + ": " + payload);
	}

}
