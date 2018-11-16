function [Y] = cstMapLoads(CST,X)
%CSTMAP This function maps the CST-curves for the airfoil onto the
%x-locations in the reference airfoil .dat file

% Shape factors
N1 = 0;
N2=CST(end);

% Number of CST coefficients
num = length(CST)-2;

C = zeros(length(X),1);
S = zeros(length(X),1);
for i = 1:length(X)
    % Class function
    C(i) = (X(i)^N1)*(1-X(i))^N2;
    
    % Shape function
    for k = 0:num
        fnum = factorial(num)/(factorial(k)*factorial(num-k));
        S(i) = S(i) + CST(k+1) * fnum * X(i)^k * (1-X(i))^(num-k);
    end
end

Y = C.*S;
end
