%{
This file creates an object containing all the constant values
%}

% Material Data
Const.Material.ymodulus = 7.0e10; % Young's Modulus, [Pa]
Const.Material.density = 2800; % Density, [kg/m^3]
Const.Material.ystress_t = 2.95e8; % Tension yield stress [Pa]
Const.Material.ystress_c = 2.95e8; % Compression yield stress [Pa]

% Structure Data
Const.Structure.panelfact = 0.96; % Panel factor for Z-type stringers
Const.Structure.rib_pitch = 0.5; % Rib pitch [m]

% Aircraft Data
Const.AC.Range = 1794*1852; % Design range, [nm] to [m]

% Engine Data
Const.Engines.C_T = 1.8639e-4; % Thrust specific fuel consumption, from assignment [N/Ns]

% Cruise Conditions
Const.Cruise.V = 371*0.514444; % Cruise speed, [kts] to [m/s]
Const.Cruise.h = 29000*0.3048; % Cruise altitude, [ft] to [m]
Const.Cruise.a = 304.484; % Speed of sound at cruise (from ISA), [m/s]nm 
Const.Cruise.M = Const.Cruise.V/Const.Cruise.a; % Cruise Mach number