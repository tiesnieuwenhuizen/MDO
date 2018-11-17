function [W_f] = Obj(x)
    % OBJ The objective function for the optimisation
    %   It calls the Performance function and normalises the fuel weight
    global lb_0;
    global ub_0;
    W_f = (Performance(x)-lb_0(31))/ub_0(31);
end

