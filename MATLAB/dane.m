L = 0.05;
R = 10;
Ke = 10;
J = 1/3*2*0.4^2;
Umax1 = 0.4;
Umin1 = -Umax1;

Umax2 = 1;
Umin2 = -Umax2;
% P1 = 30;
% D1 = 10;
% I1 = 0.02;
% 
% P2 = 30;
% D2 = 10;
% I2 = 0.02;

P1 = 3;
D1 = 1.5;
I1 = 0.002;
N1 = 1000;

P2 = 3;
D2 = 1;
I2 = 0.002;
N2 = 1000;

sim('model_2015a',20)
