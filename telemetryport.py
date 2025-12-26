# File: ground_station/telemetry_plot.py

import serial
import matplotlib.pyplot as plt
from collections import deque

# Serial port (adjust for your system)
ser = serial.Serial('COM3', 115200, timeout=1)

# Initialize real-time plotting
plt.ion()
fig, ax = plt.subplots()
angle_data = deque(maxlen=500)
output_data = deque(maxlen=500)
line1, = ax.plot([], [], label='Angle')
line2, = ax.plot([], [], label='PID Output')
ax.set_ylim(-180, 180)
ax.set_xlim(0, 500)
ax.legend()

while True:
    try:
        line = ser.readline().decode().strip()
        if line:
            angle, output = map(float, line.split(','))
            angle_data.append(angle)
            output_data.append(output)

            line1.set_ydata(angle_data)
            line1.set_xdata(range(len(angle_data)))
            line2.set_ydata(output_data)
            line2.set_xdata(range(len(output_data)))
            plt.pause(0.01)
    except KeyboardInterrupt:
        break
