package telemetry.repository.impl;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.HashMap;

import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.springframework.test.util.ReflectionTestUtils;

import lombok.val;
import telemetry.domain.CodemastersLookups;
import telemetry.domain.TelemetryDataF12017Impl;

public class UdpRepositoryF12017ImplTest {
	@InjectMocks
	private UdpRepositoryF12017Impl udpRepo;
	@Spy
	private UdpServer server;
	
	private CodemastersLookups lookups = new CodemastersLookups();

	@Before
	public void setup() {		
		MockitoAnnotations.initMocks(this);
		ReflectionTestUtils.setField(udpRepo, "udpListenPort", 48879);
		ReflectionTestUtils.setField(udpRepo, "packetSize", 1237);
		ReflectionTestUtils.setField(udpRepo, "forwardUdpData", true);
		ReflectionTestUtils.setField(udpRepo, "sendTestPacket", false);
		ReflectionTestUtils.setField(udpRepo, "proxyOnly", false);
		ReflectionTestUtils.setField(udpRepo, "codemastersLookups", lookups);

		ReflectionTestUtils.setField(server, "proxyPorts", new ArrayList<Integer>());
		ReflectionTestUtils.setField(server, "udpListenPort", 48879);
		ReflectionTestUtils.setField(server, "ip", "127.0.0.1");
		ReflectionTestUtils.setField(server, "sendTestPacket", true);

		final HashMap<Integer, String> fuelLookup = new HashMap<>();
		final HashMap<Integer, String> trackLookup = new HashMap<>();
		final HashMap<Integer, String> teamLookup = new HashMap<>();
		
		fuelLookup.put(0, "LEAN");
		fuelLookup.put(1, "NORM");
		fuelLookup.put(2, "RICH");
		fuelLookup.put(3, "QUAL");
		
		trackLookup.put(0, "Melbourne");
		trackLookup.put(1, "Sepang");
		trackLookup.put(2, "Shanghai");
		trackLookup.put(3, "Bahrain");
		trackLookup.put(4, "Spain");
		trackLookup.put(5, "Monaco");
		trackLookup.put(6, "Montreal");
		trackLookup.put(7, "Silverstone");
		trackLookup.put(8, "Hockenheim");
		trackLookup.put(9, "Hungaroring");
		trackLookup.put(10, "Spa");
		trackLookup.put(11, "Monza");
		trackLookup.put(12, "Singapore");
		trackLookup.put(13, "Suzuka");
		trackLookup.put(14, "Abu Dhabi");
		trackLookup.put(15, "Texas");
		trackLookup.put(16, "Brazil");
		trackLookup.put(17, "Austria");
		trackLookup.put(18, "Sochi");
		trackLookup.put(19, "Mexico");
		trackLookup.put(20, "Baku");
		trackLookup.put(21, "Sakhir Short");
		trackLookup.put(22, "Silverstone Short");
		trackLookup.put(23, "Texas Short");
		trackLookup.put(24, "Suzuka Short");
		
		teamLookup.put(4, "Mercedes");
		teamLookup.put(0, "Redbull");
		teamLookup.put(1, "Ferrari");
		teamLookup.put(6, "Force India");
		teamLookup.put(7, "Williams");
		teamLookup.put(2, "McLaren");
		teamLookup.put(8, "Toro Rosso");
		teamLookup.put(11, "Haas");
		teamLookup.put(3, "Renault");
		teamLookup.put(5, "Sauber");
			
		lookups.setFuelMixLookup(fuelLookup);
		lookups.setTrackLookup(trackLookup);
		lookups.setTeamLookup(teamLookup);
	}

	@Test
	public synchronized void test() throws InterruptedException {
		final ArgumentCaptor<byte[]> bytesCaptor = ArgumentCaptor.forClass(byte[].class);
		Mockito.doNothing().when(server).sendProxyUdpData(bytesCaptor.capture());

		val udpRxThread = new Thread(udpRepo);
		udpRxThread.start();
		val udpTxThread = new Thread(server);
		udpTxThread.start();
		synchronized(udpRepo.lock) {
			wait();
		}
		final TelemetryDataF12017Impl telem = new TelemetryDataF12017Impl(bytesCaptor.getValue(), lookups);
		assertEquals(1, telem.getGear(), 0);
		assertEquals("Mercedes", telem.getTeamName());
		assertEquals("Spaz", telem.getTrackName());	
	}
}
