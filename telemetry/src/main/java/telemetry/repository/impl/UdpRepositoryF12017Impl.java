package telemetry.repository.impl;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import lombok.extern.log4j.Log4j;
import telemetry.domain.CodemastersLookups;
import telemetry.domain.TelemetryDataF12017Impl;

@Repository
@Log4j
public class UdpRepositoryF12017Impl implements Runnable {
	@Autowired
	private UdpServer udpServer;

	@Autowired
	private CodemastersLookups codemastersLookups;

	@Value("${udp-listen-port}")
	private Integer udpListenPort;

	@Value("${packet-size}")
	private Integer packetSize;

	@Value("${forward-udp-data}")
	private Boolean forwardUdpData;
	
	@Value("${proxy-only}")
	private Boolean proxyOnly;

	@Override
	public void run() {
		try (final DatagramSocket datagramSocket = new DatagramSocket(udpListenPort)) {
			final byte[] bytes = new byte[packetSize];
			final DatagramPacket datagramPacket = new DatagramPacket(bytes, packetSize);
			while (true) {
				datagramSocket.receive(datagramPacket);
				byte[] data = datagramPacket.getData();
				if(!proxyOnly) {
					final TelemetryDataF12017Impl telem = new TelemetryDataF12017Impl(data, codemastersLookups);
					log.info("Telem: " + telem);
				}
				if(forwardUdpData) {
					udpServer.sendProxyUdpData(data);
				}
	        }
		} catch(final IOException e) {
			log.error(e);
			e.printStackTrace();
			return;
		}
	}
}
