package telemetry.repository.impl;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.*;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Repository;

import static telemetry.domain.ConversionUtils.*;

import lombok.extern.log4j.Log4j;

@Repository
@Log4j
public class UdpServer implements Runnable {
	@Value("#{${udp-proxy-ports}}")
	private List<Integer> proxyPorts;

	@Value("${udp-test-send-port}")
	private Integer udpTestSendPort;

	@Value("${transmit-ip}")
	private String transmitIp;

	@Value("${test-packet}")
	private Boolean sendTestPacket;

	@Value("${test-packet-names}")
	private String[] testPacketNames;

	private DatagramSocket datagramSocket;

	private int nextTestPacketIndex = 0;

	@Override
	public void run() {
		if(sendTestPacket) {
			log.info("Sending test packets...");
			while(true) {
				sendTestPacket();
			}
		}
	}

	public UdpServer() {
		try {
			datagramSocket = new DatagramSocket();
		} catch(final SocketException e) {
			log.error("Couldn't create UDP socket.", e);
		}
	}

	public void sendProxyUdpData(final byte[] data) {
        sendProxyUdpData(data, data.length);
	}

    public void sendProxyUdpData(final byte[] data, final int size) {
        proxyPorts.forEach(port -> sendUdpData(data, port, size));
    }

	private void sendUdpData(final byte[] data, final Integer port, final Integer size) {
		try {
			final DatagramPacket datagramPacket = new DatagramPacket(data, size, InetAddress.getByName(transmitIp), port);
			datagramSocket.send(datagramPacket);
			System.out.println("Tx->" + port + ": " + size);
            //printBytes(data);
		} catch(final IOException e) {
			datagramSocket.close();
			log.error(e);
		}
	}

	private void sendUdpData(final byte[] data, final Integer port) {
		sendUdpData(data, port, data.length);
	}
	
	private void sendTestPacket() {
		sendUdpData(getPcapBytes(testPacketNames[nextTestPacketIndex]), udpTestSendPort);
		if(++nextTestPacketIndex >= testPacketNames.length) {
			nextTestPacketIndex = 0;
		}
	}
	
	private byte[] getPcapBytes(final String fileName) {
		final ByteArrayOutputStream baos = new ByteArrayOutputStream();
	    final DataOutputStream dos = new DataOutputStream(baos);
	    byte[] data = new byte[4096];
	    try (final InputStream inputStream = new ClassPathResource(fileName).getInputStream()) {
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
