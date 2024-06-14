data = readmatrix('data.csv');
time = data(:, 1);
flowrate = data(:, 2);
pressure = data(:, 3);
bufferedPressure = data(:, 4);

figure;

subplot(2, 2, 1);
plot(time, flowrate);
xlabel('Time (s)');
ylabel('Flowrate (L/s)');
title('Flowrate vs Time');
grid on;

subplot(2, 2, 2);
plot(time, pressure);
xlabel('Time (s)');
ylabel('Pressure (bar)');
title('Pressure vs Time');
grid on;

subplot(2, 2, 3);
plot(time, bufferedPressure);
xlabel('Time (s)');
ylabel('Pressure (bar)');
title('Buffered Pressure vs Time');
grid on;
