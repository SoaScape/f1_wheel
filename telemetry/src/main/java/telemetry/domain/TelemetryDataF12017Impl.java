package telemetry.domain;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;

import lombok.Data;

@Data
public class TelemetryDataF12017Impl implements TelemetryData {
	private static final Integer FLOAT_SIZE_IN_BYTES = Float.SIZE / Byte.SIZE;
	private static final Integer CAR_DATA_SIZE_BYTES = 45;

	@Value("#{${fuel-mix-lookup}}")
	private static Map<Integer, String> fuelMixLookup;	
	@Value("#{${team-lookup}}")
	private static Map<Integer, String> teamLookup;	
	@Value("#{${track-lookup}}")
	private static Map<Integer, String> trackLookup;

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
	private float[] suspPos = new float[4];
	private float[] suspVel = new float[4];
	private float[] wheelSpeed = new float[4];
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
	private float[] brakeTemps = new float[4]; // Celsius
	private float[] tyrePressures = new float[4];
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
	private byte[] tyreTemps = new byte[4];
	private byte[] tyreWear = new byte[4];
	private byte tyreCompound;	
	private byte frontBrakeBias;
	private byte fuelMix;
	private byte currentLapInvalid;
	private byte[] tyreDamage = new byte[4];
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

	public TelemetryDataF12017Impl(final byte[] data) {
		mapFieldsFromBytes(data);
	}
	
	public String getTrackName() {
		return trackLookup.get(this.trackId);
	}
	
	public String getTeamName() {
		return teamLookup.get(this.teamInfo);
	}
	
	public String getFuelMixName() {
		return fuelMixLookup.get(this.fuelMix);
	}
	
	@Data
	public class CarData {
		private float[] worldPosition = new float[3]; // world co-ordinates of vehicle
		private float lastLapTime;
		private float currentLapTime;
		private float bestLapTime;
		private float sector1Time;
		private float sector2Time;
		private float lapDistance;
		private byte driverId;
		private byte teamId;
		private byte carPosition; // UPDATED: track positions of vehicle
		private byte currentLapNum;
		private byte tyreCompound;
		private byte inPits; // 0 = none, 1 = pitting, 2 = in pit area
		private byte sector; // 0 = sector1, 1 = sector2, 2 = sector3
		private byte currentLapInvalid; // current lap invalid - 0 = valid, 1 = invalid
		private byte penalties; // NEW: accumulated time penalties in seconds to be added

		public CarData(final byte[] data) {
			this.worldPosition[0] = decodeFloat(data, 0);
			this.worldPosition[1] = decodeFloat(data, 4);
			this.worldPosition[2] = decodeFloat(data, 8);
			this.lastLapTime = decodeFloat(data, 12);
			this.currentLapTime = decodeFloat(data, 16);
			this.bestLapTime = decodeFloat(data, 20);
			this.sector1Time = decodeFloat(data, 24);
			this.sector2Time = decodeFloat(data, 28);
			this.lapDistance = decodeFloat(data, 32);
			this.driverId = data[36];
			this.teamId = data[37];
			this.carPosition = data[38];
			this.currentLapNum = data[39];
			this.tyreCompound = data[40];
			this.inPits = data[41];
			this.sector = data[42];
			this.currentLapInvalid = data[43];
			this.penalties = data[44];
		}
		
		public String getTeamName() {
			return teamLookup.get(this.teamId);
		}
	}
	
