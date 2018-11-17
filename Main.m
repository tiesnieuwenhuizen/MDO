%{
This is the main executable file for the optimisation
Use this file to edit process flow
%}
clc
clear all
close all


% Create constant value object
ConstCreator

% Create Initial Design Vector
InitialVector

% Vector layout:
% 1  S
% 2  b
% 3  Lambda_i
% 4  Lambda_o
% 5  lambda_o
% 6  phi_i
% 7  phi_o
% 8  CST_Aiu_1
% 9  CST_Aiu_2
% 10 CST_Aiu_3
% 11 CST_Aiu_4
% 12 CST_Aiu_5
% 13 CST_Aiu_6
% 14 CST_Ail_1
% 15 CST_Ail_2
% 16 CST_Ail_3
% 17 CST_Ail_4
% 18 CST_Ail_5
% 19 CST_Ail_6
% 20 CST_Aou_1
% 21 CST_Aou_2
% 22 CST_Aou_3
% 23 CST_Aou_4
% 24 CST_Aou_5
% 25 CST_Aou_6
% 26 CST_Aol_1
% 27 CST_Aol_2
% 28 CST_Aol_3
% 29 CST_Aol_4
% 30 CST_Aol_5
% 31 CST_Aol_6
% 32 W_w_c
% 33 W_f_c
% 34 LD_c
% 35 CST_L_1_c
% 36 CST_L_2_c
% 37 CST_L_3_c
% 38 CST_L_4_c
% 39 CST_L_5_c
% 40 N2_L_c
% 41 SF_L_c
% 42 CST_M_1_c
% 43 CST_M_2_c
% 44 CST_M_3_c
% 45 CST_M_4_c
% 46 CST_M_5_c
% 47 N2_M_c
% 48 SF_M_c




% Set up optimiser

% Define bounds
global lb_0;
global ub_0;
lb_0 = [20,   Const.Wing.y_k*2, 0,  0,  0.2, -5, -5, 0.85*x0(8:31), 1000,     1000,   5,  0.85*x0(35:39), 0, 0,        1.15*x0(42:46), 0, 0 ]; 
ub_0 = [x0(1)*2, 36,               deg2rad(45), deg2rad(45), 1,   5,  5,  1.15*x0(8:31), 2*x0(32), x0(33), 30, 1.15*x0(35:39), 1, 3*x0(41), 0.85*x0(42:46), 1, 3*x0(47)]; 
    
% Normalise initial vector
x0n = (x0-lb_0)./(ub_0-lb_0);

% Reverse normalisation: x_0 = (ub_0-lb_0).*x_0n+lb_0

% Make normalised bounds
lb = zeros(1,48);
ub = ones(1,48);


% fmincon

% Options for the optimization
options.Display         = 'iter-detailed';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 1e-6;         % Minimum change while gradient searching
options.DiffMaxChange   = 5e-2;         % Maximum change while gradient searching
options.TolCon          = 1e-6;         % Maximum difference between two subsequent constraint vectors [c and ceq]
options.TolFun          = 1e-6;         % Maximum difference between two subsequent objective value
options.TolX            = 1e-6;         % Maximum difference between two subsequent design vectors

tic;
[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@Obj,x0n,[],[],[],[],lb,ub,@(x) constraints(x),options);
toc;