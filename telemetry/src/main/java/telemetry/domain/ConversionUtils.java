package telemetry.domain;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;

public class ConversionUtils {
    private static final Integer FLOAT_SIZE_IN_BYTES = 4;

    public static byte [] long2ByteArray (long value) {
        return ByteBuffer.allocate(8).putLong(value).array();
    }

    public static byte [] float2ByteArray (float value) {
        return ByteBuffer.allocate(4).putFloat(value).array();
    }

    public static float[] populateFloatArr(byte[] data, int arraySize, int startByte) {
        float[] floats = new float[arraySize];
        for(int i = 0; i < floats.length; i++) {
            floats[i] = decodeFloat(data, startByte + (i * FLOAT_SIZE_IN_BYTES));
        }
        return floats;
    }

    public static ByteBuffer decodeBytes(byte[] data, int start, int end) {
        return ByteBuffer.wrap(Arrays.copyOfRange(data, start, end)).order(ByteOrder.LITTLE_ENDIAN);
    }

    public static float decodeFloat(byte[] data, int start) {
        return decodeBytes(data, start, start + FLOAT_SIZE_IN_BYTES).getFloat();
    }

    public static int decodeInt(byte[] data, int start, int sizeInBytes) {
        return ((data[start+sizeInBytes-1] & 0xff) << 8) + (data[start] & 0xff);
    }

    public static Long decodeLong(byte[] data, int start, int sizeInBytes) {
        return decodeBytes(data, start, start + sizeInBytes).getLong();
    }
}
