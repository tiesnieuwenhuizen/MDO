%{
This file uses the original aircraft data to construct the initial design
vector
%}

% Direct inputs to design vector

S0 = 77.3; % m^2, total area
b0 = 26.21; % m, total span
Lambda_i_0 = 15; % deg, INCORRECT, CHANGE TO LE SWEEP
Lambda_o_0 = 15; % deg, INCORRECT, CHANGE TO LE SWEEP
lambda_i_0 = 0.356; % -
% lambda_o_0 = lambda_i_0; % -
phi_i_0 = 0; % deg, ASSUMED, NO INFO
phi_o_0 = 0; % deg, ASSUMED, NO INFO
W_f_0 = 8955; % kg

% Values for deriving design variables
MTOW_0 = 46040; % kg
MZF_0 = 37421; % kg
PL_des = 10925; % kg
OEW_0 = 26160; % kg
W_des_0 = sqrt(MTOW*(MTOW-W_f_0)); % kg, Formula from assignment, middle of cruise weight
tc_r_0 = 15.3; % %
tc_t_0 = 12.2; % %
c_r_0 = 2.75; % m
c_t_0 = 0.91; % m
LD_ref = 16; % - , ASSUMED, NO INFO, L/D for reference aircraft

% Airfoil CST curve calculations - Withcomb 135 airfoil used
tc_withcomb = 8; % %
n_CST = 12; % Number of CST coefficients per side
CST_0 = AirfoilOpt(n_CST); % 2*n_CST because both sides will be determined

% Scale airfoils for correct thickness
CST_r_0 = (tc_r_0/tc_withcomb).*CST_0;
CST_t_0 = (tc_t_0/tc_withcomb).*CST_0;

% Initialise design vector
x0 = [S0, b0, Lambda_i_0, Lambda_o_0, lambda_i_0, phi_i_0, phi_o_0, CST_r_0, CST_t_0, 0, W_f_0, 0];

% Aerodynamics calculation
LD_0 = Aerodynamics(x0);
x0(34) = LD_0;

% Loading calculation
[CST_L_0, SF_L_0, N2_0] = Loading(x0);
x0 = [x0, CST_L_0, SF_L, N2_0];

% Structure calculations
W_w_0 = Structures(x0);
x0(32) = W_w_0;

% A-W group contributions
Const.AWGroup.weight = MZF_0 - W_w_0;
D_0 = W_des_0/LD_0; % Drag of the wing for middle of cruise
D_ref = W_des_0/LD_ref; % Drag of the reference aircraft in middle of cruise
Const.AWGroup.drag = D_ref - D_0;
