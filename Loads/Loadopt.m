function [CST] = Loadopt(n_CST,array)
%AIRFOILOPT This function finds CST coefficients for the Whitcomb airfoil
%   This output has to be scaled to obtain proper t/c for the root and tip
%   airfoils

x0 = [[0.5*ones(n_CST,1)];[0.5]]; % Initial value of CST coefficients
lb = [-1*ones(n_CST,1); [0]]; % Lower bounds
ub = [ones(n_CST,1); [1]]; % Upper bounds



options=optimset('Display','none');
% Optimiser



   function [err] = LoadObj(CST)
    %AIRFOILOBJ This is the objective function for the initial airfoil curve
    %fitting


     % Split into x and y
     yloc = [array(:,1)];
     yloc = yloc./yloc(end);
     
     value = [array(:,2)];
     
     


     % Map CST curves to x-locations in .dat file
     value_cst = cstMapLoads(CST, yloc);
     

     % Errors for upper and lower
     err = value - value_cst;
     


     % Total error
     err = sum(err.^2);
   end

CST = fmincon(@LoadObj,x0,[],[],[],[],lb,ub,[],options);
  
end
%CST = ;