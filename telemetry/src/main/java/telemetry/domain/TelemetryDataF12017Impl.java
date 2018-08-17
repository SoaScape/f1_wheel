package telemetry.domain;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import lombok.extern.log4j.Log4j;
import lombok.Data;
import static telemetry.domain.ConversionUtils.*;

@Log4j
@Data
public class TelemetryDataF12017Impl implements TelemetryData {
	public static final Integer F1_2017_PACKET_SIZE = 1289;

    // Wheel order for all arrays: 0=rear left, 1=rear right, 2=front left, 3=front right
    private float time = 0f;
    private float lapTime = 0f;
    private float lapDistance = 0f;
    private float totalDistance = 0f;
    private float x = 0f;
    private float y = 0f;
    private float z = 0f;
    private float speed = 0f;
    private float xv = 0f;
    private float yv = 0f;
    private float zv = 0f;
    private float xr = 0f;
    private float yr = 0f;
    private float zr = 0f;
    private float xd = 0f;
    private float yd = 0f;
    private float zd = 0f;
    private float suspPosRL = 0f;
    private float suspPosRR = 0f;
    private float suspPosFL = 0f;
    private float suspPosFR = 0f;
    private float suspVelRL = 0f;
    private float suspVelRR = 0f;
    private float suspVelFL = 0f;
    private float suspVelFR = 0f;
    private float wheelSpeedRL = 0f;
    private float wheelSpeedRR = 0f;
    private float wheelSpeedFL = 0f;
    private float wheelSpeedFR = 0f;
    private float throttle = 0f;
    private float steering = 0f;
    private float brake = 0f;
    private float clutch = 0f;
    private float gear = 0f;
    private float gforceLat = 0f;
    private float gforceLon = 0f;
    private float lap = 0f;
    private float engineRate = 0f;
    private float sliProNativeSupport = 0f;
    private float carPosition = 0f;
    private float kersLevel = 0f;
    private float maxKersLevel = 0f;
    private float drs = 0f;
    private float tractionControl = 0f;
    private float abs = 0f;
    private float fuelInTank = 0f;
    private float fuelCapacity = 0f;
    private float inPits = 0f;
    private float sector = 0f;
    private float sector1Time = 0f;
    private float sector2Time = 0f;
    private float brakeTempsRL = 0f;
    private float brakeTempsRR = 0f;
    private float brakeTempsFL = 0f;
    private float brakeTempsFR = 0f;
    private float tyrePressuresRL = 0f;
    private float tyrePressuresRR = 0f;
    private float tyrePressuresFL = 0f;
    private float tyrePressuresFR = 0f;
    private float teamInfo = 0f;
    private float totalLaps = 0f;
    private float trackSize = 0f;
    private float lastLapTime = 0f;
    private float maxRpm = 0f;
    private float idleRpm = 0f;
    private float maxGears = 0f;
    private float sessionType = 0f;
    private float drsAvailable = 0f;
    private float trackId = 0f;
    private float fiaFlags = 0f;
    private float era = 0f;
    private float engineTemp = 0f;
    private float gforceVert = 0f;
    private float angVelX = 0f;
    private float angVelY = 0f;
    private float angVelZ = 0f;
    private byte tyreTempsRL = 0;
    private byte tyreTempsRR = 0;
    private byte tyreTempsFL = 0;
    private byte tyreTempsFR = 0;
    private byte tyreWearRL = 0;
    private byte tyreWearRR = 0;
    private byte tyreWearFL = 0;
    private byte tyreWearFR = 0;
    private byte tyreCompound = 0;
    private byte frontBrakeBias = 0;
    private byte fuelMix = 0;
    private byte currentLapInvalid = 0;
    private byte tyreDamageRL = 0;
    private byte tyreDamageRR = 0;
    private byte tyreDamageFL = 0;
    private byte tyreDamageFR = 0;
    private byte frontLeftWingDamage = 0;
    private byte frontRightWingDamage = 0;
    private byte rearWingDamage = 0;
    private byte engineDamage = 0;
    private byte gearBoxDamage = 0;
    private byte exhaustDamage = 0;
    private byte pitLimiterStatus = 0;
    private byte pitSpeedLimit = 0;
    private float sessionTimeLeft = 0f;
    private byte revLightsPercent = 0;
    private byte isSpectating = 0;
    private byte spectatorCarIndex = 0;
    private byte numCars = 0;
    private byte playerCarIndex = 0;
    private CarData[] carData = new CarData[20];
    private float mYaw = 0f;  // NEW (v1.8)
    private float mPitch = 0f;  // NEW (v1.8)
    private float mRoll = 0f;  // NEW (v1.8)
    private float mXLocalVelocity = 0f;          // NEW (v1.8) Velocity in local space
    private float mYLocalVelocity = 0f;          // NEW (v1.8) Velocity in local space
    private float mZLocalVelocity = 0f;          // NEW (v1.8) Velocity in local space
    private float mSuspAccelerationRL = 0f;      // NEW (v1.8) RL, RR, FL, FR
    private float mSuspAccelerationRR = 0f;      // NEW (v1.8) RL, RR, FL, FR
    private float mSuspAccelerationFL = 0f;      // NEW (v1.8) RL, RR, FL, FR
    private float mSuspAccelerationFR = 0f;      // NEW (v1.8) RL, RR, FL, FR
    private float mAngAccX = 0f;                 // NEW (v1.8) angular acceleration x-component
    private float mAngAccY = 0f;                 // NEW (v1.8) angular acceleration y-component
    private float mAngAccZ = 0f;                 // NEW (v1.8) angular acceleration z-component

