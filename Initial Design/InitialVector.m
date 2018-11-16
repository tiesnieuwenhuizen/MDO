%{
This file uses the original aircraft data to construct the initial design
vector
%}

clear all
clc

ConstCreator;
% disp('Const object created')

% Values for deriving design variables
MTOW_0 = 46040; % kg
MZF_0 = 37421; % kg
PL_des = 10925; % kg
OEW_0 = 26160; % kg
W_f_0 = 8955; % kg
W_des_0 = sqrt(MTOW_0*(MTOW_0-W_f_0)); % kg, Formula from assignment, middle of cruise weight
tc_r_0 = 15.3; % %
tc_t_0 = 12.2; % %
c_r_0 = 2.75; % m
c_t_0 = 0.91; % m
LD_ref = 16; % - , ASSUMED, NO INFO, L/D for reference aircraft

% Direct inputs to design vector

S0 = 77.3; % m^2, total area
b0 = 26.21; % m, total span
lambda_i_0 = 0.356; % -
Lambda_i_0 = 15-(c_r_0/(2*b0))*(lambda_i_0-1); % deg
Lambda_i_0 = deg2rad(Lambda_i_0); % rad
Lambda_o_0 = Lambda_i_0; % deg
Lambda_o_0 = deg2rad(Lambda_o_0); % rad
% lambda_o_0 = lambda_i_0; % -
phi_i_0 = 0; % deg, ASSUMED, NO INFO
phi_o_0 = -3.1; % deg, ASSUMED, NO INFO
W_f_0 = 8955; % kg

% Airfoil CST curve calculations - Withcomb 135 airfoil used
disp('Starting airfoil curvefit')

tc_withcomb = 8; % %
n_CST = 6; % Number of CST coefficients per side
CST_0 = AirfoilOpt(2*n_CST); % 2*n_CST because both sides will be determined

% Scale airfoils for correct thickness
CST_r_0 = (tc_r_0/tc_withcomb).*CST_0;
CST_t_0 = (tc_t_0/tc_withcomb).*CST_0;

disp('Airfoils Parameterised')

% Initialise design vector
global x0;
x0 = [S0, b0, Lambda_i_0, Lambda_o_0, lambda_i_0, phi_i_0, phi_o_0, CST_r_0, CST_t_0, 0, W_f_0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

disp('Design vector initialised')
disp('Starting Aerodynamics')

% Aerodynamics calculation
cd Aerodynamics
LD_0 = AerodynamicsInit(x0,W_des_0);
cd ../
% x0(34) = 16; %LD_0; # DUMMY VALUE FOR UNIT TESTING

disp('Finished Aerodynamics, starting Loading')

% Loading calculation
cd Loads
load = LoadsInit(x0, MTOW_0);
x0(35:48) = load;
cd ../

disp('Finished loading, starting Structures')

% Structure calculations
cd Structures
W_w_0 = StructuresInit(x0,MTOW_0,MZF_0);
x0(32) = W_w_0;
cd ../

disp('Finished Structures')

% A-W group contributions
Const.AWGroup.weight = MZF_0 - W_w_0;
D_0 = W_des_0/x0(34); % Drag of the wing for middle of cruise
D_ref = W_des_0/LD_ref; % Drag of the reference aircraft in middle of cruise
Const.AWGroup.drag = D_ref - D_0;
