function [err] = AirfoilObj(x)
%AIRFOILOBJ This is the objective function for the initial airfoil curve
%fitting
%   Detailed explanation goes here

% Split x into upper and lower CST coefficients
 CST_u = x(1:length(x)/2);
 CST_l = x(length(x)/2+1:length(x));
 
 % Read coordinate file
 fid = fopen('whitcomb-il.txt','r');
 coord = fscanf(fid,'%g %g',[2 Inf]); 
 fclose(fid);
 
 % Transpose
 coord = coord';
 
 % Find upper-lower transition, where y=0
 len = length(coord); 
 for i=1:len
     if coord (i,2) == 0
         k = i ;
         break;
     end
 end
 % Get the (x,y) coordinates of upper and lower parts of the airfoil:
 coord_u = coord(1:k,:) ;
 coord_l = coord((k+1):len,:) ; 
 
 % Split into x and y
 xu = coord_u(:,1);
 xl = coord_l(:,1);
 yu = coord_u(:,2);
 yl = coord_l(:,2);
 
 
 % Map CST curves to x-locations in .dat file
 yu_cst = cstMap(CST_u, xu);
 yl_cst = cstMap(CST_l, xl);
 
 % Errors for upper and lower
 err_u = yu - yu_cst;
 err_l = yl - yl_cst;
 
 % Total error
 err = sum(err_u.^2) + sum(err_l.^2);

