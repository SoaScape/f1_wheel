package telemetry.repository.impl;

import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import telemetry.domain.TelemetryDataF12017Impl;
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
			final byte[] bytes = new byte[TelemetryDataF12018Impl.MotionPacketSize];
			final DatagramPacket datagramPacket = new DatagramPacket(bytes, TelemetryDataF12018Impl.MotionPacketSize);
			while (true) {
				datagramSocket.receive(datagramPacket);
				byte[] data = datagramPacket.getData();
                if(0 == data[3]) { //Packetid = motion (0)
                    final PacketMotionData motion = new PacketMotionData(data);
                    log.info("F1 2018 Motion: " + motion);
                    final TelemetryDataF12017Impl f12017 = new TelemetryDataF12017Impl();
                    f12017.data.angVelX = motion.getAngularVelocityX();
                    f12017.data.angVelY = motion.getAngularVelocityY();
                    f12017.data.angVelZ = motion.getAngularVelocityZ();
                    f12017.data.gforceLat = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getGForceLateral();
                    f12017.data.gforceLon = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getGForceLongitudinal();
                    f12017.data.gforceVert = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getGForceVertical();
                    f12017.data.suspPosFL = motion.getSuspensionPosition()[2];
					f12017.data.suspPosFR = motion.getSuspensionPosition()[3];
					f12017.data.suspPosRL = motion.getSuspensionPosition()[0];
					f12017.data.suspPosRR = motion.getSuspensionPosition()[1];

					f12017.data.suspVelFL = motion.getSuspensionVelocity()[2];
					f12017.data.suspVelFR = motion.getSuspensionVelocity()[3];
					f12017.data.suspVelRL = motion.getSuspensionVelocity()[0];
					f12017.data.suspVelRR = motion.getSuspensionVelocity()[1];

					f12017.data.wheelSpeedFL = motion.getWheelSpeed()[2];
					f12017.data.wheelSpeedFR = motion.getWheelSpeed()[3];
					f12017.data.wheelSpeedRL = motion.getWheelSpeed()[0];
					f12017.data.wheelSpeedRR = motion.getWheelSpeed()[1];

					f12017.data.x = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldPositionX();
					f12017.data.y = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldPositionY();
					f12017.data.z = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldPositionZ();

					f12017.data.xd = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldForwardDirX();
					f12017.data.yd = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldForwardDirY();
					f12017.data.zd = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldForwardDirZ();

					f12017.data.xr = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldRightDirX();
					f12017.data.yr = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldRightDirY();
					f12017.data.zr = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldRightDirZ();

					f12017.data.xv = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldVelocityX();
					f12017.data.yv = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldVelocityY();
					f12017.data.zv = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldVelocityZ();

					// RL, RR, FL, FR
                    udpServer.sendProxyUdpData(f12017.data.toByteArray());
                }
				notifyAll();
			}
		} catch(final IOException e) {
			log.error(e);
			e.printStackTrace();
		}
	}
}
