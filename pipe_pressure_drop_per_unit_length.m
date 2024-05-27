DynamicViscosity = 18.13 * 10 ^ (-6); % dynamic viscocity of fluid (Pa s) at respective flow temperature (assumed 293K)
Flowrate = ?; % flow rate of fluid (m^3 / s)
Length = 1; % length of the pipe (m)
Density = 1.225; % density of the fluid (kg/m^3)
Diameter = ? 0.002; % diameter of the pipe (m)
Roughness = 0.0015 * 10 ^ (-3); % pipe roughness coefficient (m)

disp(['The pressure drop for your specified parameters is: ', num2str(PressureDrop(Length, Diameter, DynamicViscosity, Flowrate, Density, Roughness)), ' Pa']);

function velocity = Velocity(FlowRate, Diameter)
    % Determines the mean velocity of a fluid in a pipe depending on its diameter and flow rate

    % Parameters:
    % FlowRate: The volumetric flow rate of the fluid through the pipe (in meters cubed per second).
    % Diameter: The internal pipe diameter for which the fluid flows through (in meters).

    % Returns:
    % velocity: The mean velocity of the fluid flowing through the pipe (in meters per second).

    velocity = 4 * FlowRate / (pi * Diameter^2);
end

function ReynoldsNumber = ReynoldsNumber(Density, Length, Viscosity, Flowrate, Diameter)
    % Determines the Reynolds number for a flow of specified parameters.

    % Parameters:
    % Density: The density of the fluid flowing through the pipe (in kilograms per cubic meters).
    % Length: Length of the straight circular pipe across which the pressure drop occurs (in meters).
    % Viscosity: The dynamic viscosity of the fluid flowing through the pipe (in pascal seconds). Keep in mind the viscosity changes with temperature.
    % Flowrate: The volumetric flow rate of the fluid through the pipe (in meters cubed per second).
    % Diameter: The internal pipe diameter for which the fluid flows through (in meters).

    % Returns:
    % ReynoldsNumber: The Reynolds number for the specified flow (dimensionless).

    velocity = Velocity(Flowrate, Diameter);
    ReynoldsNumber = Density * Length * velocity / Viscosity;
end

function DarcyFrictionFactor = SolveColebrook(Roughness, Diameter, Density, Length, Viscosity, Flowrate)
    % Solves the Colebrook equation for the friction factor.

    % Parameters:
    % Roughness: The pipe roughness (in meters).
    % Diameter: The internal pipe diameter for which the fluid flows through (in meters).
    % Density: The density of the fluid flowing through the pipe (in kilograms per cubic meters).
    % Length: Length of the straight circular pipe across which the pressure drop occurs (in meters).
    % Viscosity: The dynamic viscosity of the fluid flowing through the pipe (in pascal seconds). Keep in mind the viscosity changes with temperature.
    % Flowrate: The volumetric flow rate of the fluid through the pipe (in meters cubed per second).

    % Returns:
    % DarcyFrictionFactor: The Darcy friction factor for the specified pipe (dimensionless)

    Colebrook = @(f) 1/sqrt(f) + 2*log10((Roughness / Diameter)/3.7 + 2.51/(ReynoldsNumber(Density, Length, Viscosity, Flowrate, Diameter)*sqrt(f)));
    DarcyFrictionFactor = fzero(Colebrook, [0.005, 0.1]);
end

text = 'Pipe Pressure Drop per Unit Length is :';
disp(text);
function PressureDrop = PressureDrop(Length, Diameter, Viscosity, Flowrate, Density, Roughness)
    % Uses a rearranged Darcy-Weisbach equation to solve the pipe diameter for a laminar flow of given diameters. 
    % The Darcy friction fraction has already been substituted for a circular pipe diameter.

    % Parameters:
    % Length: Length of the straight circular pipe across which the pressure drop occurs (in meters).
    % Diameter: The internal pipe diameter for which the fluid flows through (in meters).
    % Viscosity: The dynamic viscosity of the fluid flowing through the pipe (in pascal seconds). Keep in mind the viscosity changes with temperature.
    % Flowrate: The volumetric flow rate of the fluid through the pipe (in meters cubed per second).
    % Density: The density of the fluid flowing through the pipe (in kilograms per cubic meters).
    % Roughness: The pipe roughness (in meters).

    % Returns:
    % PressureDrop: The change in pressure that occurs between the two ends of the straight circular pipe (in pascals).

    DarcyFrictionFactor = SolveColebrook(Roughness, Diameter, Density, Length, Viscosity, Flowrate);
    PressureDrop = DarcyFrictionFactor * 8 * Density * Length * Flowrate^2 / (pi^2 * Diameter^5);
end