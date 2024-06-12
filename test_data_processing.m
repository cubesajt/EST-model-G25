% Read data from mes1.csv to mes4.csv
num_files = 4;
error_data = containers.Map;

[time_data, flowrate_data, pressure_data, buffered_pressure_data] = read_mes_data(num_files, error_data);

% Create a new figure
figure;

% Plot the data points for trials 1-4
hold on;
for n = 1:num_files
    plot(buffered_pressure_data{n}, flowrate_data{n}.^2, 'DisplayName', sprintf('Trial %d', n));
end

% Fit a linear regression line with y-intercept 0
x_values = [];
y_values = [];
for n = 1:num_files
    valid_indices = buffered_pressure_data{n} >= 0 & buffered_pressure_data{n} <= 1.5; % Filter valid pressure values
    x_values = [x_values; buffered_pressure_data{n}(valid_indices)];
    y_values = [y_values; flowrate_data{n}(valid_indices).^2];
end
coefficients = polyfit(x_values, y_values, 1); % Linear regression
regression_line = @(x) coefficients(1) * x; % y = mx
x_fit = linspace(0, 1.5, 100); % Only consider pressures from 0 to 1.5
y_fit = regression_line(x_fit);
plot(x_fit, y_fit, 'r--', 'LineWidth', 2, 'DisplayName', 'Regression Line'); % Overlay the regression line

disp(['The gradient is: ', num2str(coefficients(1))]);
disp(['C = ', num2str(sqrt(coefficients(1)))]);

% Max min for error bars
pressure_values = 0.1:0.1:1.5; % Define the range of pressure values to consider
for n = 1:length(pressure_values)
    key = num2str(pressure_values(n));
    if isKey(error_data, key)
        flowrates = error_data(key);
        minQ = min(flowrates)/10;
        maxQ = max(flowrates)/10;
        meanQ = mean(flowrates);
        % Plot the error bars
        errorbar(pressure_values(n), meanQ^2, minQ^2, maxQ^2, 'k');
    end
end

% Add labels and title
xlabel('Buffered Pressure (bar)');
ylabel('Flowrate^2 (L^2/s^2)');
title('Buffered Pressure vs Flowrate^2');
grid on;

% Add a legend
legend('Location', 'best');

function [time, flowrate, pressure, bufferedPressure] = read_mes_data(num_files, error_data)
    time = cell(1, num_files);
    flowrate = cell(1, num_files);
    pressure = cell(1, num_files);
    bufferedPressure = cell(1, num_files);

    for i = 1:num_files
        filename = sprintf('mes%d.csv', i);
        data = csvread(filename);
        time{i} = data(:, 1);
        flowrate{i} = data(:, 2);
        pressure{i} = data(:, 3);
        bufferedPressure{i} = data(:, 4);

        for n = 1:15
            for r = 1:length(bufferedPressure{i})
                if (n/10 - 0.05) < bufferedPressure{i}(r) && bufferedPressure{i}(r) < (n/10 + 0.05)
                    key = num2str(n/10);
                    if isKey(error_data, key)
                        error_data(key) = [error_data(key); flowrate{i}(r)];
                    else
                        error_data(key) = flowrate{i}(r);
                    end
                end 
            end
        end
    end
end


