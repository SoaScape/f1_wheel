package telemetry.domain;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;
import java.util.Map;

import org.springframework.util.ReflectionUtils;

import java.beans.IntrospectionException;

import lombok.Data;
import lombok.ToString;

@Data
@ToString(exclude="codemastersLookups")
public class TelemetryDataF12017Impl implements TelemetryData {
	private static final Integer FLOAT_SIZE_IN_BYTES = Float.SIZE / Byte.SIZE;
	private static final Integer CAR_DATA_SIZE_BYTES = 45;

	private CodemastersLookups codemastersLookups;

	private String fuelMixName;
	private String trackName;
	private String teamName;
	private String tyreCompoundName;

	// Wheel order for all arrays: 0=rear left, 1=rear right, 2=front left, 3=front right
	private float time;
	private float lapTime;
	private float lapDistance;
	private float totalDistance;
	private float x;
	private float y;
	private float z;
	private float speed;
	private float xv;
	private float yv;
	private float zv;
	private float xr;
	private float yr;
	private float zr;
	private float xd;
	private float yd;
	private float zd;
	private float suspPosRL;
	private float suspPosRR;
	private float suspPosFL;
	private float suspPosFR;
	private float suspVelRL;
	private float suspVelRR;
	private float suspVelFL;
	private float suspVelFR;
	private float wheelSpeedRL;
	private float wheelSpeedRR;
	private float wheelSpeedFL;
	private float wheelSpeedFR;
	private float throttle;
	private float steering;
	private float brake;
	private float clutch;
	private float gear;
	private float gforceLat;
	private float gforceLon;
	private float lap;
	private float engineRate;
	private float sliProNativeSupport;
	private float carPosition;
	private float kersLevel;
	private float maxKersLevel;
	private float drs;
	private float tractionControl;
	private float abs;
	private float fuelInTank;
	private float fuelCapacity;
	private float inPits;
	private float sector;
	private float sector1Time;
	private float sector2Time;
	private float brakeTempsRL; // Celsius
	private float brakeTempsRR;
	private float brakeTempsFL;
	private float brakeTempsFR;
	private float tyrePressuresRL;
	private float tyrePressuresRR;
	private float tyrePressuresFL;
	private float tyrePressuresFR;
	private Integer teamInfo;
	private float totalLaps;
	private float trackSize;
	private float lastLapTime;
	private float maxRpm;
	private float idleRpm;
	private float maxGears;	
	private float sessionType;
	private float drsAvailable;
	private float trackId;
	private float fiaFlags;
	private float era;
	private float engineTemp;
	private float gforceVert;
	private float angVelX;
	private float angVelY;
	private float angVelZ;
	private byte tyreTempsRL;
	private byte tyreTempsRR;
	private byte tyreTempsFL;
	private byte tyreTempsFR;
	private byte tyreWearRL;
	private byte tyreWearRR;
	private byte tyreWearFL;
	private byte tyreWearFR;
	private Byte tyreCompound;	
	private byte frontBrakeBias;
	private Byte fuelMix;
	private byte currentLapInvalid;
	private byte tyreDamageRL;
	private byte tyreDamageRR;
	private byte tyreDamageFL;
	private byte tyreDamageFR;
	private byte frontLeftWingDamage;
	private byte frontRightWingDamage;
	private byte rearWingDamage;
	private byte engineDamage;
	private byte gearBoxDamage;
	private byte exhaustDamage;
	private byte pitLimiterStatus;
	private byte pitSpeedLimit;	
	private float sessionTimeLeft;
	private byte revLightsPercent;
	private byte isSpectating;
	private byte spectatorCarIndex;
	private byte numCars;
	private byte playerCarIndex;
	private CarData[] carData = new CarData[20];

	public TelemetryDataF12017Impl(final byte[] data, final CodemastersLookups codemastersLookups) {
		this.codemastersLookups = codemastersLookups;
		mapFieldsFromBytes(data);
	}
	
	private <T> void mapDataItem(final String name, final Integer byteLocation, final byte[] data, final T target) {
		final Field field = ReflectionUtils.findField(target.getClass(), name);		
		if(field.getType() == Float.TYPE || field.getType() == Float.class) {
			ReflectionUtils.setField(field,  target,  decodeFloat(data, byteLocation));
		} else if (field.getType() == Byte.TYPE || field.getType() == Byte.class) {
			ReflectionUtils.setField(field,  target,  data[byteLocation]);
		} else if (field.getType() == Integer.TYPE || field.getType() == Integer.class) {
			ReflectionUtils.setField(field,  target,  Math.round(decodeFloat(data, byteLocation)));
		}
	}
	
	private void setTrackName() {
		this.trackName = codemastersLookups.getTrackLookup().get(Math.round(this.trackId));
	}
	
	private void setTeamName() {
		this.teamName = codemastersLookups.getTeamLookup().get(this.teamInfo);
	}
	
	private void setFuelMixName() {
		this.fuelMixName = codemastersLookups.getFuelMixLookup().get(this.fuelMix.intValue());
	}
	
	private void setTyreCompoundName() {
		this.tyreCompoundName = codemastersLookups.getTyreCompoundLookup().get(this.tyreCompound.intValue());
	}

	private void mapFieldsFromBytes(final byte[] data) {
		codemastersLookups.getF12017DataMappings().forEach((key, value) -> mapDataItem(key, value, data, this));
		
		setFuelMixName();
		setTrackName();
		setTeamName();
		setTyreCompoundName();

		int carDataIndex = 337;
		for(int i = 0; i < this.carData.length; i++) {
			this.carData[i] = new CarData(Arrays.copyOfRange(data, carDataIndex, carDataIndex + CAR_DATA_SIZE_BYTES));
			carDataIndex = carDataIndex + CAR_DATA_SIZE_BYTES;
		}
	}
	
	private float decodeFloat(byte[] data, int start) {
		return ByteBuffer.wrap(Arrays.copyOfRange(data, start, start + FLOAT_SIZE_IN_BYTES)).order(ByteOrder.LITTLE_ENDIAN).getFloat();
	}
	
	@Data
	public class CarData {
		private String teamName;
		private String tyreCompoundName;

		private float worldPositionX; // world co-ordinates of vehicle
		private float worldPositionY;
		private float worldPositionZ;
		private float lastLapTime;
		private float currentLapTime;
		private float bestLapTime;
		private float sector1Time;
		private float sector2Time;
		private float lapDistance;
		private byte driverId;
		private Byte teamId;		
		private byte carPosition; // UPDATED: track positions of vehicle
		private byte currentLapNum;
		private Byte tyreCompound;
		private byte inPits; // 0 = none, 1 = pitting, 2 = in pit area
		private byte sector; // 0 = sector1, 1 = sector2, 2 = sector3
		private byte currentLapInvalid; // current lap invalid - 0 = valid, 1 = invalid
		private byte penalties; // NEW: accumulated time penalties in seconds to be added

		public CarData(final byte[] data) {
			
			setTeamName();
			setTyreCompoundName();
		}
		private void setTeamName() {
			this.teamName = codemastersLookups.getTeamLookup().get(this.teamId.intValue());
		}
		private void setTyreCompoundName() {
			this.tyreCompoundName = codemastersLookups.getTyreCompoundLookup().get(this.tyreCompound.intValue());
		}
	}
}
