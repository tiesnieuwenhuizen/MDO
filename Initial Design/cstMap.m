function [Y] = cstMap(CST,X)
%CSTMAP This function maps the CST-curves for the airfoil onto the
%x-locations in the reference airfoil .dat file

% Shape factors
N1 = 0.5;
N2 = 1;

% Number of CST coefficients
num = length(CST)-1;

C = zeros(length(X),1);
S = zeros(length(X),1);
for i = 1:length(X)
    % Class function
    C(i) = (X(i)^N1)*(1-X(i))^N2;
    
    % Shape function
    for j = 0:num
        fnum = factorial(num)/(factorial(j)*factorial(num-j));
        S(i) = S(i) + CST(j+1) * fnum * X(i)^j * (1-X(i))^(num-j);
    end
end

Y = C.*S;
end
