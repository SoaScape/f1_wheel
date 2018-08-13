package telemetry.domain;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;
import org.springframework.util.ReflectionUtils;
import lombok.Data;
import lombok.ToString;

@Data
@ToString(exclude="codemastersLookups")
public class TelemetryDataF12017Impl implements TelemetryData {
	private static final Integer FLOAT_SIZE_IN_BYTES = Float.SIZE / Byte.SIZE;
	private static final Integer CAR_DATA_SIZE_BYTES = 45;

	private CodemastersLookups codemastersLookups;

	public F12017Data data;

	public class F12017Data {
		// Wheel order for all arrays: 0=rear left, 1=rear right, 2=front left, 3=front right
		public float time;
		public float lapTime;
		public float lapDistance;
		public float totalDistance;
		public float x;
		public float y;
		public float z;
		public float speed;
		public float xv;
		public float yv;
		public float zv;
		public float xr;
		public float yr;
		public float zr;
		public float xd;
		public float yd;
		public float zd;
		public float suspPosRL;
		public float suspPosRR;
		public float suspPosFL;
		public float suspPosFR;
		public float suspVelRL;
		public float suspVelRR;
		public float suspVelFL;
		public float suspVelFR;
		public float wheelSpeedRL;
		public float wheelSpeedRR;
		public float wheelSpeedFL;
		public float wheelSpeedFR;
		public float throttle;
		public float steering;
		public float brake;
		public float clutch;
		public float gear;
		public float gforceLat;
		public float gforceLon;
		public float lap;
		public float engineRate;
		public float sliProNativeSupport;
		public float carPosition;
		public float kersLevel;
		public float maxKersLevel;
		public float drs;
		public float tractionControl;
		public float abs;
		public float fuelInTank;
		public float fuelCapacity;
		public float inPits;
		public float sector;
		public float sector1Time;
		public float sector2Time;
		public float brakeTempsRL; // Celsius
		public float brakeTempsRR;
		public float brakeTempsFL;
		public float brakeTempsFR;
		public float tyrePressuresRL;
		public float tyrePressuresRR;
		public float tyrePressuresFL;
		public float tyrePressuresFR;
		public float teamInfo;
		public float totalLaps;
		public float trackSize;
		public float lastLapTime;
		public float maxRpm;
		public float idleRpm;
		public float maxGears;
		public float sessionType;
		public float drsAvailable;
		public float trackId;
		public float fiaFlags;
		public float era;
		public float engineTemp;
		public float gforceVert;
		public float angVelX;
		public float angVelY;
		public float angVelZ;
		public byte tyreTempsRL;
		public byte tyreTempsRR;
		public byte tyreTempsFL;
		public byte tyreTempsFR;
		public byte tyreWearRL;
		public byte tyreWearRR;
		public byte tyreWearFL;
		public byte tyreWearFR;
		public Byte tyreCompound;
		public byte frontBrakeBias;
		public Byte fuelMix;
		public byte currentLapInvalid;
		public byte tyreDamageRL;
		public byte tyreDamageRR;
		public byte tyreDamageFL;
		public byte tyreDamageFR;
		public byte frontLeftWingDamage;
		public byte frontRightWingDamage;
		public byte rearWingDamage;
		public byte engineDamage;
		public byte gearBoxDamage;
		public byte exhaustDamage;
		public byte pitLimiterStatus;
		public byte pitSpeedLimit;
		public float sessionTimeLeft;
		public byte revLightsPercent;
		public byte isSpectating;
		public byte spectatorCarIndex;
		public byte numCars;
		public byte playerCarIndex;
		public CarData[] carData = new CarData[20];

		public byte[] toByteArray() {
			return this.toByteArray();
		}
	}

	public TelemetryDataF12017Impl(){
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
		public float worldPositionX; // world co-ordinates of vehicle
		public float worldPositionY;
		public float worldPositionZ;
		public float lastLapTime;
		public float currentLapTime;
		public float bestLapTime;
		public float sector1Time;
		public float sector2Time;
		public float lapDistance;
		public byte driverId;
		public Byte teamId;		
		public byte carPosition; // UPDATED: track positions of vehicle
		public byte currentLapNum;
		public Byte tyreCompound;
		public byte inPits; // 0 = none, 1 = pitting, 2 = in pit area
		public byte sector; // 0 = sector1, 1 = sector2, 2 = sector3
		public byte currentLapInvalid; // current lap invalid - 0 = valid, 1 = invalid
		public byte penalties; // NEW: accumulated time penalties in seconds to be added

		public CarData(final byte[] data) {
			codemastersLookups.getF12017CarDataMappings().forEach((key, value) -> mapDataItem(key, value, data, this));
		}
	}
}
