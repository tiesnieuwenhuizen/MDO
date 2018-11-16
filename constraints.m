function [c,ceq] = constraints(x)
%CONSTRAINTS This function executes all of the blocks and compares their
%outcomes to the "copy" variables in the design vector to obtain
%constraints
%   Inputs: Design vector (non-normalised!!!)
%   Output: Constraint errors

global Const

% Run performance block
W_f = Performance(x);

% Run Structures block
cd Structures
W_w = Structures(x);
cd ../

% Run Loads block
cd Loads
[CST_L_1, CST_L_2, CST_L_3, CST_L_4, CST_L_5, N2_L, SF_L] = Loads(x);
cd ../

% Run Aerodynamics block
cd Aerodynamics
LD = Aerodynamics(x);
cd ../

%Consistency Constraints
W_f_c       = x(33);
W_w_c       = x(32);
CST_L_1_c   = x(35);
CST_L_2_c   = x(36);
CST_L_3_c   = x(37);
CST_L_4_c   = x(38);
CST_L_5_c   = x(39);
SF_L_c      = x(40);
N2_L_c      = x(41);
LD_c        = x(34);

cc1     = abs(W_f-W_f_c);
cc2     = abs(W_w-W_w_c);
cc3     = abs(CST_L_1-CST_L_1_c);
cc4     = abs(CST_L_2-CST_L_2_c);
cc5     = abs(CST_L_3-CST_L_3_c);
cc6     = abs(CST_L_4-CST_L_4_c);
cc7     = abs(CST_L_5-CST_L_5_c);
cc8     = abs(SF_L-SF_L_c);
cc9     = abs(N2_L-N2_L_c);
cc10    = abs(LD-LD_c);



% Inequality Constraints
MTOW   = W_f+W_w+Const.AC.W_aw;
S      = x(1);
b      = x(2);

% Extract CST coefficients for numerical integration
CST_iu = x(8:13);
CST_il = x(14:19);
CST_ou = x(20:25);
CST_ol = x(26:31);

% Interpolate for kink aifoil
CST_ku = (Const.Wing.y_k.*CST_iu + (x(2)/2-Const.Wing.y_k)*CST_ou)/(x(2)/2);
CST_kl = (Const.Wing.y_k.*CST_il + (x(2)/2-Const.Wing.y_k)*CST_ol)/(x(2)/2);

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
wing = wingplanform(x);
S_1 = S_1*wing(4)^2;
S_2 = S_2*wing(5)^2;
S_3 = S_3*wing(6)^2;

% Compute volume
V_tank = Const.Wing.y_k/3*(S_1+S_2+sqrt(S_1*S_2))+(b-Const.Wing.y_k)/3*(S_2+S_3+sqrt(S_2*S_3));



c1 = Const.AC.WS_max-MTOW/S;
c2 = V_tank*Const.Fuel.f - W_f/Const.Fuel.rho;

%Combination
c = [c1,c2];
ceq = [cc1,cc2,cc3,cc4,cc5,cc6,cc7,cc8,cc9,cc10];
end