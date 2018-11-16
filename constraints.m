function [c,ceq] = constraints(x)
%CONSTRAINTS This function executes all of the blocks and compares their
%outcomes to the "copy" variables in the design vector to obtain
%constraints
%   Inputs: Design vector (non-normalised!!!)
%   Output: Constraint errors

% Run performance block
W_f = Performance(x);

% Run Structures block
cd Structures
W_w = Structures(x);
cd ../

% Run Loads block
cd Loads
[CST_L_1, CST_L_2, CST_L_3, CST_L_4, CST_L_5, SF_L, N2_L] = Loads(x);
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


    function [y1] = f1(x1)
        
    end

S_1 =
S_2 =
S_3 =

V_tank = Const.Wing.y_k/3*(S_1+S_2+sqrt(S_1*S_2))+(b-Const.Wing.y_k)/3*(S_2+S_3+sqrt(S_2*S_3));



c1 = Const.AC.WS_max-MTOW/S;
c2 = V_tank*Const.Fuel.f - W_f/Const.Fuel.rho;

%Combination
c = [c1,c2];
ceq = [cc1,cc2,cc3,cc4,cc5,cc6,cc7,cc8,cc9,cc10];
end