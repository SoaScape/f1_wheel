package telemetry.repository.impl;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

import org.springframework.stereotype.Repository;

import lombok.extern.log4j.Log4j;

@Repository
@Log4j
public class UdpServer implements Runnable {
	@Override
	public void run() {
		try {
			final DatagramSocket datagramSocket = new DatagramSocket();	
			final String dataString = "hello tester";
			final DatagramPacket datagramPacket = new DatagramPacket(dataString.getBytes(),dataString.getBytes().length, InetAddress.getByName("127.0.0.1"), 20777);
			//final DatagramPacket datagramPacket = new DatagramPacket(getPcapBytes(), getPcapBytes().length, InetAddress.getByName("127.0.0.1"), 20777);
			datagramSocket.send(datagramPacket);
			datagramSocket.close();
		} catch(final IOException e) {
			log.error(e);
		}
	}
	
	private byte[] getPcapBytes() {
		final ByteArrayOutputStream baos = new ByteArrayOutputStream();
	    final DataOutputStream dos = new DataOutputStream(baos);
	    byte[] data = new byte[4096];
	    try (final FileInputStream inputStream = new FileInputStream(new File("/packet.bin"))) {
		    int count = inputStream.read(data);
		    while(count != -1) {
		        dos.write(data, 0, count);
		        count = inputStream.read(data);
		    }
		    return baos.toByteArray();
	    } catch(final IOException e) {
	    	log.error(e);
	    	return null;
	    }
	}
}
