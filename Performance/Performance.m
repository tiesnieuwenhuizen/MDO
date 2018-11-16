function [W_f] = Performance(x)
%PERFORMANCE This function is basically the Breguet equation
%   Input is the design vector, output is the fuel weight
MTOW=x(32)+x(33)+Const.AWGroup.weight

W_f = (1-0.938*exp((Const.AC.Range*Const.Engines.C_T)/(Const.Cruise.V*x(34)))*MTOW;

end

