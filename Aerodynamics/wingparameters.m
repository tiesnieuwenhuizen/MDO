function wing=wingparameters(k)
Lambda_TE=0;  %%%%%%%%%%%%%%%%still hardcoded parameters-->change when used
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