function [W_f] = Obj(x)
    % OBJ The objective function for the optimisation
    %   It calls the Performance function and normalises the fuel weight
    W_f = Performance(x)/x0(31);
end

