package com.example.autowiringmutiple;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.List;

@SpringBootApplication
public class AutowiringMutipleApplication implements CommandLineRunner {
	@Autowired
	List<MyComponent> cc;

	public static void main(String[] args) {
		SpringApplication.run(AutowiringMutipleApplication.class, args);

	}

	@Override
	public void run(String... args) throws Exception {
		cc.forEach(MyComponent::act);
	}
}
