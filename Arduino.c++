// File: firmware/imu_read_control.ino

#include <Wire.h>
#include <MPU6050.h>
#include <Servo.h>

// Initialize MPU6050
MPU6050 imu;

// Optional actuator
Servo reactionWheel;

// PID variables
float setPoint = 0; // desired angle
float Kp = 1.0, Ki = 0.01, Kd = 0.1;
float error, prevError = 0, integral = 0;

void setup() {
  Serial.begin(115200);
  Wire.begin();
  imu.initialize();

  // Attach servo to pin 9
  reactionWheel.attach(9);

  if (!imu.testConnection()) {
    Serial.println("IMU connection failed!");
    while (1);
  }
  Serial.println("STHIURA Initialized.");
}

void loop() {
  int16_t ax, ay, az, gx, gy, gz;
  imu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

  // Convert gyroscope to angle (simplified)
  float angle = gx / 131.0;

  // PID control (basic)
  error = setPoint - angle;
  integral += error * 0.01;
  float derivative = (error - prevError) / 0.01;
  float output = Kp * error + Ki * integral + Kd * derivative;
  prevError = error;

  // Control actuator
  int pwm = constrain(map(output, -180, 180, 0, 180), 0, 180);
  reactionWheel.write(pwm);

  // Send telemetry over Serial
  Serial.print(angle);
  Serial.print(",");
  Serial.println(output);

  delay(10);
}
