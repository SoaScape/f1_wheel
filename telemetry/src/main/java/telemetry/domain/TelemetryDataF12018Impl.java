package telemetry.domain;

import lombok.Data;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;

public class TelemetryDataF12018Impl {
    private static final Integer FLOAT_SIZE_IN_BYTES = 4;

    public static final Integer Header_Size_Bytes = 18;
    @Data
    public static class F12018Header {
        private int format;             // 2018
        private Byte version;           // Version of this packet type, all start from 1
        private Byte packetId;          // Identifier for the packet type, see below
        private Long sessionId;         // Unique identifier for the session
        private float sessionTime;      // Session timestamp
        private Byte frameIdentifier;   // Identifier for the frame the data was retrieved on
        private Byte playerCarIndex;    // Index of player's car in the array

        public F12018Header(byte[] data) {
            format = decodeInt(data, 0, 2);
            version = data[2];
            packetId = data[3];
            sessionId = decodeLong(data, 4, 8);
            sessionTime = decodeFloat(data, 12);
            frameIdentifier = data[16];
            playerCarIndex = data[17];
        }
    }

    private static final Integer CarMotionDataSizeBytes = 60;
    @Data
    public static class CarMotionData
    {
        private float worldPositionX; // World space X position
        private float worldPositionY; // World space Y position
        private float worldPositionZ; // World space Z position
        private float worldVelocityX; // Velocity in world space X
        private float worldVelocityY; // Velocity in world space Y
        private float worldVelocityZ; // Velocity in world space Z
        private int worldForwardDirX; // World space forward X direction (normalised) 16-bit
        private int worldForwardDirY; // World space forward Y direction (normalised) 16-bit
        private int worldForwardDirZ; // World space forward Z direction (normalised) 16-bit
        private int worldRightDirX; // World space right X direction (normalised) 16-bit
        private int worldRightDirY; // World space right Y direction (normalised) 16-bit
        private int worldRightDirZ; // World space right Z direction (normalised) 16-bit
        private float gForceLateral; // Lateral G-Force component
        private float gForceLongitudinal; // Longitudinal G-Force component
        private float gForceVertical; // Vertical G-Force component
        private float yaw; // Yaw angle in radians
        private float pitch; // Pitch angle in radians
        private float roll; // Roll angle in radians

        public CarMotionData(byte[] data, int carNum) {
            int offset = carNum + CarMotionDataSizeBytes;
            worldPositionX = decodeFloat(data, 0 + offset);
            worldPositionY = decodeFloat(data, 4 + offset);
            worldPositionZ = decodeFloat(data, 8 + offset);
            worldVelocityX = decodeFloat(data, 12 + offset);
            worldVelocityY = decodeFloat(data, 16 + offset);
            worldVelocityZ = decodeFloat(data, 20 + offset);
            worldForwardDirX = decodeInt(data, 24 + offset, 2);
            worldForwardDirY = decodeInt(data, 26 + offset, 2);
            worldForwardDirZ = decodeInt(data, 28 + offset, 2);
            worldRightDirX = decodeInt(data, 30 + offset, 2);
            worldRightDirY = decodeInt(data, 32 + offset, 2);
            worldRightDirZ = decodeInt(data, 34 + offset, 2);
            gForceLateral = decodeFloat(data, 36 + offset);
            gForceLongitudinal = decodeFloat(data, 40 + offset);
            gForceVertical = decodeFloat(data, 44 + offset);
            yaw = decodeFloat(data, 48 + offset);
            pitch = decodeFloat(data, 52 + offset);
            roll = decodeFloat(data, 56 + offset);
        }
    }

    public static final Integer MotionPacketSize = 1341; // bytes
    @Data
    public static class PacketMotionData {
        private F12018Header header;                                    // Header
        private CarMotionData[] carMotionData = new CarMotionData[20];  // Data for all cars on track [20]

        // Extra player car ONLY data
        private float[] suspensionPosition = new float[4];      // Note: All wheel arrays have the following order:
        private float[] suspensionVelocity = new float[4];      // RL, RR, FL, FR
        private float[] suspensionAcceleration = new float[4];  // RL, RR, FL, FR
        private float[] wheelSpeed = new float[4];              // Speed of each wheel
        private float[] wheelSlip = new float[4];               // Slip ratio for each wheel (added v1.2.1)
        private float localVelocityX;                           // Velocity in local space
        private float localVelocityY;                           // Velocity in local space
        private float localVelocityZ;                           // Velocity in local space
        private float angularVelocityX;                         // Angular velocity x-component
        private float angularVelocityY;                         // Angular velocity y-component
        private float angularVelocityZ;                         // Angular velocity z-component
        private float angularAccelerationX;                     // Angular velocity x-component
        private float angularAccelerationY;                     // Angular velocity y-component
        private float angularAccelerationZ;                     // Angular velocity z-component
        private float frontWheelsAngle;                         // Current front wheels angle in radians (added v1.2.1)

        public PacketMotionData(byte[] data) {
            header = new F12018Header(data);
            for(int i = Header_Size_Bytes; i < Header_Size_Bytes + carMotionData.length; i++) {
                carMotionData[i] = new CarMotionData(data, i);
            }
            suspensionPosition = populateFloatArr(data, 4, 1218);
            suspensionVelocity = populateFloatArr(data, 4, 1234);
            suspensionAcceleration = populateFloatArr(data, 4, 1250);
            wheelSpeed = populateFloatArr(data, 4, 1266);
            wheelSlip = populateFloatArr(data, 4, 1282);

            localVelocityX = decodeFloat(data, 1298);
            localVelocityY = decodeFloat(data, 1302);
            localVelocityZ = decodeFloat(data, 1306);
            angularVelocityX = decodeFloat(data, 1310);
            angularVelocityY = decodeFloat(data, 1314);
            angularVelocityZ = decodeFloat(data, 1318);
            angularAccelerationX = decodeFloat(data, 1322);
            angularAccelerationY = decodeFloat(data, 1326);
            angularAccelerationZ = decodeFloat(data, 1330);
            frontWheelsAngle = decodeFloat(data, 1334);
        }
    }

    private static float[] populateFloatArr(byte[] data, int arraySize, int startByte) {
        float[] floats = new float[arraySize];
        for(int i = 0; i < floats.length; i++) {
            floats[i] = decodeFloat(data, startByte + (i * FLOAT_SIZE_IN_BYTES));
        }
        return floats;
    }

    private static ByteBuffer decodeBytes(byte[] data, int start, int end) {
        return ByteBuffer.wrap(Arrays.copyOfRange(data, start, end)).order(ByteOrder.LITTLE_ENDIAN);
    }

    private static float decodeFloat(byte[] data, int start) {
        return decodeBytes(data, start, start + FLOAT_SIZE_IN_BYTES).getFloat();
    }

    private static int decodeInt(byte[] data, int start, int sizeInBytes) {
        return decodeBytes(data, start, start + sizeInBytes).getInt();
    }

    private static Long decodeLong(byte[] data, int start, int sizeInBytes) {
        return decodeBytes(data, start, start + sizeInBytes).getLong();
    }

}
