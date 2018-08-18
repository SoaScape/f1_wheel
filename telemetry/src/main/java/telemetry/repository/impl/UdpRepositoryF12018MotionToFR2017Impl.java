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

	private void addHeaderData(final TelemetryDataF12017Impl f12017, final F12018Header header) {
		f12017.setTime(header.getSessionTime());
		f12017.setPlayerCarIndex(header.getPlayerCarIndex());
		f12017.setEra(2017f);
		f12017.setMaxGears(8f);
	}

	@Override
	public void run() {
		try (final DatagramSocket datagramSocket = new DatagramSocket(udpListenPort)) {
			DatagramPacket datagramPacket;
            boolean receivedMotionData = false;
            boolean receivedCarData = false;
            boolean recievedLapData = false;
            TelemetryDataF12017Impl f12017 = new TelemetryDataF12017Impl();
			while (true) {
                datagramPacket = new DatagramPacket(new byte[TelemetryDataF12018Impl.MOTION_PACKET_SIZE], TelemetryDataF12018Impl.MOTION_PACKET_SIZE);
				datagramSocket.receive(datagramPacket);
				byte[] data = datagramPacket.getData();
                if(0 == data[3]) { //Packetid = motion (0)
					final MotionDataPacket motion = new MotionDataPacket(data);
					final CarMotionData playerCar = motion.getCarMotionData()[motion.getHeader().getPlayerCarIndex()];

					addHeaderData(f12017, motion.getHeader());

					f12017.setAngVelX(motion.getAngularVelocityX());
					f12017.setAngVelY(motion.getAngularVelocityY());
					f12017.setAngVelZ(motion.getAngularVelocityZ());
					f12017.setGforceLat(playerCar.getGForceLateral());
					f12017.setGforceLon(playerCar.getGForceLongitudinal());
					f12017.setGforceVert(playerCar.getGForceVertical());
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

					f12017.setX(playerCar.getWorldPositionX());
					f12017.setY(playerCar.getWorldPositionY());
					f12017.setZ(playerCar.getWorldPositionZ());

					f12017.setXd(playerCar.getWorldForwardDirX());
					f12017.setYd(playerCar.getWorldForwardDirY());
					f12017.setZd(playerCar.getWorldForwardDirZ());

					f12017.setXr(playerCar.getWorldRightDirX());
					f12017.setYr(playerCar.getWorldRightDirY());
					f12017.setZr(playerCar.getWorldRightDirZ());

					f12017.setXv(playerCar.getWorldVelocityX());
					f12017.setYv(playerCar.getWorldVelocityY());
					f12017.setZv(playerCar.getWorldVelocityZ());

					f12017.setMYaw(playerCar.getYaw());
					f12017.setMPitch(playerCar.getPitch());
					f12017.setMRoll(playerCar.getRoll());
					f12017.setMXLocalVelocity(motion.getLocalVelocityX());
					f12017.setMYLocalVelocity(motion.getLocalVelocityY());
					f12017.setMZLocalVelocity(motion.getLocalVelocityZ());
					f12017.setMSuspAccelerationRL(motion.getSuspensionAcceleration()[0]);
					f12017.setMSuspAccelerationRR(motion.getSuspensionAcceleration()[1]);
					f12017.setMSuspAccelerationFL(motion.getSuspensionAcceleration()[2]);
					f12017.setMSuspAccelerationFR(motion.getSuspensionAcceleration()[3]);
					f12017.setMAngAccX(motion.getAngularAccelerationX());
					f12017.setMAngAccY(motion.getAngularAccelerationY());
					f12017.setMAngAccZ(motion.getAngularAccelerationZ());

					TelemetryDataF12017Impl.CarData f12017PlayerCar = f12017.getCarData()[motion.getHeader().getPlayerCarIndex()];
					f12017PlayerCar.setWorldPositionX(playerCar.getWorldPositionX());
					f12017PlayerCar.setWorldPositionY(playerCar.getWorldPositionY());
					f12017PlayerCar.setWorldPositionZ(playerCar.getWorldPositionZ());
					f12017PlayerCar.setCarPosition((byte) 1);

					receivedMotionData = true;
				} else if (2 == data[3]) { //Lapdata packet
					final LapDataPacket allCarsLapData = new LapDataPacket(data);
					final IndividualLapData lapData = allCarsLapData.getLapData()[allCarsLapData.getHeader().getPlayerCarIndex()];
					addHeaderData(f12017, allCarsLapData.getHeader());

					f12017.setLapDistance(lapData.getM_lapDistance());
					f12017.setLap(lapData.getM_currentLapNum());
					f12017.setLapTime(lapData.getM_currentLapTime());
					f12017.setLastLapTime(lapData.getM_lastLapTime());
					f12017.setSector1Time(lapData.getM_sector1Time());
					f12017.setSector2Time(lapData.getM_sector2Time());
					f12017.setTotalDistance(lapData.getM_totalDistance());
					f12017.setCarPosition(lapData.getM_carPosition());
					f12017.setTotalLaps(70); // Only available in session packet twice a second

					final TelemetryDataF12017Impl.CarData[] carData = f12017.getCarData();
					for(int i = 0; i < carData.length; i++) {
						carData[i].setCarPosition(allCarsLapData.getLapData()[i].getM_carPosition());
						carData[i].setBestLapTime(allCarsLapData.getLapData()[i].getM_bestLapTime());
						carData[i].setCurrentLapNum(allCarsLapData.getLapData()[i].getM_currentLapNum());
						carData[i].setCurrentLapInvalid(allCarsLapData.getLapData()[i].getM_currentLapInvalid());
						carData[i].setCurrentLapTime(allCarsLapData.getLapData()[i].getM_currentLapTime());
						carData[i].setLapDistance(allCarsLapData.getLapData()[i].getM_lapDistance());
						carData[i].setLastLapTime(allCarsLapData.getLapData()[i].getM_lastLapTime());
						carData[i].setPenalties(allCarsLapData.getLapData()[i].getM_penalties());
						carData[i].setInPits(allCarsLapData.getLapData()[i].getM_pitStatus());
						carData[i].setDriverId(allCarsLapData.getLapData()[i].getM_driverStatus());
						carData[i].setSector(allCarsLapData.getLapData()[i].getM_sector());
						carData[i].setSector1Time(allCarsLapData.getLapData()[i].getM_sector1Time());
						carData[i].setSector2Time(allCarsLapData.getLapData()[i].getM_sector2Time());
					}
					recievedLapData = true;
                } else if(6 == data[3]) { //Packetid = car telemetery
                    final CarDataPacket carsData = new CarDataPacket(data);
                    final IndividialCarData carData = carsData.getCarsData()[carsData.getHeader().getPlayerCarIndex()];

					addHeaderData(f12017, carsData.getHeader());

                    f12017.setRevLightsPercent(carData.getM_revLightsPercent());
                    f12017.setSpeed(carData.getM_speed());
                    f12017.setBrake(carData.getM_brake());
					f12017.setSteering(carData.getM_steer());
					f12017.setThrottle(carData.getM_throttle());
                    f12017.setClutch(carData.getM_clutch());
                    f12017.setGear(carData.getM_gear());
                    f12017.setDrs(carData.getM_drs());
                    f12017.setTyrePressuresRL(carData.getM_tyresPressure()[0]);
					f12017.setTyrePressuresRR(carData.getM_tyresPressure()[1]);
					f12017.setTyrePressuresFL(carData.getM_tyresPressure()[2]);
					f12017.setTyrePressuresFR(carData.getM_tyresPressure()[3]);

                    receivedCarData = true;
                }

                if(receivedCarData && receivedMotionData && recievedLapData) {
                    final byte[] out = f12017.toByteArray();
                    System.out.println("len: " + out.length + ", gear: " + Float.toString(f12017.getGear()));
                    udpServer.sendProxyUdpData(out, TelemetryDataF12017Impl.F1_2017_PACKET_SIZE);
                    receivedCarData = false;
                    receivedMotionData = false;
					recievedLapData = false;
                    f12017 = new TelemetryDataF12017Impl();
                }
			}
		} catch(final IOException e) {
			log.error(e);
			e.printStackTrace();
		}
	}
}
