%{
This file uses the original aircraft data to construct the initial design
vector
%}

clear all
clc

ConstCreator;
% disp('Const object created')




% Values for deriving design variables
MTOW_0 = 46040*9.81; %  N
MZF_0 = 37421*9.81; %  N
PL_des = 10925*9.81; %  N
OEW_0 = 26160*9.81; % N
W_f_0 = 8955*9.81; % N
W_des_0 = sqrt(MTOW_0*(MTOW_0-W_f_0)); %  N, Formula from assignment, middle of cruise weight
tc_r_0 = 14%15.3; % %
tc_t_0 = 8%12.2; % %
c_r_0 = 4.35; % m
c_t_0 = 1.5486; % m
LD_ref = 16; % - , ASSUMED, NO INFO, L/D for reference aircraft

% Direct inputs to design vector

S0 = 77.3; % m^2, total area
b0 = 26.21; % m, total span
lambda_i_0 = 0.356; % -
Lambda_0 = atan(tan(deg2rad(15))-(c_r_0/(2*b0))*(lambda_i_0-1)); % deg
Lambda_i_0 = Lambda_0; % rad
Lambda_o_0 = Lambda_i_0; % deg
lambda_o_0 = 0.4795259; % -
phi_i_0 = 0; % deg, ASSUMED, NO INFO
phi_o_0 = -3.1; % deg, ASSUMED, NO INFO


% Airfoil CST curve calculations - Withcomb 135 airfoil used
disp('Starting airfoil curvefit')

tc_whitcomb = 11; % %
n_CST = 6; % Number of CST coefficients per side
CST_0 = AirfoilOpt(2*n_CST); % 2*n_CST because both sides will be determined

% Scale airfoils for correct thickness
CST_r_0 = (tc_r_0/tc_whitcomb).*CST_0;
CST_t_0 = (tc_t_0/tc_whitcomb).*CST_0;



disp('Airfoils Parameterised')

% Initialise design vector
global x0;
x0 = [S0, b0, Lambda_i_0, Lambda_o_0, lambda_o_0, phi_i_0, phi_o_0, CST_r_0, CST_t_0, 0, W_f_0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

disp('Design vector initialised')
disp('Starting Aerodynamics')

% Aerodynamics calculation
cd Aerodynamics
x0(34) = AerodynamicsInit(x0,W_des_0);
cd ../
% x0(34) = 16; %LD_0; # DUMMY VALUE FOR UNIT TESTING

disp('Finished Aerodynamics, starting Loading')

% Loading calculation
cd Loads
load = LoadsInit(x0, MTOW_0);
x0(35:48) = load;
cd ../

disp('Finished Loading, starting Structures')

% Structure calculations
cd Structures
W_w_0 = StructuresInit(x0,MTOW_0,MZF_0);
x0(32) = W_w_0;
cd ../

disp('Finished Structures')

% A-W group contributions
Const.AWGroup.weight = MTOW_0-W_w_0-W_f_0-PL_des; %MZF_0 - W_w_0;

%Const.AWGroup.drag - defined from AerodynamicsInit
