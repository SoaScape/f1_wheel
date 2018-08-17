package telemetry.domain;

import lombok.Data;

import static telemetry.domain.ConversionUtils.*;

public class TelemetryDataF12018Impl {
    private static final Integer HEADER_SIZE_BYTES = 21;

    @Data
    public static class F12018Header {
        private int format;             // 2018
        private Byte version;           // Version of this packet type, all start from 1
        private Byte packetId;          // Identifier for the packet type, see below
        private Long sessionId;         // Unique identifier for the session
        private float sessionTime;      // Session timestamp
        private int frameIdentifier;    // Identifier for the frame the data was retrieved on
        private Byte playerCarIndex;    // Index of player's car in the array

        public F12018Header(byte[] data) {
            format = decodeInt(data, 0, 2);
            version = data[2];
            packetId = data[3];
            sessionId = decodeLong(data, 4, 8);
            sessionTime = decodeFloat(data, 12);
            frameIdentifier = decodeInt(data, 16, 4);
            playerCarIndex = data[20];
        }
    }

    private static final Integer CAR_MOTION_DATA_SIZE_BYTES = 60;
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

        public CarMotionData(byte[] data, int carIndex) {
            int offset = HEADER_SIZE_BYTES + (carIndex * CAR_MOTION_DATA_SIZE_BYTES);
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

    public static final Integer MOTION_PACKET_SIZE = 1341; // bytes
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
            for(int i = 0; i < carMotionData.length; i++) {
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

	public static final Integer INDIVIDUAL_CAR_DATA_PACKET_SIZE = 53; // bytes
    @Data
    public static class IndividialCarData {
        private int m_speed; //int16
        private int m_throttle; //int8
        private int m_steer; // int8                            // Steering (-100 (full lock left) to 100 (full lock right))
        private int m_brake; //         uint8                           // Amount of brake applied (0 to 100)
        private int m_clutch; //         uint8                          // Amount of clutch applied (0 to 100)
        private int m_gear; //         int8                             // Gear selected (1-8, N=0, R=-1)
        private int m_engineRPM; //         uint16                      // Engine RPM
        private int m_drs; //         uint8                             // 0 = off, 1 = on
        private int m_revLightsPercent; //         uint8                // Rev lights indicator (percentage)
        private int[] m_brakesTemperature = new int[4]; //         uint16           // Brakes temperature (celsius)
        private int[] m_tyresSurfaceTemperature = new int[4]; //         uint16     // Tyres surface temperature (celsius)
        private int[] m_tyresInnerTemperature = new int[4]; //         uint16       // Tyres inner temperature (celsius)
        private int m_engineTemperature; //         uint16              // Engine temperature (celsius)
        private float[] m_tyresPressure = new float[4];           // Tyres pressure (PSI)

        public IndividialCarData(byte[] data, int carIndex) {
            int offset = HEADER_SIZE_BYTES + (carIndex * INDIVIDUAL_CAR_DATA_PACKET_SIZE);

            m_speed = decodeInt(data, offset, 2);
            m_throttle = decodeInt(data, offset+2, 1);
            m_steer = decodeInt(data, offset+3, 1);
            m_brake = decodeInt(data, offset+4, 1);
            m_clutch = decodeInt(data, offset+5, 1);
            m_gear = decodeInt(data, offset+6,1 );
            m_engineRPM = decodeInt(data, offset+7, 2);
            m_drs = decodeInt(data, offset+9, 1);
            m_revLightsPercent = decodeInt(data, offset+10, 1);

            m_brakesTemperature = populateIntArr(data, 4, 2, offset+11);
            m_tyresSurfaceTemperature = populateIntArr(data, 4, 2, offset+19);
            m_tyresInnerTemperature = populateIntArr(data, 4, 2, offset+27);

            m_engineTemperature = decodeInt(data, offset+35, 2);
            m_tyresPressure = populateFloatArr(data, 4, offset+37);
        }
    }

	public static final Integer CAR_DATA_PACKET_SIZE = 1085; // bytes
    @Data
    public static class PacketCarData {
        private F12018Header header;
        private IndividialCarData[] carsData = new IndividialCarData[20];
        private int buttonStatus;

        public PacketCarData(byte[] data) {
            this.header = new F12018Header(data);
            for(int i = 0; i < carsData.length; i++) {
                this.carsData[i] = new IndividialCarData(data, i);
            }
            this.buttonStatus = decodeInt(data, 1081, 4);
        }
    }
}
