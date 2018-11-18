function [W_f] = Obj(x,lb_0,ub_0,Const)
    % OBJ The objective function for the optimisation
    %   It calls the Performance function 
   
    W_f = Performance(x,lb_0,ub_0,Const);
end

