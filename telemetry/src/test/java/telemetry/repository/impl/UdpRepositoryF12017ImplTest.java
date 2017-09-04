package telemetry.repository.impl;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;

import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.springframework.test.util.ReflectionTestUtils;

import telemetry.domain.TelemetryDataF12017Impl;

public class UdpRepositoryF12017ImplTest {
	@InjectMocks
	private UdpRepositoryF12017Impl udpRepo;
	@Spy
	private UdpServer server;

	@Before
	public void setup() {		
		MockitoAnnotations.initMocks(this);
		ReflectionTestUtils.setField(udpRepo, "udpListenPort", 48879);
		ReflectionTestUtils.setField(udpRepo, "packetSize", 1237);
		ReflectionTestUtils.setField(udpRepo, "forwardUdpData", true);
		
		ReflectionTestUtils.setField(server, "proxyPorts", new ArrayList<Integer>());
		ReflectionTestUtils.setField(server, "udpListenPort", 48879);
		ReflectionTestUtils.setField(server, "ip", "127.0.0.1");
	}

	@Test
	public void test() {
		udpRepo.run();
		final ArgumentCaptor<byte[]> bytesCaptor = ArgumentCaptor.forClass(byte[].class);
		Mockito.doNothing().when(server).sendProxyUdpData(bytesCaptor.capture());
		server.run();
		ReflectionTestUtils.invokeMethod(server, "sendTestPacket");
		final TelemetryDataF12017Impl telem = new TelemetryDataF12017Impl(bytesCaptor.getValue());
		assertEquals(0, telem.getGear(), 0);
	}
}
