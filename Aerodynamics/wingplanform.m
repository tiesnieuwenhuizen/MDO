function [wingplan]=wingplanform(x,Const)

wingcomputer=wingparameters(k,x,Const);
k0=[0,0,0,0,0,0];

wingplan=fsolve(wingcomputer,k0);

S_inner=wingplan(1);
S_outer=wingplan(2);
b_outer=wingplan(3);
Cr=wingplan(4);
Ci=wingplan(5);
Ct=wingplan(6);
end 