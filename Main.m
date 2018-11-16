%{
This is the main executable file for the optimisation
Use this file to edit process flow
%}

% Create constant value object
ConstCreator

% Create Initial Design Vector

% Vector
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
% 40 SF_L_c
% 41 N2_L_c
% 42 CST_M_1_c
% 43 CST_M_2_c
% 44 CST_M_3_c
% 45 CST_M_4_c
% 46 CST_M_5_c
% 47 SF_M_c
% 48 N2_M_c



% Set up optimiser

% Define bounds
lb_0 = [S_i_min, Const.Wing.y_k*2, 0, 0, 0.85*CST, -5, 0, 0, -10, -10, -10, -10, -10, 0, 0, 0]; % To be updated: CST, S_i_min, y_kink
ub_0 = [2*S_0, 36, 45, 1, 1.15*CST, 5, 1.5*MTOW_0, W_f_0, 10, 10, 10, 10, 10, 3*SF_0, 1, 30]; % To be updated: S_0, CST, MTOW_0, W_f_0 CST, SF_0
global lb_0;
global ub_0;
    
% Normalise bounds
x_0n = (x_0-lb_0)./ub_0;

%reverse x_0 = ub_0.*x_0n+lb_0

lb = zeros(48,1);
ub = ones(48,1);


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
[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x) Obj(x),x0,[],[],[],[],lb,ub,@(x) constraints(x),options);
toc;