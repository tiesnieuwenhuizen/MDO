function [W_f] = Performance(xn)
%PERFORMANCE This function is basically the Breguet equation
%   Input is the design vector, output is the fuel weight
global ub_0;
global lb_0;

% De-normalise vector
x = ub_0.*xn + lb_0;


W_f = (1-0.938*exp((Const.AC.Range*Const.Engines.C_T)/(Const.Cruise.V*x(39)))*x(30);

end

