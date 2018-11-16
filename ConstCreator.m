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
Const.Structure.loc_fspar = 0.2; % Front spar location [-]
Const.Structure.loc_rspar = 0.8; % Rear spar location [-]
Const.Structure.displayoption = 1; % EMWET display option

% Aircraft Data
Const.AC.Range  = 1794*1852; % Design range, [nm] to [m]
Const.AC.WS_max = []; % maximum permissible wing loading [N/m]
% Const.AC.W_fuse = ; % Weight of the fuselage [N] -> ALREADY DEFINED IN InitialVector.m
Const.AC.n_max = 2.5; % Maximum load factor, from assignment [-]

% Engine Data
Const.Engines.C_T = 1.8639e-4; % Thrust specific fuel consumption, from assignment [N/Ns]
Const.Engines.n = 4; % Number of engines [-]
%%%%%%%%%%%% UPDATE VALUES %%%%%%%%%%%%%%%%%%%%%%
Const.Engines.loc = [0.35 0.5]; % Spanwise position of engines [inboard, outboard] [-]
Const.Engines.w = [1969 1969]; % Engine weights [inboard, outboard] [kg]

% Cruise Conditions
Const.Cruise.V = 371*0.514444; % Cruise speed, [kts] to [m/s]
Const.Cruise.h = 29000*0.3048; % Cruise altitude, [ft] to [m]
Const.Cruise.rho = 0.475448; % Density at cruise altitude, [Pa]
Const.Cruise.a = 304.484; % Speed of sound at cruise (from ISA), [m/s]nm 
Const.Cruise.M = Const.Cruise.V/Const.Cruise.a; % Cruise Mach number
Const.Cruise.mu = 1.5106696E-5 %Cruise Viscosity [kg/ms]
Const.Cruise.T = 230.695 % Cruise Temperature [T]
% Const.Cruise.Re = Const.Cruise.rho*


% Fuel Constants
Const.Fuel.rho = 0.81715*10^3; % Tuel density [kg/m?]
Const.Fuel.f   = 0.93; % Tank volume discount factor [-]
Const.Fuel.tank_start = 0.1; % Fuel tank spanwise start [-]
Const.Fuel.tank_end = 0.7; % Fuel tank spanwise end [-]

% Wing Constants
Const.Wing.y_k = 0.4*26.21*0.5; % y-position of the kink [m]
Const.Wing.n_sec = 2; % Number of trapezoids the wing constists of [-]
Const.Wing.n_airfoils = 2; % Number of airfoils used (1 for root, 1 for tip) [-]
Const.Wing.incidence = 3.1; % Incidence angle at root

global Const


