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
                final F12018Header header = new TelemetryDataF12018Impl.F12018Header(data);
                if(0 == header.getPacketId()) {
                    final PacketMotionData motion = new PacketMotionData(data);
                    log.info("F1 2018 Motion: " + motion);
                    final TelemetryDataF12017Impl f12017 = new TelemetryDataF12017Impl();
                    f12017.setAngVelX(motion.getAngularVelocityX());
                    f12017.setAngVelY(motion.getAngularVelocityY());
                    f12017.setAngVelZ(motion.getAngularVelocityZ());
                    f12017.setGforceLat(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getGForceLateral());
                    f12017.setGforceLon(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getGForceLongitudinal());
                    f12017.setGforceVert(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getGForceVertical());
                    f12017.setSuspPosFL(motion.getSuspensionPosition()[2]);
					f12017.setSuspPosFR(motion.getSuspensionPosition()[3]);
					f12017.setSuspPosRL(motion.getSuspensionPosition()[0]);
					f12017.setSuspPosRR(motion.getSuspensionPosition()[1]);

					f12017.setSuspVelFL(motion.getSuspensionVelocity()[2]);
					f12017.setSuspVelFR(motion.getSuspensionVelocity()[3]);
					f12017.setSuspVelRL(motion.getSuspensionVelocity()[0]);
					f12017.setSuspVelRR(motion.getSuspensionVelocity()[1]);

					f12017.setWheelSpeedFL(motion.getWheelSpeed()[2]);
					f12017.setWheelSpeedFR(motion.getWheelSpeed()[3]);
					f12017.setWheelSpeedRL(motion.getWheelSpeed()[0]);
					f12017.setWheelSpeedRR(motion.getWheelSpeed()[1]);

					f12017.setX(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldPositionX());
					f12017.setY(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldPositionY());
					f12017.setZ(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldPositionZ());

					f12017.setXd(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldForwardDirX());
					f12017.setYd(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldForwardDirY());
					f12017.setZd(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldForwardDirZ());

					f12017.setXr(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldRightDirX());
					f12017.setYr(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldRightDirY());
					f12017.setZr(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldRightDirZ());

					f12017.setXv(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldVelocityX());
					f12017.setYv(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldVelocityY());
					f12017.setZv(motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()].getWorldVelocityZ());

					// RL, RR, FL, FR
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
