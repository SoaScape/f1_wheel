package telemetry.repository.impl;

import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import telemetry.domain.TelemetryDataF12017Impl;
import telemetry.domain.TelemetryDataF12018Impl;
import telemetry.domain.TelemetryDataF12018Impl.CarMotionData;
import telemetry.domain.TelemetryDataF12018Impl.PacketMotionData;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Repository
@Log4j
public class UdpProxyListener implements Runnable {
	public static final Object lock = new Object();

	@Autowired
	private UdpServer udpServer;

	@Value("${udp-listen-port}")
	private Integer udpListenPort;

	private static final Map<Byte, Integer> PACKET_SIZES;
	static {
		final Map<Byte, Integer> sizeMap = new HashMap<>();
		sizeMap.put((byte)0, 1341);
		sizeMap.put((byte)1, 147);
		sizeMap.put((byte)2, 841);
		sizeMap.put((byte)3, 25);
		sizeMap.put((byte)4, 1082);
		sizeMap.put((byte)5, 841);
		sizeMap.put((byte)6, 1085);
		sizeMap.put((byte)7, 1061);
		PACKET_SIZES = Collections.unmodifiableMap(sizeMap);
	}

	@Override
	public void run() {
		final int largestPacketSize = PACKET_SIZES.values().stream().reduce((x, y) -> x > y ? x : y).get();
		try (final DatagramSocket datagramSocket = new DatagramSocket(udpListenPort)) {
			final byte[] bytes = new byte[largestPacketSize];
			final DatagramPacket datagramPacket = new DatagramPacket(bytes, largestPacketSize);
			while (true) {
				datagramSocket.receive(datagramPacket);
				byte[] data = datagramPacket.getData();
                udpServer.sendProxyUdpData(data, PACKET_SIZES.get(data[3]));
			}
		} catch(final IOException e) {
			log.error(e);
			e.printStackTrace();
		}
	}
}
