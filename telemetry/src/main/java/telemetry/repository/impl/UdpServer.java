package telemetry.repository.impl;

import static org.junit.Assert.fail;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Repository;

import lombok.extern.log4j.Log4j;

@Repository
@Log4j
public class UdpServer implements Runnable {
	@Value("#{${udp-proxy-ports}}")
	private List<Integer> proxyPorts;

	@Value("${udp-listen-port}")
	private Integer udpListenPort;

	@Value("${ip}")
	private String ip;

	@Value("${test-packet}")
	private Boolean sendTestPacket;

	@Override
	public void run() {
		if(sendTestPacket) {
			log.info("Sending test packets...");
			while(true) {
				sendTestPacket();
			}
		}
	}

	public void sendProxyUdpData(final byte[] data) {
		proxyPorts.forEach(port -> sendUdpData(data, port));
	}

	private void sendUdpData(final byte[] data, final Integer port) {
		try (final DatagramSocket datagramSocket = new DatagramSocket()) {
			final DatagramPacket datagramPacket = new DatagramPacket(data, data.length, InetAddress.getByName(ip), port);
			datagramSocket.send(datagramPacket);
			datagramSocket.close();
		} catch(final IOException e) {
			log.error(e);
		}
	}
	
	private void sendTestPacket() {
		sendUdpData(getPcapBytes(), udpListenPort);
	}
	
	private byte[] getPcapBytes() {
		final ByteArrayOutputStream baos = new ByteArrayOutputStream();
	    final DataOutputStream dos = new DataOutputStream(baos);
	    byte[] data = new byte[4096];
	    try (final InputStream inputStream = new ClassPathResource("sample-packet.bin").getInputStream()) {
		    int count = inputStream.read(data);
		    while(count != -1) {
		        dos.write(data, 0, count);
		        count = inputStream.read(data);
		    }
		    return baos.toByteArray();
	    } catch(final IOException e) {
	    	log.error(e.getMessage());
	    	return null;
	    }
	}
}
