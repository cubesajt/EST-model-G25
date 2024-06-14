% Post-processing script for the EST Simulink model. This script is invoked
% after the Simulink model is finished running (stopFcn callback function).

close all;
figure;

%% Supply and demand
subplot(3,3,1);
plot(tout/unit("day"), PSupply/unit("W"));
hold on;
plot(tout/unit("day"), PDemand/unit("W"));
xlim([0 tout(end)/unit("day")]);
grid on;
title('Supply and demand');
xlabel('Time [day]');
ylabel('Power [W]');
legend("Supply","Demand");

%% Stored energy
subplot(3,3,2);
plot(tout/unit("day"), EStorage/unit("J"));
xlim([0 tout(end)/unit("day")]);
grid on;
title('Storage');
xlabel('Time [day]');
ylabel('Energy [J]');

%% Energy losses
subplot(3,3,3);
plot(tout/unit("day"), D/unit("W"));
xlim([0 tout(end)/unit("day")]);
grid on;
title('Losses');
xlabel('Time [day]');
ylabel('Dissipation rate [W]');

%% Load balancing
subplot(3,3,4);
plot(tout/unit("day"), PSell/unit("W"));
hold on;
plot(tout/unit("day"), PBuy/unit("W"));
xlim([0 tout(end)/unit("day")]);
grid on;
title('Load balancing');
xlabel('Time [day]');
ylabel('Power [W]');
legend("Sell","Buy");

%% Power vs. time
subplot(3,3,5);
plot(tout/unit("day"), PSupply/unit("W"));
hold on;
plot(tout/unit("day"), PDemand/unit("W"));
plot(tout/unit("day"), PSell/unit("W"));
plot(tout/unit("day"), PBuy/unit("W"));
xlim([0 tout(end)/unit("day")]);
grid on;
title('Power vs. Time');
xlabel('Time [day]');
ylabel('Power [W]');
legend("Supply","Demand","Sell","Buy");

%% Efficiency vs. time
Efficiency = (PDemand - D) ./ PSupply * 100; % Calculate efficiency as percentage
subplot(3,3,6);
plot(tout/unit("day"), Efficiency);
xlim([0 tout(end)/unit("day")]);
grid on;
title('Efficiency vs. Time');
xlabel('Time [day]');
ylabel('Efficiency [%]');

%% Pie charts

% integrate the power signals in time
EfromSupplyTransport = trapz(tout, PfromSupplyTransport);
EtoDemandTransport   = trapz(tout, PtoDemandTransport);
ESell                = trapz(tout, PSell);
EBuy                 = trapz(tout, PBuy);
EtoInjection         = trapz(tout, PtoInjection);
EfromExtraction      = trapz(tout, PfromExtraction);
EStorageDissipation  = trapz(tout, DStorage);
EDirect              = EfromSupplyTransport - ESell - EtoInjection;
ESurplus             = EtoInjection-EfromExtraction-EStorageDissipation;

figure;
tiles = tiledlayout(1,2);

ax = nexttile;
pie(ax, [EDirect, EtoInjection, ESell]/EfromSupplyTransport);
lgd = legend({"Direct to demand", "To storage", "Sold"});
lgd.Layout.Tile = "south";
title(sprintf("Received energy %3.2e [J]", EfromSupplyTransport/unit('J')));


ax = nexttile;
pie(ax, [EDirect, EfromExtraction, EBuy]/EtoDemandTransport);
lgd = legend({"Direct from supply", "From storage", "Bought"});
lgd.Layout.Tile = "south";
title(sprintf("Delivered energy %3.2e [J]", EtoDemandTransport/unit('J')));

% storage system
EStorageMax     = 6.94.*unit("GWh"); % Maximum energy
EStorageMin     = 0.0*unit("kWh"); % Minimum energy
EStorageInitial = 2.0*unit("GWh"); % Initial energy
bStorage        = 1.54e-5/unit("s");  % Storage dissipation coefficient
tankVolume      = 1000; % m3
numTank         = 10000;
tankPres        = 7000000; %Pa
extractionPipeRad = 0.03;

% extraction system
aExtraction = 0.4; % Dissipation coefficient

% transport to demand
aDemandTransport = 0.037; % Dissipation coefficient

