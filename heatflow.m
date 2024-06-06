% This code calculates the work done by pressurizing the airtank

airtankVol = ; % volume of the airtank (m^3)
pressureInitial = ; % initial pressure in Pa
pressureFinal = ; % final pressure in Pa

pressureChange = pressureFinal - pressureInitial;   % change in pressure (Pa)

function work = workDone(pressureChange);
  % This function calculates the work done by a pressure change in an airtank.

  % Arguments:
  %   pressureChange: The change in pressure (Pa)
  %   airtankVol: The volume of the airtank (m^3)

  % Returns:
  %   The work done (J)

  work = pressureChange * airtankVol;
end

% This section of code determines the final temperature of the gas inside the 
% pressure vessle after a change in pressure

tempInitial = 293;  % initial internal airtank temperature (K)
R = 8.3145 ;    %   universal gas constant (J/mol*K)
airMolarMass = 0.02896; %   molar mass of air (kg)

function temp = tempFinal[tempInitial, pressureChange, pressureFinal];
  % This function calculates the final air temperature caused by a pressure
  % change in an airtank.

  % Arguments:
  %   tempInitial:  The initial internal airtank temperature (K)
  %   pressureChange: The change in pressure (Pa)
  %   pressureFinal: The final airtank pressure (Pa)

  % Returns:
  %   The final internal airtank temperature (K)

  temp = tempInitial/(1-(workDone(pressureChange) * R)/(pressureFinal * airtankVol * airMolarMass))
end

% The following section of code approximates the heatflow through different
% mediums surrounding the air in the airtank. The following assumptions 
% have been made:
%   -   surface area of the internal/external airtank/insulation is identical
%   -   the heat flow conducts through the tank and insulation and convects
%       into air.
%   -   tempSurroundings = tempInitial (in the case of initial
%       pressurization)
%
% The temperature boundaries are as follows:
%   -   	temp1 inside the tank (K)
%   -   	temp2 between the tank and insulation (K)
%   -   	temp3 on the external side of the insulation (K)
%   -   	tempSurrounding is temperature of the surroundings (K)


tempSurrounding = tempInitial; 
temp1 = tempFinal[tempInitial, pressureChange, pressureFinal];

surfaceArea = ;    % surface area of the airtank/insulation (m^2)
kTank = ;   % airtanks conduction coefficient (W/(m*K))
kIns = ;    % airtank insulations conduction coefficient (W/(m*K))
xTank = ;   % airtank thickness (m)
xIns = ;    % airtank insulation thickness (m)
hAir = ;    % convection coefficient of air (W/(m^2*K)

temp3 = (hAir * tempSurrounding + temp1(kTank / xTank) * (kTank / xTank - 1)) / (hAir - (kTank * kIns) / (xTank * xIns));
temp2 = temp3 * kIns / xIns + temp1 * kTank / xTank;

heatFlowPrompt = 'The heat flow with the chosen insulation is:';
disp(heatFlowPrompt);

heatFlow = kTank * (temp2 - temp1) / xTank



