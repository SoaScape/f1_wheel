package telemetry.domain;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;

import lombok.Data;

@Data
public class TelemetryDataF12017Impl implements TelemetryData {
	private byte driverIndex;
	private float speed; // float 4 bytes
	private float maxGears;

	public TelemetryDataF12017Impl(final byte[] data) {
		this.driverIndex = data[336];
		
		byte[] gears = Arrays.copyOfRange(data, 260, 264);
		this.maxGears = ByteBuffer.wrap(Arrays.copyOfRange(data, 260, 264)).order(ByteOrder.LITTLE_ENDIAN).getFloat();
		
		byte[] spd = Arrays.copyOfRange(data, 28, 32);
		this.speed = ByteBuffer.wrap(Arrays.copyOfRange(data, 28, 31)).order(ByteOrder.LITTLE_ENDIAN).getFloat();		
	}
}
