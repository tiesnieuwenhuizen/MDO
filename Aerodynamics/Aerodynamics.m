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


%%%%%%%%%%%
% check that MAC holds
% check that x vector in wingplanform works
% check how to find CL
%%%%%%%%%%%

function [out]=Aerodynamics(x_n)
%% Aerodynamic solver setting
x = ub_0.*x_n+lb_0

wing=wingplanform;
b_i=Const.Wing.y_k;
b=x(2)/2;
Lambda_i=x(3);
lambda_o=x(4);

x1=b_i*tan(Lambda_i);
x2=b_i*tan(Lambda_i)+b*tan(Lambda_o);

lambda_tot=wing(6)/wing(4);
MAC = 2/3*wing(4)*((1+lambda_tot+lambda_tot^2)/(1+lambda_tot))
%W_tot=

% Wing planform geometry 
%                x    y     z     chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     wing(4)         0;
                x1    b_i   0     wing(5)         x(6);
                x2    b     0     wing(6)         x(7)];

% Wing incidence angle (degree)
AC.Wing.inc  = Const.Wing.incidence;   
            
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [x(8)  x(9)  x(10) x(11) x(12) x(13) x(14) x(15) x(16) x(17) x(18) x(19);
                      x(20) x(21) x(22) x(23) x(24) x(25) x(26) x(27) x(28) x(29) x(30) x(31);
                      ];
                  
AC.Wing.eta = [0;b_i/b;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  =1;              % 0 for inviscid and 1 for viscous analysis

% Flight Condition
AC.Aero.V     = Const.Cruise.V;            % flight speed (m/s)
AC.Aero.rho   = Const.Cruise.rho;         % air density  (kg/m3)
AC.Aero.alt   = Const.cruise.h;             % flight altitude (m)
AC.Aero.Re    = (Const.Cruise.rho*Const.Cruise.V*MAC)/Const.Cruise.mu;        % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = Const.cruise.M;           % flight Mach number 
AC.Aero.CL    = W_tot/(0.5*Const.Wing.rho*Const.Wing.^2*x(1));          % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 


%% 
Res = Q3D_solver(AC);

out=(Res.CLwing/Res.CDwing);

end





     