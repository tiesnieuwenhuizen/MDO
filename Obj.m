function [W_f] = Obj(x)
    % OBJ The objective function for the optimisation
    %   It calls the Performance function 
   
    W_f = Performance(x);
end

