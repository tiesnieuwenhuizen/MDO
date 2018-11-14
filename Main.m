%{
This is the main executable file for the optimisation
Use this file to edit process flow
%}

% Create constant value object
ConstCreator

% Create Initial Design Vector
InitialVector

% Set up optimiser

% Define bounds
lb = [S_i_min, y_kink, 0, 0, 0.85*CST, -5, 0, 0, -10, -10, -10, -10, -10, 0, 0, 0]; % To be updated: CST, S_i_min, y_kink
ub = [2*S_0, 36, 45, 1, 1.15*CST, 5, 1.5*MTOW_0, W_f_0, 10, 10, 10, 10, 10, 3*SF_0, 1, 30]; % To be updated: S_0, CST, MTOW_0, W_f_0 CST, SF_0
    
% Normalise bounds
lb = lb./x0;
ub = ub./x0;

% fmincon