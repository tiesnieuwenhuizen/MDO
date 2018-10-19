%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Quasi-3D aerodynamic solver      
%
%       A. Elham, J. Mariens
%        
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% OUTPUT DESCRIPTION:

% Res.Alpha   = Wing angle of attack
% Res.CLwing  = Total wing lift coefficient
% Res.CDwing  = Total wing drag coefficient
% Res.Wing.aero.Flight_cond = flight conditions including angle of attack
%                             (alpha), sideslip angle (beta), Mach number (M), airspeed (V) and air
%                              density (rho)
% Res.Wing   = Spanwise distribution of aerodynamic and geometrical
%              properties of wing 
%              For example plot(Res.Wing,Yst,Res.Wing.cl) plots spanwise
%              distribution of cl
% Res.Section   = aerodynamic coefficients of 2D sections 


%%

%clear all
%close all
%clc

function [out]=Aerodynamics(input)
%% Aerodynamic solver setting
wing=wingplanform;
b_i=5;
b=20;
Lambda_LE=0.3;
% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     wing(4)         0;
                b_i*tan(Lambda_LE)     b_i   0     wing(5)         0;
                b/2*tan(Lambda_LE)     b/2   0     wing(6)         0];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
                      0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
                      0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797];
                  
AC.Wing.eta = [0;b_i/b/2;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  =1;              % 0 for inviscid and 1 for viscous analysis

% Flight Condition
AC.Aero.V     = 68;            % flight speed (m/s)
AC.Aero.rho   = 1.225;         % air density  (kg/m3)
AC.Aero.alt   = 0;             % flight altitude (m)
AC.Aero.Re    = 1.14e7;        % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = 0.2;           % flight Mach number 
AC.Aero.CL    = input;          % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 


%% 

Res = Q3D_solver(AC);

out=(Res.CLwing/Res.CDwing);

end





     