	private void mapFieldsFromBytes(final byte[] data) {
		this.time = decodeFloat(data, 0);
		this.lapTime = decodeFloat(data, 4);
		this.lapDistance = decodeFloat(data, 8);		
		this.totalDistance = decodeFloat(data, 12);
		this.x = decodeFloat(data, 16);
		this.y = decodeFloat(data, 20);
		this.z = decodeFloat(data, 24);
		this.speed = decodeFloat(data, 28);		
		this.xv = decodeFloat(data, 32);
		this.yv = decodeFloat(data, 36);
		this.zv = decodeFloat(data, 40);
		this.xr = decodeFloat(data, 44);
		this.yr = decodeFloat(data, 48);
		this.zr = decodeFloat(data, 52);
		this.xd = decodeFloat(data, 56);
		this.yd = decodeFloat(data, 60);
		this.zd = decodeFloat(data, 64);
		suspPos[0] = decodeFloat(data, 68);
		suspPos[1] = decodeFloat(data, 72);
		suspPos[2] = decodeFloat(data, 76);
		suspPos[3] = decodeFloat(data, 80);
		suspVel[0] = decodeFloat(data, 84);
		suspVel[1] = decodeFloat(data, 88);
		suspVel[2] = decodeFloat(data, 92);
		suspVel[3] = decodeFloat(data, 96);
		wheelSpeed[0] = decodeFloat(data, 100);
		wheelSpeed[1] = decodeFloat(data, 104);
		wheelSpeed[2] = decodeFloat(data, 108);
		wheelSpeed[3] = decodeFloat(data, 112);
		this.throttle = decodeFloat(data, 116);
		this.steering = decodeFloat(data, 120);
		this.brake = decodeFloat(data, 124);
		this.clutch = decodeFloat(data, 128);
		this.gear = decodeFloat(data, 132);
		this.gforceLat = decodeFloat(data, 136);
		this.gforceLon = decodeFloat(data, 140);		
		this.lap = decodeFloat(data, 144);
		this.engineRate = decodeFloat(data, 148);
		this.sliProNativeSupport = decodeFloat(data, 152);
		this.carPosition = decodeFloat(data, 156);
		this.kersLevel = decodeFloat(data, 160);
		this.maxKersLevel = decodeFloat(data, 164);
		this.drs = decodeFloat(data, 168);
		this.tractionControl = decodeFloat(data, 172);
		this.abs = decodeFloat(data, 176);
		this.fuelInTank = decodeFloat(data, 180);
		this.fuelCapacity = decodeFloat(data, 184);
		this.inPits = decodeFloat(data, 188);
		this.sector = decodeFloat(data, 192);
		this.sector1Time = decodeFloat(data, 196);
		this.sector2Time = decodeFloat(data, 200);
		this.brakeTemps[0] = decodeFloat(data, 204);
		this.brakeTemps[1] = decodeFloat(data, 208);
		this.brakeTemps[2] = decodeFloat(data, 212);
		this.brakeTemps[3] = decodeFloat(data, 216);
		this.tyrePressures[0] = decodeFloat(data, 220);
		this.tyrePressures[1] = decodeFloat(data, 224);
		this.tyrePressures[2] = decodeFloat(data, 228);
		this.tyrePressures[3] = decodeFloat(data, 232);
		this.teamInfo = Math.round(decodeFloat(data, 236));
		this.totalLaps = decodeFloat(data, 240);
		this.trackSize = decodeFloat(data, 244);
		this.lastLapTime = decodeFloat(data, 248);
		this.maxRpm = decodeFloat(data, 252);
		this.idleRpm = decodeFloat(data, 256);
		this.maxGears = decodeFloat(data, 260);
		this.sessionType = decodeFloat(data, 264);
		this.drsAvailable = decodeFloat(data, 268);
		this.trackId = decodeFloat(data, 272);
		this.fiaFlags = decodeFloat(data, 276);
		this.era = decodeFloat(data, 280);
		this.engineTemp = decodeFloat(data, 284);
		this.gforceVert = decodeFloat(data, 288);
		this.angVelX = decodeFloat(data, 292);
		this.angVelY = decodeFloat(data, 296);
		this.angVelZ = decodeFloat(data, 300);
		this.tyreTemps[0] = data[304];
		this.tyreTemps[1] = data[305];
		this.tyreTemps[2] = data[306];
		this.tyreTemps[3] = data[307];
		this.tyreWear[0] = data[308];
		this.tyreWear[1] = data[309];
		this.tyreWear[2] = data[310];
		this.tyreWear[3] = data[311];
		this.tyreCompound = data[312];		
		this.frontBrakeBias = data[313];
		this.fuelMix = data[314];
		this.currentLapInvalid = data[315];
		this.tyreDamage[0] = data[316];
		this.tyreDamage[1] = data[317];
		this.tyreDamage[2] = data[318];
		this.tyreDamage[3] = data[319];
		this.frontLeftWingDamage = data[320];
		this.frontRightWingDamage = data[321];
		this.rearWingDamage = data[322];
		this.engineDamage = data[323];
		this.gearBoxDamage = data[324];
		this.exhaustDamage = data[325];
		this.pitLimiterStatus = data[326];
		this.pitSpeedLimit = data[327];
		this.sessionTimeLeft = decodeFloat(data, 328);
		this.revLightsPercent = data[332];
		this.isSpectating = data[333];
		this.spectatorCarIndex = data[334];
		this.numCars = data[335];		
		this.playerCarIndex = data[336];
		
		int carDataIndex = 337;
		for(int i = 0; i < this.carData.length; i++) {
			this.carData[i] = new CarData(Arrays.copyOfRange(data, carDataIndex, carDataIndex + CAR_DATA_SIZE_BYTES));
			carDataIndex = carDataIndex + CAR_DATA_SIZE_BYTES;
		}
	}
	
	private float decodeFloat(byte[] data, int start) {
		return ByteBuffer.wrap(Arrays.copyOfRange(data, start, start + FLOAT_SIZE_IN_BYTES)).order(ByteOrder.LITTLE_ENDIAN).getFloat();
	}
}
