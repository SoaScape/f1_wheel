package telemetry.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Controller;

import lombok.extern.log4j.Log4j;
import telemetry.repository.impl.UdpRepositoryF12017Impl;
import telemetry.repository.impl.UdpServer;

@Controller
@Log4j
public class MainController implements CommandLineRunner {
	@Autowired
	private UdpRepositoryF12017Impl repo;
	@Autowired
	private UdpServer server;

	@Override
	public void run(final String... args) {
		new Thread(repo).start();
		new Thread(server).start();
	}
}
