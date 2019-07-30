package telemetry.domain;

import lombok.Data;
import org.springframework.stereotype.Component;

import static telemetry.domain.ConversionUtils.*;

@Component
public class TelemetryDataF12019Impl {
    private static final byte HEADER_SIZE_BYTES = 23;
    private static final byte NUM_CARS = 20;

    private static final byte CAR_MOTION_DATA_SIZE_BYTES = 60;
    private static final byte INDIVIDUAL_CAR_DATA_PACKET_SIZE = 66;
	private static final short MOTION_PACKET_SIZE = 1343;
    private static final short CAR_DATA_PACKET_SIZE = 1347;

    private static final byte INDIVIDUAL_LAP_DATA_SIZE = 41;
    private static final short LAP_DATA_PACKET_SIZE = 843;

    private static final byte PACKET_ID_LOCATION = 5;

    public static final short LARGEST_PACKET_SIZE = CAR_DATA_PACKET_SIZE;

    public byte getPacketId(final byte[] data) {
        return data[PACKET_ID_LOCATION];
    }

    public MotionDataPacket getMotionData(final byte[] data) {
        return new MotionDataPacket(data);
    }

    public LapDataPacket getLapData(final byte[] data) {
        return new LapDataPacket(data);
    }

    public CarDataPacket getCarData(final byte[] data) {
        return new CarDataPacket(data);
    }

    @Data
    public class F12019Header {
        private short format;           // 2019
        private Byte gameMajorVersion;  // Game major version - "X.0﻿0"
        private Byte gameMinorVersion;  // Game minor version -﻿ "1.XX"﻿
        private Byte version;           // Version of this packet type, all start from 1
        private Byte packetId;          // Identifier for the packet type, see below
        private Long sessionId;         // Unique identifier for the session
        private float sessionTime;      // Session timestamp
        private int frameIdentifier;    // Identifier for the frame the data was retrieved on
        private Byte playerCarIndex;    // Index of player's car in the array

        private F12019Header(final byte[] data) {
            format = decodeShort(data, 0);
            gameMajorVersion = data[2];
            gameMinorVersion = data[3];
            version = data[4];
            packetId = data[5];
            sessionId = decodeLong(data, 6, 8);
            sessionTime = decodeFloat(data, 14);
            frameIdentifier = decodeInt(data, 18);
            playerCarIndex = data[22];
        }
    }

    @Data
    public class CarMotionData
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

        private CarMotionData(final byte[] data, final int carIndex) {
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

    @Data
    public class MotionDataPacket {
        private F12019Header header;                                    // Header
        private CarMotionData[] carMotionData = new CarMotionData[20];  // Data for all cars on track [20]

        // Extra player car ONLY data
        private float[] suspensionPosition;      // Note: All wheel arrays have the following order:
        private float[] suspensionVelocity;      // RL, RR, FL, FR
        private float[] suspensionAcceleration;  // RL, RR, FL, FR
        private float[] wheelSpeed;              // Speed of each wheel
        private float[] wheelSlip;               // Slip ratio for each wheel (added v1.2.1)
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

        private MotionDataPacket(final byte[] data) {
            header = new F12019Header(data);
            for(int i = 0; i < carMotionData.length; i++) {
                carMotionData[i] = new CarMotionData(data, i);
            }

            final int offset = HEADER_SIZE_BYTES + (NUM_CARS * CAR_MOTION_DATA_SIZE_BYTES);
            suspensionPosition = populateFloatArr(data, 4, offset);
            suspensionVelocity = populateFloatArr(data, 4, offset + 16);
            suspensionAcceleration = populateFloatArr(data, 4, offset + 32);
            wheelSpeed = populateFloatArr(data, 4, offset + 48);
            wheelSlip = populateFloatArr(data, 4, offset + 64);

            localVelocityX = decodeFloat(data, offset + 80);
            localVelocityY = decodeFloat(data, offset + 84);
            localVelocityZ = decodeFloat(data, offset + 88);
            angularVelocityX = decodeFloat(data, offset + 92);
            angularVelocityY = decodeFloat(data, offset + 96);
            angularVelocityZ = decodeFloat(data, offset + 100);
            angularAccelerationX = decodeFloat(data, offset + 104);
            angularAccelerationY = decodeFloat(data, offset + 108);
            angularAccelerationZ = decodeFloat(data, offset + 112);
            frontWheelsAngle = decodeFloat(data, offset + 116);
        }
    }

    @Data
    public class IndividialCarData {
        private short m_speed;
        private float m_throttle;
        private float m_steer;
        private float m_brake;
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
        private byte[] m_surfaceType = new byte[4];

        private IndividialCarData(final byte[] data, final int carIndex) {
            int offset = HEADER_SIZE_BYTES + (carIndex * INDIVIDUAL_CAR_DATA_PACKET_SIZE);

            m_speed = decodeShort(data, offset);
            m_throttle = decodeFloat(data, offset+2);
            m_steer = decodeFloat(data, offset+6);
            m_brake = decodeFloat(data, offset+10);
            m_clutch = data[offset+14];
            m_gear = data[offset+15];
            m_engineRPM = decodeShort(data, offset+16);
            m_drs = data[offset+18];
            m_revLightsPercent = data[offset+19];

            m_brakesTemperature = populateShortArr(data, 4, offset+20);
            m_tyresSurfaceTemperature = populateShortArr(data, 4, offset+28);
            m_tyresInnerTemperature = populateShortArr(data, 4, offset+36);

            m_engineTemperature = decodeShort(data, offset+44);
            m_tyresPressure = populateFloatArr(data, 4, offset+46);
            m_surfaceType = populateByteArr(data, 4, offset+62);
        }
    }

    @Data
    public class CarDataPacket {
        private F12019Header header;
        private IndividialCarData[] carsData = new IndividialCarData[20];
        private int buttonStatus;

        private CarDataPacket(final byte[] data) {
            this.header = new F12019Header(data);
            for(int i = 0; i < carsData.length; i++) {
                this.carsData[i] = new IndividialCarData(data, i);
            }
            this.buttonStatus = decodeInt(data, 1081);
        }
    }

    @Data
    public class IndividualLapData {
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

        private IndividualLapData(final byte[] data, final int carIndex) {
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

    @Data
    public class LapDataPacket {
        private F12019Header header;
        private IndividualLapData[] lapData = new IndividualLapData[20];

        private LapDataPacket(final byte[] data) {
            this.header = new F12019Header(data);
            for(int i = 0; i < lapData.length; i++) {
                this.lapData[i] = new IndividualLapData(data, i);
            }
        }
    }
}
