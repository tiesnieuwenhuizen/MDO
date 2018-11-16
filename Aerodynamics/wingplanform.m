function [wingplan]=wingplanform(x)

% global Const;

    function wing=wingparameters2(k)

        global Const;

        Lambda_TE=0;  
        Lambda_LE=x(3);
        b_i=Const.Wing.y_k;
        lambda_o=x(5);
        b=x(2);
        S=x(1);
        wing(1)=b_i*(k(4)+k(5))/2-k(1);
        wing(2)=k(4)-b_i*(tan(Lambda_LE)+tan(Lambda_TE))-k(5);
        wing(3)=k(6)-lambda_o*k(5);
        wing(4)=(k(5)+k(6))/2*k(3)-k(2);
        wing(5)=b_i+k(3)-b/2;
        wing(6)=k(1)+k(2)-S/2;
    end

% wingcomputer=wingparameters(k,x);
k0=[0,0,0,0,0,0];

wingplan=fsolve(@wingparameters2,k0);

S_inner=wingplan(1);
S_outer=wingplan(2);
b_outer=wingplan(3);
Cr=wingplan(4);
Ci=wingplan(5);
Ct=wingplan(6);
end 