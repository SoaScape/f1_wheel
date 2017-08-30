package telemetry.repository.impl;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

import org.springframework.stereotype.Repository;

import lombok.extern.log4j.Log4j;
import telemetry.domain.TelemetryDataF12017Impl;

@Repository
@Log4j
public class UdpRepositoryF12017Impl implements Runnable {
	@Override
	public void run() {
		try (final DatagramSocket datagramSocket = new DatagramSocket(20777)) {
			final byte[] b = new byte[1237];
			final DatagramPacket datagramPacket = new DatagramPacket(b,1237);
	
			while (true) {
				datagramSocket.receive(datagramPacket);
				byte[] data = datagramPacket.getData();
				final InetAddress address = datagramPacket.getAddress();
				final TelemetryDataF12017Impl telem = new TelemetryDataF12017Impl(data);
				log.info("Telem: " + telem);
	        }
		} catch(final IOException e) {
			log.error(e);
			e.printStackTrace();
			return;
		}
	}
}
