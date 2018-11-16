function [CST] = AirfoilOpt(n_CST)
%AIRFOILOPT This function finds CST coefficients for the Whitcomb airfoil
%   This output has to be scaled to obtain proper t/c for the root and tip
%   airfoils

x0 = 0.5*ones(n_CST,1); % Initial value of CST coefficients
lb = -1*ones(n_CST,1); % Lower bounds
ub = ones(n_CST,1); % Upper bounds

options=optimset('Display','none');
% Optimiser

CST = fmincon(@AirfoilObj,x0,[],[],[],[],lb,ub,[],options);

CST_u = CST(1:length(CST)/2);
CST_l = CST(length(CST)/2+1:length(CST));

CST = [CST_u' CST_l'];