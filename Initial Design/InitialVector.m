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

% Airfoil CST curve calculations
n_CST = 12; % Number of CST coefficients per side
CST_0 = AirfoilOpt(n_CST); % 2*n_CST because both sides will be determined


% % Plot foils as check
% 
%  CST_u = CST_0(1:length(CST_0)/2);
%  CST_l = CST_0(length(CST_0)/2+1:length(CST_0));
%  
%  % Read coordinate file
%  fid = fopen('withcomb135.dat','r');
%  coord = fscanf(fid,'%g %g',[2 Inf]); 
%  fclose(fid);
%  
%  % Transpose
%  coord = coord';
%  
%  % Find upper-lower transition, where y=0
%  len = length(coord); 
%  for i=1:len
%      if coord (i,2) == 0
%          k = i ;
%          break;
%      end
%  end
%  % Get the (x,y) coordinates of upper and lower parts of the airfoil:
%  coord_u = coord(1:k,:) ;
%  coord_l = coord((k+1):len,:) ; 
%  
%  % Split into x and y
%  xu = coord_u(:,1);
%  xl = coord_l(:,1);
%  yu = coord_u(:,2);
%  yl = coord_l(:,2);
%  
%  % Map CST curves to x-locations in .dat file
%  yu_cst = cstMap(CST_u, xu);
%  yl_cst = cstMap(CST_l, xl);
%  
%  hold on
%  plot(xu, yu, 'b');
%  plot(xl, yl, 'b');
%  plot(xu, yu_cst, 'r');
%  plot(xl, yl_cst, 'r');
%  axis equal
%  
% % End plot

% Loading calculation

% Fuselage drag