	public TelemetryDataF12017Impl(){
	    for(int i = 0; i < carData.length; i++) {
	        carData[i] = new CarData();
        }
	}

	public byte[] toByteArray() {
		try(ByteArrayOutputStream bos = new ByteArrayOutputStream()){
			bos.write(float2ByteArray(time));
			bos.write(float2ByteArray(time));
			bos.write(float2ByteArray(lapTime));
			bos.write(float2ByteArray(lapDistance));
			bos.write(float2ByteArray(totalDistance));
			bos.write(float2ByteArray(x));
			bos.write(float2ByteArray(y));
			bos.write(float2ByteArray(z));
			bos.write(float2ByteArray(speed));
			bos.write(float2ByteArray(xv));
			bos.write(float2ByteArray(yv));
			bos.write(float2ByteArray(zv));
			bos.write(float2ByteArray(xr));
			bos.write(float2ByteArray(yr));
			bos.write(float2ByteArray(zr));
			bos.write(float2ByteArray(xd));
			bos.write(float2ByteArray(yd));
			bos.write(float2ByteArray(zd));
			bos.write(float2ByteArray(suspPosRL));
			bos.write(float2ByteArray(suspPosRR));
			bos.write(float2ByteArray(suspPosFL));
			bos.write(float2ByteArray(suspPosFR));
			bos.write(float2ByteArray(suspVelRL));
			bos.write(float2ByteArray(suspVelRR));
			bos.write(float2ByteArray(suspVelFL));
			bos.write(float2ByteArray(suspVelFR));
			bos.write(float2ByteArray(wheelSpeedRL));
			bos.write(float2ByteArray(wheelSpeedRR));
			bos.write(float2ByteArray(wheelSpeedFL));
			bos.write(float2ByteArray(wheelSpeedFR));
			bos.write(float2ByteArray(throttle));
			bos.write(float2ByteArray(steering));
			bos.write(float2ByteArray(brake));
			bos.write(float2ByteArray(clutch));
			bos.write(float2ByteArray(gear));
			bos.write(float2ByteArray(gforceLat));
			bos.write(float2ByteArray(gforceLon));
			bos.write(float2ByteArray(lap));
			bos.write(float2ByteArray(engineRate));
			bos.write(float2ByteArray(sliProNativeSupport));
			bos.write(float2ByteArray(carPosition));
			bos.write(float2ByteArray(kersLevel));
			bos.write(float2ByteArray(maxKersLevel));
			bos.write(float2ByteArray(drs));
			bos.write(float2ByteArray(tractionControl));
			bos.write(float2ByteArray(abs));
			bos.write(float2ByteArray(fuelInTank));
			bos.write(float2ByteArray(fuelCapacity));
			bos.write(float2ByteArray(inPits));
			bos.write(float2ByteArray(sector));
			bos.write(float2ByteArray(sector1Time));
			bos.write(float2ByteArray(sector2Time));
			bos.write(float2ByteArray(brakeTempsRL));
			bos.write(float2ByteArray(brakeTempsRR));
			bos.write(float2ByteArray(brakeTempsFL));
			bos.write(float2ByteArray(brakeTempsFR));
			bos.write(float2ByteArray(tyrePressuresRL));
			bos.write(float2ByteArray(tyrePressuresRR));
			bos.write(float2ByteArray(tyrePressuresFL));
			bos.write(float2ByteArray(tyrePressuresFR));
			bos.write(float2ByteArray(teamInfo));
			bos.write(float2ByteArray(totalLaps));
			bos.write(float2ByteArray(trackSize));
			bos.write(float2ByteArray(lastLapTime));
			bos.write(float2ByteArray(maxRpm));
			bos.write(float2ByteArray(idleRpm));
			bos.write(float2ByteArray(maxGears));
			bos.write(float2ByteArray(sessionType));
			bos.write(float2ByteArray(drsAvailable));
			bos.write(float2ByteArray(trackId));
			bos.write(float2ByteArray(fiaFlags));
			bos.write(float2ByteArray(era));
			bos.write(float2ByteArray(engineTemp));
			bos.write(float2ByteArray(gforceVert));
			bos.write(float2ByteArray(angVelX));
			bos.write(float2ByteArray(angVelY));
			bos.write(float2ByteArray(angVelZ));

			byte[] b = new byte[24];
			b[0] = tyreTempsRL;
			b[1] = tyreTempsRR;
			b[2] = tyreTempsFL;
			b[3] = tyreTempsFR;
			b[4] = tyreWearRL;
			b[5] = tyreWearRR;
			b[6] = tyreWearFL;
			b[7] = tyreWearFR;
			b[8] = tyreCompound;
			b[9] = frontBrakeBias;
			b[10] = fuelMix;
			b[11] = currentLapInvalid;
			b[12] = tyreDamageRL;
			b[13] = tyreDamageRR;
			b[14] = tyreDamageFL;
			b[15] = tyreDamageFR;
			b[16] = frontLeftWingDamage;
			b[17] = frontRightWingDamage;
			b[18] = rearWingDamage;
			b[19] = engineDamage;
			b[20] = gearBoxDamage;
			b[21] = exhaustDamage;
			b[22] = pitLimiterStatus;
			b[23] = pitSpeedLimit;
			bos.write(b);

			bos.write(float2ByteArray(sessionTimeLeft));

			b = new byte[5];
			b[0] = revLightsPercent;
			b[1] = isSpectating;
			b[2] = spectatorCarIndex;
			b[3] = numCars;
			b[4] = playerCarIndex;

			for(int i = 0; i < carData.length; i++) {
				bos.write(float2ByteArray(carData[i].worldPositionX)); // world co-ordinates of vehicle
				bos.write(float2ByteArray(carData[i].worldPositionY));
				bos.write(float2ByteArray(carData[i].worldPositionZ));
				bos.write(float2ByteArray(carData[i].lastLapTime));
				bos.write(float2ByteArray(carData[i].currentLapTime));
				bos.write(float2ByteArray(carData[i].bestLapTime));
				bos.write(float2ByteArray(carData[i].sector1Time));
				bos.write(float2ByteArray(carData[i].sector2Time));
				bos.write(float2ByteArray(carData[i].lapDistance));

				b = new byte[9];
				b[0] = carData[i].driverId;
				b[1] = carData[i].teamId;
				b[2] = carData[i].carPosition; // UPDATED: track positions of vehicle
				b[3] = carData[i].currentLapNum;
				b[4] = carData[i].tyreCompound;
				b[5] = carData[i].inPits; // 0 = none, 1 = pitting, 2 = in pit area
				b[6] = carData[i].sector; // 0 = sector1, 1 = sector2, 2 = sector3
				b[7] = carData[i].currentLapInvalid; // current lap invalid - 0 = valid, 1 = invalid
				b[8] = carData[i].penalties; // NEW: accumulated tim
				bos.write(b);
			}
			
			bos.write(float2ByteArray(mYaw));
            bos.write(float2ByteArray(mPitch));
            bos.write(float2ByteArray(mRoll));
            bos.write(float2ByteArray(mXLocalVelocity));
            bos.write(float2ByteArray(mYLocalVelocity));
            bos.write(float2ByteArray(mZLocalVelocity));
            bos.write(float2ByteArray(mSuspAccelerationRL));
            bos.write(float2ByteArray(mSuspAccelerationRR));
            bos.write(float2ByteArray(mSuspAccelerationFL));
            bos.write(float2ByteArray(mSuspAccelerationFR));
            bos.write(float2ByteArray(mAngAccX));
            bos.write(float2ByteArray(mAngAccY));
            bos.write(float2ByteArray(mAngAccZ));
			return bos.toByteArray();
		} catch(final IOException e) {
			log.error(e);
			return new byte[0];
		}
	}

	@Data
	public class CarData {
		private float worldPositionX = 0f; // world co-ordinates of vehicle
		private float worldPositionY = 0f;
		private float worldPositionZ = 0f;
		private float lastLapTime = 0f;
		private float currentLapTime = 0f;
		private float bestLapTime = 0f;
		private float sector1Time = 0f;
		private float sector2Time = 0f;
		private float lapDistance = 0f;
		private byte driverId = 0;
		private byte teamId = 0;
		private byte carPosition = 0; // UPDATED: track positions of vehicle
		private byte currentLapNum = 0;
		private byte tyreCompound = 0;
		private byte inPits = 0; // 0 = none, 1 = pitting, 2 = in pit area
		private byte sector = 0; // 0 = sector1, 1 = sector2, 2 = sector3
		private byte currentLapInvalid = 0; // current lap invalid - 0 = valid, 1 = invalid
		private byte penalties = 0; // NEW: accumulated time penalties in seconds to be added
	}
}
