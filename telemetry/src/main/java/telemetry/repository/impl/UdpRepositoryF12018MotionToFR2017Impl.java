package telemetry.repository.impl;

import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import telemetry.domain.TelemetryDataF12018Impl.*;
import telemetry.domain.TelemetryDataF12018Impl;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;

@Repository
@Log4j
public class UdpRepositoryF12018MotionToFR2017Impl implements Runnable {
	public static final Object lock = new Object();

	@Autowired
	private UdpServer udpServer;

	@Value("${udp-listen-port}")
	private Integer udpListenPort;

	@Override
	public void run() {
		try (final DatagramSocket datagramSocket = new DatagramSocket(udpListenPort)) {
			final byte[] bytes = new byte[TelemetryDataF12018Impl.Motion_Packet_Size];
			final DatagramPacket datagramPacket = new DatagramPacket(bytes, TelemetryDataF12018Impl.Motion_Packet_Size);
			while (true) {
				datagramSocket.receive(datagramPacket);
				byte[] data = datagramPacket.getData();
                F12018Header header = new F12018Header(data);
                if(0 == header.getPacketId()) {
                    final PacketMotionData motion = new PacketMotionData(data);
                    log.info("Motion: " + motion);
                    udpServer.sendProxyUdpData(data);
                }
				notifyAll();
			}
		} catch(final IOException e) {
			log.error(e);
			e.printStackTrace();
		}
	}
}
