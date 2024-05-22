data = readmatrix('data.csv');
time = data(:, 1);
flowrate = data(:, 2);
pressure = data(:, 3);

figure;

subplot(1, 2, 1);
plot(time, flowrate);
xlabel('Time (ms)');
ylabel('Flowrate (L/s)');
title('Flowrate vs Time');
grid on;

subplot(1, 2, 2);
plot(time, pressure);
xlabel('Time (ms)');
ylabel('Pressure (kPa)');
title('Pressure vs Time');
grid on;