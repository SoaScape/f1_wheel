package telemetry.domain;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;

import lombok.Data;

@Data
public class TelemetryDataF12017Impl implements TelemetryData {
	private static final Integer FLOAT_SIZE_IN_BYTES = Float.SIZE / Byte.SIZE;
	private float time;
	private float lapTime;
	private float lapDistance;
	private float totalDistance;
	private float speed;
	private float throttle;
	private float steering;
	private float brake;
	private float clutch;
	private float gear;
	private float lap;
	private float engineRate;
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
	private float[] brakeTemps;
	private float[] tyrePressures;
	private float teamInfo;
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

	private byte playerCarIndex;

	public TelemetryDataF12017Impl(final byte[] data) {
		mapFieldsFromBytes(data);
	}
	
	private void mapFieldsFromBytes(final byte[] data) {
		this.time = decodeFloat(data, 0);
		this.lapTime = decodeFloat(data, 4);
		this.lapDistance = decodeFloat(data, 8);		
		this.totalDistance = decodeFloat(data, 12);
		this.speed = decodeFloat(data, 28);
		this.throttle = decodeFloat(data, 116);
		this.steering = decodeFloat(data, 120);
		this.brake = decodeFloat(data, 124);
		this.clutch = decodeFloat(data, 128);
		this.gear = decodeFloat(data, 132);
		this.lap = decodeFloat(data, 144);
		this.engineRate = decodeFloat(data, 148);
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
		this.brakeTemps = new float[4];
		this.brakeTemps[0] = decodeFloat(data, 204);
		this.brakeTemps[1] = decodeFloat(data, 208);
		this.brakeTemps[2] = decodeFloat(data, 212);
		this.brakeTemps[3] = decodeFloat(data, 216);
		this.tyrePressures = new float[4];
		this.tyrePressures[0] = decodeFloat(data, 220);
		this.tyrePressures[1] = decodeFloat(data, 224);
		this.tyrePressures[2] = decodeFloat(data, 228);
		this.tyrePressures[3] = decodeFloat(data, 232);
		this.teamInfo = decodeFloat(data, 236);
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
		
		this.playerCarIndex = data[336];
	}
	
	private float decodeFloat(byte[] data, int start) {
		return ByteBuffer.wrap(Arrays.copyOfRange(data, start, start + FLOAT_SIZE_IN_BYTES)).order(ByteOrder.LITTLE_ENDIAN).getFloat();
	}
}
