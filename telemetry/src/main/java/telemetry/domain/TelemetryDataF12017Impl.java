package telemetry.domain;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;

import lombok.extern.log4j.Log4j;
import org.springframework.util.ReflectionUtils;
import lombok.Data;
import lombok.ToString;

@Log4j
@Data
@ToString(exclude="codemastersLookups")
public class TelemetryDataF12017Impl implements TelemetryData {
	private static final Integer FLOAT_SIZE_IN_BYTES = Float.SIZE / Byte.SIZE;
	private static final Integer CAR_DATA_SIZE_BYTES = 45;

	private CodemastersLookups codemastersLookups;

	public static final Integer F12017PacketSize = 1289;
	public F12017Data data = new F12017Data();

	public class F12017Data {
		// Wheel order for all arrays: 0=rear left, 1=rear right, 2=front left, 3=front right
		public float time = 0f;
		public float lapTime = 0f;
		public float lapDistance = 0f;
		public float totalDistance = 0f;
		public float x = 0f;
		public float y = 0f;
		public float z = 0f;
		public float speed = 0f;
		public float xv = 0f;
		public float yv = 0f;
		public float zv = 0f;
		public float xr = 0f;
		public float yr = 0f;
		public float zr = 0f;
		public float xd = 0f;
		public float yd = 0f;
		public float zd = 0f;
		public float suspPosRL = 0f;
		public float suspPosRR = 0f;
		public float suspPosFL = 0f;
		public float suspPosFR = 0f;
		public float suspVelRL = 0f;
		public float suspVelRR = 0f;
		public float suspVelFL = 0f;
		public float suspVelFR = 0f;
		public float wheelSpeedRL = 0f;
		public float wheelSpeedRR = 0f;
		public float wheelSpeedFL = 0f;
		public float wheelSpeedFR = 0f;
		public float throttle = 0f;
		public float steering = 0f;
		public float brake = 0f;
		public float clutch = 0f;
		public float gear = 0f;
		public float gforceLat = 0f;
		public float gforceLon = 0f;
		public float lap = 0f;
		public float engineRate = 0f;
		public float sliProNativeSupport = 0f;
		public float carPosition = 0f;
		public float kersLevel = 0f;
		public float maxKersLevel = 0f;
		public float drs = 0f;
		public float tractionControl = 0f;
		public float abs = 0f;
		public float fuelInTank = 0f;
		public float fuelCapacity = 0f;
		public float inPits = 0f;
		public float sector = 0f;
		public float sector1Time = 0f;
		public float sector2Time = 0f;
		public float brakeTempsRL = 0f;
		public float brakeTempsRR = 0f;
		public float brakeTempsFL = 0f;
		public float brakeTempsFR = 0f;
		public float tyrePressuresRL = 0f;
		public float tyrePressuresRR = 0f;
		public float tyrePressuresFL = 0f;
		public float tyrePressuresFR = 0f;
		public float teamInfo = 0f;
		public float totalLaps = 0f;
		public float trackSize = 0f;
		public float lastLapTime = 0f;
		public float maxRpm = 0f;
		public float idleRpm = 0f;
		public float maxGears = 0f;
		public float sessionType = 0f;
		public float drsAvailable = 0f;
		public float trackId = 0f;
		public float fiaFlags = 0f;
		public float era = 0f;
		public float engineTemp = 0f;
		public float gforceVert = 0f;
		public float angVelX = 0f;
		public float angVelY = 0f;
		public float angVelZ = 0f;
		public byte tyreTempsRL = 0;
		public byte tyreTempsRR = 0;
		public byte tyreTempsFL = 0;
		public byte tyreTempsFR = 0;
		public byte tyreWearRL = 0;
		public byte tyreWearRR = 0;
		public byte tyreWearFL = 0;
		public byte tyreWearFR = 0;
		public byte tyreCompound = 0;
		public byte frontBrakeBias = 0;
		public byte fuelMix = 0;
		public byte currentLapInvalid = 0;
		public byte tyreDamageRL = 0;
		public byte tyreDamageRR = 0;
		public byte tyreDamageFL = 0;
		public byte tyreDamageFR = 0;
		public byte frontLeftWingDamage = 0;
		public byte frontRightWingDamage = 0;
		public byte rearWingDamage = 0;
		public byte engineDamage = 0;
		public byte gearBoxDamage = 0;
		public byte exhaustDamage = 0;
		public byte pitLimiterStatus = 0;
		public byte pitSpeedLimit = 0;
		public float sessionTimeLeft = 0f;
		public byte revLightsPercent = 0;
		public byte isSpectating = 0;
		public byte spectatorCarIndex = 0;
		public byte numCars = 0;
		public byte playerCarIndex = 0;
		public CarData[] carData = new CarData[20];
	}

