function [W_f] = Performance(x)
%PERFORMANCE This function is basically the Breguet equation
%   Input is the design vector, output is the fuel weight

W_f = (1-0.938*exp((Const.AC.Range*Const.Engines.C_T)/(Const.Cruise.V*x(39)))*x(30);

end

