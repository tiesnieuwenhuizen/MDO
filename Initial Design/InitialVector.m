%{
This file uses the original aircraft data to construct the initial design
vector
%}

% Values for deriving design variables
MTOW_0 = 46040; % kg
MZF_0 = 37421; % kg
PL_des = 10925; % kg
OEW_0 = 26160; % kg
tc_r_0 = 15.3; % %
tc_t_0 = 12.2; % %
c_r_0 = 2.75; % m
c_t_0 = 0.91; % m

% Direct inputs to design vector

S0 = 77.3; % m^2, total area
b0 = 26.21; % m, total span
lambda_i_0 = 0.356; % -
% lambda_o_0 = lambda_i_0; % -
phi_i_0 = 0; % ASSUMED, NO INFO
phi_o_0 = 0; % ASSUMED, NO INFO
W_f_0 = 8955; % kg

% Airfoil CST curve calculations - Withcomb 135 airfoil used
tc_withcomb = 8; % %
n_CST = 12; % Number of CST coefficients per side
CST_0 = AirfoilOpt(n_CST); % 2*n_CST because both sides will be determined

% Scale airfoils for correct thickness
CST_r_0 = (tc_r_0/tc_withcomb).*CST_0;
CST_t_0 = (tc_t_0/tc_withcomb).*CST_0;

% Loading calculation

% Fuselage drag