	public TelemetryDataF12017Impl(){
	    for(int i = 0; i < data.carData.length; i++) {
	        data.carData[i] = new CarData();
        }
	}

	public static byte [] long2ByteArray (long value) {
		return ByteBuffer.allocate(8).putLong(value).array();
	}

	public static byte [] float2ByteArray (float value) {
		return ByteBuffer.allocate(4).putFloat(value).array();
	}

	public byte[] toByteArray() {
		try(ByteArrayOutputStream bos = new ByteArrayOutputStream()){
			bos.write(float2ByteArray(data.time));
			bos.write(float2ByteArray(data.time));
			bos.write(float2ByteArray(data.lapTime));
			bos.write(float2ByteArray(data.lapDistance));
			bos.write(float2ByteArray(data.totalDistance));
			bos.write(float2ByteArray(data.x));
			bos.write(float2ByteArray(data.y));
			bos.write(float2ByteArray(data.z));
			bos.write(float2ByteArray(data.speed));
			bos.write(float2ByteArray(data.xv));
			bos.write(float2ByteArray(data.yv));
			bos.write(float2ByteArray(data.zv));
			bos.write(float2ByteArray(data.xr));
			bos.write(float2ByteArray(data.yr));
			bos.write(float2ByteArray(data.zr));
			bos.write(float2ByteArray(data.xd));
			bos.write(float2ByteArray(data.yd));
			bos.write(float2ByteArray(data.zd));
			bos.write(float2ByteArray(data.suspPosRL));
			bos.write(float2ByteArray(data.suspPosRR));
			bos.write(float2ByteArray(data.suspPosFL));
			bos.write(float2ByteArray(data.suspPosFR));
			bos.write(float2ByteArray(data.suspVelRL));
			bos.write(float2ByteArray(data.suspVelRR));
			bos.write(float2ByteArray(data.suspVelFL));
			bos.write(float2ByteArray(data.suspVelFR));
			bos.write(float2ByteArray(data.wheelSpeedRL));
			bos.write(float2ByteArray(data.wheelSpeedRR));
			bos.write(float2ByteArray(data.wheelSpeedFL));
			bos.write(float2ByteArray(data.wheelSpeedFR));
			bos.write(float2ByteArray(data.throttle));
			bos.write(float2ByteArray(data.steering));
			bos.write(float2ByteArray(data.brake));
			bos.write(float2ByteArray(data.clutch));
			bos.write(float2ByteArray(data.gear));
			bos.write(float2ByteArray(data.gforceLat));
			bos.write(float2ByteArray(data.gforceLon));
			bos.write(float2ByteArray(data.lap));
			bos.write(float2ByteArray(data.engineRate));
			bos.write(float2ByteArray(data.sliProNativeSupport));
			bos.write(float2ByteArray(data.carPosition));
			bos.write(float2ByteArray(data.kersLevel));
			bos.write(float2ByteArray(data.maxKersLevel));
			bos.write(float2ByteArray(data.drs));
			bos.write(float2ByteArray(data.tractionControl));
			bos.write(float2ByteArray(data.abs));
			bos.write(float2ByteArray(data.fuelInTank));
			bos.write(float2ByteArray(data.fuelCapacity));
			bos.write(float2ByteArray(data.inPits));
			bos.write(float2ByteArray(data.sector));
			bos.write(float2ByteArray(data.sector1Time));
			bos.write(float2ByteArray(data.sector2Time));
			bos.write(float2ByteArray(data.brakeTempsRL));
			bos.write(float2ByteArray(data.brakeTempsRR));
			bos.write(float2ByteArray(data.brakeTempsFL));
			bos.write(float2ByteArray(data.brakeTempsFR));
			bos.write(float2ByteArray(data.tyrePressuresRL));
			bos.write(float2ByteArray(data.tyrePressuresRR));
			bos.write(float2ByteArray(data.tyrePressuresFL));
			bos.write(float2ByteArray(data.tyrePressuresFR));
			bos.write(float2ByteArray(data.teamInfo));
			bos.write(float2ByteArray(data.totalLaps));
			bos.write(float2ByteArray(data.trackSize));
			bos.write(float2ByteArray(data.lastLapTime));
			bos.write(float2ByteArray(data.maxRpm));
			bos.write(float2ByteArray(data.idleRpm));
			bos.write(float2ByteArray(data.maxGears));
			bos.write(float2ByteArray(data.sessionType));
			bos.write(float2ByteArray(data.drsAvailable));
			bos.write(float2ByteArray(data.trackId));
			bos.write(float2ByteArray(data.fiaFlags));
			bos.write(float2ByteArray(data.era));
			bos.write(float2ByteArray(data.engineTemp));
			bos.write(float2ByteArray(data.gforceVert));
			bos.write(float2ByteArray(data.angVelX));
			bos.write(float2ByteArray(data.angVelY));
			bos.write(float2ByteArray(data.angVelZ));

			byte[] b = new byte[24];
			b[0] = data.tyreTempsRL;
			b[1] = data.tyreTempsRR;
			b[2] = data.tyreTempsFL;
			b[3] = data.tyreTempsFR;
			b[4] = data.tyreWearRL;
			b[5] = data.tyreWearRR;
			b[6] = data.tyreWearFL;
			b[7] = data.tyreWearFR;
			b[8] = data.tyreCompound;
			b[9] = data.frontBrakeBias;
			b[10] = data.fuelMix;
			b[11] = data.currentLapInvalid;
			b[12] = data.tyreDamageRL;
			b[13] = data.tyreDamageRR;
			b[14] = data.tyreDamageFL;
			b[15] = data.tyreDamageFR;
			b[16] = data.frontLeftWingDamage;
			b[17] = data.frontRightWingDamage;
			b[18] = data.rearWingDamage;
			b[19] = data.engineDamage;
			b[20] = data.gearBoxDamage;
			b[21] = data.exhaustDamage;
			b[22] = data.pitLimiterStatus;
			b[23] = data.pitSpeedLimit;
			bos.write(b);

			bos.write(float2ByteArray(data.sessionTimeLeft));

			b = new byte[5];
			b[0] = data.revLightsPercent;
			b[1] = data.isSpectating;
			b[2] = data.spectatorCarIndex;
			b[3] = data.numCars;
			b[4] = data.playerCarIndex;

			for(int i = 0; i < data.carData.length; i++) {

				bos.write(float2ByteArray(data.carData[i].worldPositionX)); // world co-ordinates of vehicle
				bos.write(float2ByteArray(data.carData[i].worldPositionY));
				bos.write(float2ByteArray(data.carData[i].worldPositionZ));
				bos.write(float2ByteArray(data.carData[i].lastLapTime));
				bos.write(float2ByteArray(data.carData[i].currentLapTime));
				bos.write(float2ByteArray(data.carData[i].bestLapTime));
				bos.write(float2ByteArray(data.carData[i].sector1Time));
				bos.write(float2ByteArray(data.carData[i].sector2Time));
				bos.write(float2ByteArray(data.carData[i].lapDistance));

				b = new byte[9];
				b[0] = data.carData[i].driverId;
				b[1] = data.carData[i].teamId;
				b[2] = data.carData[i].carPosition; // UPDATED: track positions of vehicle
				b[3] = data.carData[i].currentLapNum;
				b[4] = data.carData[i].tyreCompound;
				b[5] = data.carData[i].inPits; // 0 = none, 1 = pitting, 2 = in pit area
				b[6] = data.carData[i].sector; // 0 = sector1, 1 = sector2, 2 = sector3
				b[7] = data.carData[i].currentLapInvalid; // current lap invalid - 0 = valid, 1 = invalid
				b[8] = data.carData[i].penalties; // NEW: accumulated tim
				bos.write(b);
			}
			return bos.toByteArray();
		} catch(final IOException e) {
			log.error(e);
			return new byte[0];
		}
	}

