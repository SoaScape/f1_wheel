package telemetry.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Controller;
import telemetry.repository.impl.UdpProxyListener;
import telemetry.repository.impl.UdpRepositoryF12019MotionToFR2017Impl;
import telemetry.repository.impl.UdpServer;

@Controller
public class MainController implements CommandLineRunner {
	@Autowired
	private UdpRepositoryF12019MotionToFR2017Impl conversionService;
	@Autowired
	private UdpProxyListener simpleProxy;
	@Autowired
	private UdpServer server;
	@Value("${simple-proxy}")
	private Boolean runSimpleProxy;
	@Value("${conversion-service}")
	private Boolean runConversionService;

	@Override
	public void run(final String... args) {
		new Thread(server).start();
		if(runConversionService) {
			new Thread(conversionService).start();
		}
		if(runSimpleProxy) {
			new Thread(simpleProxy).start();
		}
	}
}
