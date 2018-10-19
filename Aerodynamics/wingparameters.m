function wing=wingparameters(x)
Lambda_TE=0;  %%%%%%%%%%%%%%%%still hardcoded parameters-->change when used
Lambda_LE=0;
b_i=5;
lambda_o=1;
b=20;
S=20;
wing(1)=b_i*(x(4)+x(5))/2-x(1);
wing(2)=x(4)-b_i*(tan(Lambda_LE)+tan(Lambda_TE))-x(5);
wing(3)=x(6)-lambda_o*x(5);
wing(4)=(x(5)+x(6))/2*x(3)-x(2);
wing(5)=b_i+x(3)-b/2;
wing(6)=x(1)+x(2)-S/2;
end