	public TelemetryDataF12017Impl(final byte[] data, final CodemastersLookups codemastersLookups) {
		this.codemastersLookups = codemastersLookups;
		mapFieldsFromBytes(data);
	}
	
	private <T> void mapDataItem(final String name, final Integer byteLocation, final byte[] data, final T target) {
		final Field field = ReflectionUtils.findField(target.getClass(), name);
		final Method method = ReflectionUtils.findMethod(target.getClass(),  "set" + Character.toUpperCase(name.charAt(0)) + name.substring(1), field.getType());
		if(field.getType() == Float.TYPE || field.getType() == Float.class) {
			ReflectionUtils.invokeMethod(method, target, decodeFloat(data, byteLocation));
		} else if (field.getType() == Byte.TYPE || field.getType() == Byte.class) {
			ReflectionUtils.invokeMethod(method, target, data[byteLocation]);
		} else if (field.getType() == Integer.TYPE || field.getType() == Integer.class) {
			ReflectionUtils.invokeMethod(method, target, Math.round(decodeFloat(data, byteLocation)));
		}
	}

	private void mapFieldsFromBytes(final byte[] data) {
		codemastersLookups.getF12017DataMappings().forEach((key, value) -> mapDataItem(key, value, data, this.data));

		int carDataIndex = 337;
		for(int i = 0; i < this.data.carData.length; i++) {
			this.data.carData[i] = new CarData(Arrays.copyOfRange(data, carDataIndex, carDataIndex + CAR_DATA_SIZE_BYTES));
			carDataIndex = carDataIndex + CAR_DATA_SIZE_BYTES;
		}
	}
	
