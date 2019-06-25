package telemetry.domain;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;

public class ConversionUtils {
    private static final Integer FLOAT_SIZE_IN_BYTES = 4;
    private static final Integer INT_SIZE_IN_BYTES = 4;

    public static byte [] long2ByteArray (long value) {
        return ByteBuffer.allocate(8).order(ByteOrder.LITTLE_ENDIAN).putLong(value).array();
    }

    public static byte [] float2ByteArray (float value) {
        return ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN).putFloat(value).array();
    }

    public static float[] populateFloatArr(byte[] data, int arraySize, int startByte) {
        float[] floats = new float[arraySize];
        for(int i = 0; i < floats.length; i++) {
            floats[i] = decodeFloat(data, startByte + (i * FLOAT_SIZE_IN_BYTES));
        }
        return floats;
    }

    public static short[] populateShortArr(byte[] data, int arraySize, int startByte) {
        short[] shorts = new short[arraySize];
        for(int i = 0; i < shorts.length; i++) {
            shorts[i] = decodeShort(data, startByte + (i * INT_SIZE_IN_BYTES));
        }
        return shorts;
    }

    public static int[] populateIntArr(byte[] data, int arraySize, int numBytesPerInt, int startByte) {
        int[] ints = new int[arraySize];
        for(int i = 0; i < ints.length; i++) {
            ints[i] = decodeInt(data, startByte + (i * numBytesPerInt));
        }
        return ints;
    }

    public static byte[] populateByteArr(byte[] data, int arraySize, int startByte) {
        byte[] bytes = new byte[arraySize];
        for(int i = 0; i < bytes.length; i++) {
            bytes[i] = data[startByte + i];
        }
        return bytes;
    }

    public static ByteBuffer decodeBytes(byte[] data, int start, int end) {
        return ByteBuffer.wrap(Arrays.copyOfRange(data, start, end)).order(ByteOrder.LITTLE_ENDIAN);
    }

    public static float decodeFloat(byte[] data, int start) {
        return decodeBytes(data, start, start + FLOAT_SIZE_IN_BYTES).getFloat();
    }

    public static short decodeShort(byte[] data, int start) {
        return (short)(((data[start+1] & 0xff) << 8) + (data[start] & 0xff));
    }

    public static int decodeInt(byte[] data, int start) {
        return decodeBytes(data, start, start + INT_SIZE_IN_BYTES).getInt();
    }

    public static byte decodeByte(byte[] data, int start) {
        return decodeBytes(data, start, start + 1).get();
    }

    public static Long decodeLong(byte[] data, int start, int sizeInBytes) {
        return decodeBytes(data, start, start + sizeInBytes).getLong();
    }

    public static float convertNormalised16BitVectorToFloat(short vector) {
        /*
        N.B. For the normalised vectors below, to convert to float values divide by 32767.0f.
        16-bit signed values are used to pack the data and on the assumption that direction
        values are always between -1.0f and 1.0f.
         */
        return vector / 32767.0f;
    }

    public static void printBytes(final byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X ", b));
        }
        System.out.println(sb.toString());
    }
}
