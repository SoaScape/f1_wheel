package telemetry.domain;

import lombok.Data;

import static telemetry.domain.ConversionUtils.*;

public class TelemetryDataF12018Impl {
    private static final Integer HEADER_SIZE_BYTES = 21;

    @Data
    public static class F12018Header {
        private short format;             // 2018
        private Byte version;           // Version of this packet type, all start from 1
        private Byte packetId;          // Identifier for the packet type, see below
        private Long sessionId;         // Unique identifier for the session
        private float sessionTime;      // Session timestamp
        private int frameIdentifier;    // Identifier for the frame the data was retrieved on
        private Byte playerCarIndex;    // Index of player's car in the array

        public F12018Header(byte[] data) {
            format = decodeShort(data, 0);
            version = data[2];
            packetId = data[3];
            sessionId = decodeLong(data, 4, 8);
            sessionTime = decodeFloat(data, 12);
            frameIdentifier = decodeInt(data, 16);
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
        private short worldForwardDirX; // World space forward X direction (normalised) 16-bit
        private short worldForwardDirY; // World space forward Y direction (normalised) 16-bit
        private short worldForwardDirZ; // World space forward Z direction (normalised) 16-bit
        private short worldRightDirX; // World space right X direction (normalised) 16-bit
        private short worldRightDirY; // World space right Y direction (normalised) 16-bit
        private short worldRightDirZ; // World space right Z direction (normalised) 16-bit
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
            worldForwardDirX = decodeShort(data, 24 + offset);
            worldForwardDirY = decodeShort(data, 26 + offset);
            worldForwardDirZ = decodeShort(data, 28 + offset);
            worldRightDirX = decodeShort(data, 30 + offset);
            worldRightDirY = decodeShort(data, 32 + offset);
            worldRightDirZ = decodeShort(data, 34 + offset);
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
    public static class MotionDataPacket {
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

        public MotionDataPacket(byte[] data) {
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
        private short m_speed;
        private byte m_throttle;
        private byte m_steer;
        private byte m_brake;
        private byte m_clutch;
        private byte m_gear;
        private short m_engineRPM;
        private byte m_drs;
        private byte m_revLightsPercent;
        private short[] m_brakesTemperature = new short[4];
        private short[] m_tyresSurfaceTemperature = new short[4];
        private short[] m_tyresInnerTemperature = new short[4];
        private short m_engineTemperature;
        private float[] m_tyresPressure = new float[4];

        public IndividialCarData(byte[] data, int carIndex) {
            int offset = HEADER_SIZE_BYTES + (carIndex * INDIVIDUAL_CAR_DATA_PACKET_SIZE);

            m_speed = decodeShort(data, offset);
            m_throttle = data[offset+2];
            m_steer = data[offset+3];
            m_brake = data[offset+4];
            m_clutch = data[offset+5];
            m_gear = data[offset+6];
            m_engineRPM = decodeShort(data, offset+7);
            m_drs = data[offset+9];
            m_revLightsPercent = data[offset+10];

            m_brakesTemperature = populateShortArr(data, 4, offset+11);
            m_tyresSurfaceTemperature = populateShortArr(data, 4, offset+19);
            m_tyresInnerTemperature = populateShortArr(data, 4, offset+27);

            m_engineTemperature = decodeShort(data, offset+35);
            m_tyresPressure = populateFloatArr(data, 4, offset+37);
        }
    }

	public static final Integer CAR_DATA_PACKET_SIZE = 1085; // bytes
    @Data
    public static class CarDataPacket {
        private F12018Header header;
        private IndividialCarData[] carsData = new IndividialCarData[20];
        private int buttonStatus;

        public CarDataPacket(byte[] data) {
            this.header = new F12018Header(data);
            for(int i = 0; i < carsData.length; i++) {
                this.carsData[i] = new IndividialCarData(data, i);
            }
            this.buttonStatus = decodeInt(data, 1081);
        }
    }

    public static final Integer INDIVIDUAL_LAP_DATA_SIZE = 41;
    @Data
    public static class IndividualLapData {
        private float m_lastLapTime;
        private float m_currentLapTime;
        private float m_bestLapTime;
        private float m_sector1Time;
        private float m_sector2Time;
        private float m_lapDistance;
        private float m_totalDistance;
        private float m_safetyCarDelta;
        private byte m_carPosition;
        private byte m_currentLapNum;
        private byte m_pitStatus;
        private byte m_sector;
        private byte m_currentLapInvalid;
        private byte m_penalties;
        private byte m_gridPosition;
        private byte m_driverStatus;
        private byte m_resultStatus;

        public IndividualLapData(byte[] data, int carIndex) {
            int offset = HEADER_SIZE_BYTES + (carIndex * INDIVIDUAL_LAP_DATA_SIZE);
            m_lastLapTime = decodeFloat(data, offset);
            m_currentLapTime = decodeFloat(data, offset+4);
            m_bestLapTime = decodeFloat(data, offset+8);
            m_sector1Time = decodeFloat(data, offset+12);
            m_sector2Time = decodeFloat(data, offset+16);
            m_lapDistance = decodeFloat(data, offset+20);
            m_totalDistance = decodeFloat(data, offset+24);
            m_safetyCarDelta = decodeFloat(data, offset+28);
            m_carPosition = data[offset+32];
            m_currentLapNum = data[offset+33];
            m_pitStatus = data[offset+34];
            m_sector = data[offset+35];
            m_currentLapInvalid = data[offset+36];
            m_penalties = data[offset+37];
            m_gridPosition = data[offset+38];
            m_driverStatus = data[offset+39];
            m_resultStatus = data[offset+40];
        }
    }

    public static final Integer LAP_DATA_PACKET_SIZE = 841;
    @Data
    public static class LapDataPacket {
        private F12018Header header;
        private IndividualLapData[] lapData = new IndividualLapData[20];

        public LapDataPacket(byte[] data) {
            this.header = new F12018Header(data);
            for(int i = 0; i < lapData.length; i++) {
                this.lapData[i] = new IndividualLapData(data, i);
            }
        }
    }
}