	private float decodeFloat(byte[] data, int start) {
		return ByteBuffer.wrap(Arrays.copyOfRange(data, start, start + FLOAT_SIZE_IN_BYTES)).order(ByteOrder.LITTLE_ENDIAN).getFloat();
	}
	
	public class CarData {
		public float worldPositionX = 0f; // world co-ordinates of vehicle
		public float worldPositionY = 0f;
		public float worldPositionZ = 0f;
		public float lastLapTime = 0f;
		public float currentLapTime = 0f;
		public float bestLapTime = 0f;
		public float sector1Time = 0f;
		public float sector2Time = 0f;
		public float lapDistance = 0f;
		public byte driverId = 0;
		public byte teamId = 0;
		public byte carPosition = 0; // UPDATED: track positions of vehicle
		public byte currentLapNum = 0;
		public byte tyreCompound = 0;
		public byte inPits = 0; // 0 = none, 1 = pitting, 2 = in pit area
		public byte sector = 0; // 0 = sector1, 1 = sector2, 2 = sector3
		public byte currentLapInvalid = 0; // current lap invalid - 0 = valid, 1 = invalid
		public byte penalties = 0; // NEW: accumulated time penalties in seconds to be added

        public CarData(){};

		public CarData(final byte[] data) {
			codemastersLookups.getF12017CarDataMappings().forEach((key, value) -> mapDataItem(key, value, data, this));
		}
	}
}
