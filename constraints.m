function [c,ceq] = constraints(x)
%CONSTRAINTS This function executes all of the blocks and compares their
%outcomes to the "copy" variables in the design vector to obtain
%constraints
%   Inputs: Design vector (non-normalised!!!)
%   Output: Constraint errors

global Const
global lb_0
global ub_0

% Run performance block
W_f = Performance(x);

% Run Structures block
cd Structures
W_w = Structures(x);
cd ../

% Run Loads block
cd Loads
loadcoefficients = Loads(x)
cd ../

% Run Aerodynamics block
cd Aerodynamics
LD = Aerodynamics(x);
cd ../

%Consistency Constraints


W_f_c       = x(33);
LD_c        = x(34);
CST_L_1_c   = x(35);
CST_L_2_c   = x(36);
CST_L_3_c   = x(37);
CST_L_4_c   = x(38);
CST_L_5_c   = x(39);
SF_L_c      = x(40);
N2_L_c      = x(41);

CST_M_1_c   = x(42);
CST_M_2_c   = x(43);
CST_M_3_c   = x(44);
CST_M_4_c   = x(45);
CST_M_5_c   = x(46);
N2_M_c      = x(47);
SF_M_c      = x(48);

W_w_c       = x(32);

cc1     = abs(W_f-W_f_c);
cc2     = abs(W_w-W_w_c);
cc3    = abs(LD-LD_c);
cc4     = abs(loadcoefficients(1)-CST_L_1_c);
cc5     = abs(loadcoefficients(2)-CST_L_2_c);
cc6     = abs(loadcoefficients(3)-CST_L_3_c);
cc7     = abs(loadcoefficients(4)-CST_L_4_c);
cc8     = abs(loadcoefficients(5)-CST_L_5_c);
cc9     = abs(loadcoefficients(6)-N2_L_c);
cc10     = abs(loadcoefficients(7)-SF_L_c);


cc11    = abs(loadcoefficients(8)-CST_M_1_c);
cc12    = abs(loadcoefficients(9)-CST_M_2_c);
cc13    = abs(loadcoefficients(10)-CST_M_3_c);
cc14    = abs(loadcoefficients(11)-CST_M_4_c);
cc15    = abs(loadcoefficients(12)-CST_M_5_c);
cc16    = abs(loadcoefficients(13)-N2_M_c);
cc17    = abs(loadcoefficients(14)-SF_M_c);



x2=x.*(ub_0-lb_0)+lb_0;


% Inequality Constraints
MTOW   = W_f+W_w+Const.AWGroup.weight;
S      = x2(1);
b      = x2(2);

% Extract CST coefficients for numerical integration
CST_iu = x2(8:13);
CST_il = x2(14:19);
CST_ou = x2(20:25);
CST_ol = x2(26:31);

% Interpolate for tank root airfoil
CST_iu = (Const.Fuel.tank_start.*CST_iu + (x2(2)/2-Const.Fuel.tank_start)*CST_ou)/(x2(2)/2);
CST_il = (Const.Fuel.tank_start.*CST_il + (x2(2)/2-Const.Fuel.tank_start)*CST_ol)/(x2(2)/2);

% Interpolate for kink aifoil
CST_ku = (Const.Wing.y_k.*CST_iu + (x2(2)/2-Const.Wing.y_k)*CST_ou)/(x2(2)/2);
CST_kl = (Const.Wing.y_k.*CST_il + (x2(2)/2-Const.Wing.y_k)*CST_ol)/(x2(2)/2);

% Interpolate for tank tip aifoil
CST_ou = (Const.Fuel.tank_end.*CST_iu + (x2(2)/2-Const.Fuel.tank_end)*CST_ou)/(x2(2)/2);
CST_ol = (Const.Fuel.tank_end.*CST_il + (x2(2)/2-Const.Fuel.tank_end)*CST_ol)/(x2(2)/2);

% Define CST-curves to integrate
    function [y1] = CSTi(n1)
        C = n1^0.5*(1-n1)^1;
        for j = 0:5
            fnum = factorial(5)/(factorial(j)*factorial(5-j));
            Se = Se + CST_iu(j+1) * fnum * n1^j * (1-n1)^(5-j);
        end
        for k = 0:5
            fnum = factorial(5)/(factorial(k)*factorial(5-k));
            Se = Se + CST_il(k+1) * fnum * n1^k * (1-n1)^(5-k);
        end
        y1 = C*Se1 - C*Se2;
    end

    function [y1] = CSTk(n1)
        C = n1^0.5*(1-n1)^1;
        for j = 0:5
            fnum = factorial(5)/(factorial(j)*factorial(5-j));
            Se = Se + CST_ku(j+1) * fnum * n1^j * (1-n1)^(5-j);
        end
        for k = 0:5
            fnum = factorial(5)/(factorial(k)*factorial(5-k));
            Se = Se + CST_kl(k+1) * fnum * n1^k * (1-n1)^(5-k);
        end
        y1 = C*Se1 - C*Se2;
    end

    function [y2] = CSTo(n1)
        C = n1^0.5*(1-n1)^1;
        for j = 0:5
            fnum = factorial(5)/(factorial(j)*factorial(5-j));
            Se = Se + CST_ou(j+1) * fnum * n1^j * (1-n1)^(5-j);
        end
        for k = 0:5
            fnum = factorial(5)/(factorial(k)*factorial(5-k));
            Se = Se + CST_ol(k+1) * fnum * n1^k * (1-n1)^(5-k);
        end
        y2 = C*Se1 - C*Se2;
    end

% Integrate
S_1 = integral(@CSTi, Const.Structure.loc_fspar, Const.Structure.loc_rspar);
S_2 = integral(@CSTk, Const.Structure.loc_fspar, Const.Structure.loc_rspar);
S_3 = integral(@CSTo, Const.Structure.loc_fspar, Const.Structure.loc_rspar);

% Scale to actual size
wing = wingplanform(x2);
C_begin=wing(4)-((wing(4)-wing(5))*0.1*(x2(2)/2))/Const.Wing.y_k;
C_kink=wing(5);
C_end=wing(5)-((wing(5)-wing(6))*(0.7*b/2-Const.Wing.y_k)/wing(3));
S_1 = S_1*C_begin^2;
S_2 = S_2*C_kink^2;
S_3 = S_3*C_end^2;

% Compute volume
V_tank = (Const.Wing.y_k-0.1*b/2)/3*(S_1+S_2+sqrt(S_1*S_2))+(0.7*b/2-Const.Wing.y_k)/3*(S_2+S_3+sqrt(S_2*S_3));



c1 = Const.AC.WS_max-MTOW/S;
c2 = V_tank*Const.Fuel.f - W_f/Const.Fuel.rho;

%Combination
c = [c1,c2];
ceq = [cc1,cc2,cc3,cc4,cc5,cc6,cc7,cc8,cc9,cc10,cc11,cc12,cc13,cc14,cc15,cc16,cc17];
end