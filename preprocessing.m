% Pre-processing script for the EST Simulink model. This script is invoked
% before the Simulink model starts running (initFcn callback function).

%% Load the supply and demand data

timeUnit   = 's';

supplyFile = "Team25_supply.csv";
supplyUnit = "MW";

% load the supply data
Supply = loadSupplyData(supplyFile, timeUnit, supplyUnit);

demandFile = "Team25_demand.csv";
demandUnit = "MW";

% load the demand data
Demand = loadDemandData(demandFile, timeUnit, demandUnit);

%% Simulation settings

deltat = 5*unit("min");
stopt  = min([Supply.Timeinfo.End, Demand.Timeinfo.End]);

%% System parameters

% transport from supply
aSupplyTransport = 0.055; % Dissipation coefficient of transformers

% injection system
aInjection = 0.4; % Dissipation coefficient
pCompressor = 3.31*unit("kW"); % Power of Compressor
numCompressors = 94; % Number of Compressors

% storage system
EStorageMax     = 13.1.*unit("GWh"); % Maximum energy
EStorageMin     = 0.0*unit("kWh"); % Minimum energy
EStorageInitial = 2.0*unit("GWh"); % Initial energy
bStorage        = 0.00079/unit("s");  % Storage dissipation coefficient

% extraction system
aExtraction = 0.4; % Dissipation coefficient

% transport to demand
aDemandTransport = 0.037; % Dissipation coefficient