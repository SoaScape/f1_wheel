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
	private byte playerCarIndex;	
	private float maxGears;	

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
		
		this.maxGears = decodeFloat(data, 260);
		this.playerCarIndex = data[336];
	}
	
	private float decodeFloat(byte[] data, int start) {
		return ByteBuffer.wrap(Arrays.copyOfRange(data, start, start + FLOAT_SIZE_IN_BYTES)).order(ByteOrder.LITTLE_ENDIAN).getFloat();
	}
}
