package telemetry.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Controller;
import telemetry.repository.impl.UdpProxyListener;
import telemetry.repository.impl.UdpRepositoryF12018MotionToFR2017Impl;
import telemetry.repository.impl.UdpServer;

@Controller
public class MainController implements CommandLineRunner {
	@Autowired
	private UdpRepositoryF12018MotionToFR2017Impl repo;
	@Autowired
	private UdpProxyListener proxy;
	@Autowired
	private UdpServer server;
	@Value("${simple-proxy}")
	private Boolean simpleProxy;
	@Value("${conversion-service}")
	private Boolean conversionService;

	@Override
	public void run(final String... args) {
		new Thread(server).start();
		new Thread(repo).start();
		if(simpleProxy) {
			new Thread(proxy).start();
		}
	}
}
