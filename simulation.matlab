% CubeSat Attitude Simulation (1-axis for simplicity)

% Time parameters
dt = 0.01;  % timestep
T = 10;     % total time
t = 0:dt:T;

% CubeSat parameters
I = 0.01;   % Moment of inertia [kg*m^2]

% Initialize variables
theta = zeros(size(t));    % angle [deg]
omega = zeros(size(t));    % angular velocity [deg/s]
tau = zeros(size(t));      % control torque
theta_des = 30;            % desired angle [deg]

% PID gains
Kp = 0.5; Ki = 0.01; Kd = 0.1;
integral = 0; prev_error = 0;

for i = 2:length(t)
    error = theta_des - theta(i-1);
    integral = integral + error*dt;
    derivative = (error - prev_error)/dt;
    
    % PID control torque
    tau(i) = Kp*error + Ki*integral + Kd*derivative;
    
    % Dynamics: theta'' = tau/I
    alpha = tau(i)/I;          % angular acceleration
    omega(i) = omega(i-1) + alpha*dt;
    theta(i) = theta(i-1) + omega(i)*dt;
    
    prev_error = error;
end

% Plot results
figure;
plot(t, theta, 'LineWidth', 2);
hold on;
plot(t, tau, '--', 'LineWidth', 1.5);
xlabel('Time [s]');
ylabel('Angle [deg] / Torque [Nm]');
legend('Angle','Control Torque');
title('STHIURA CubeSat Attitude Simulation');
grid on;
