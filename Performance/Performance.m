function [out] = Performance(xn,lb_0,ub_0,Const)
%PERFORMANCE This function is basically the Breguet equation
%   Input is the design vector, output is the fuel weight
% global ub_0;
% global lb_0;
% global Const;

% ub_0 = u.value;
% lb_0 = l.value;
% Const = C.value;

% De-normalise vector
% test = xn
% test2 = ub_0
x = (ub_0-lb_0).*xn + lb_0;

MTOW=x(32)+x(33)+Const.AWGroup.weight;

W_f = (1-0.938*exp((-Const.AC.Range*Const.Engines.C_T)/(Const.Cruise.V*x(34))))*MTOW

out=(W_f-lb_0(33))/(ub_0(33)-lb_0(33));

end

