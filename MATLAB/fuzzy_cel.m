function wsk = fuzzy_cel( p )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global fuzz1

   L = 0.05;
R = 10;
Ke = 10;
J = 1/3*2*0.4^2;
Umax1 = 0.5;
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
I1 = 0.2;
N1 = 1e3;
% P1 = 7;
% D1 = 5;
% I1 = 0.2;
% N1 = 1000;

P2 = 3;
D2 = 1;
I2 = 0.002;
N2 = 1e3;

kp1 = P1;
kd1 = D1;
ki1 = I1;

kp2 = P2;
kd2 = D2;
ki2 = I2;

b = 0;

z_min = -1;
z_max = 1;
U_g1 = 0.5;
U_g2 = 1;
sat_wsp1 = -2.65;
sat_wsp2 = -5.33;
b_nc = [0 0 0]';
% -z_min/(z_max - z_min)
W = [kd1 kp1 ki1 0;
    kd2 kp2 ki2 0;
    0 0 0 1];

%par de
    fuzz1.input(1).mf(1).params = [p(1) p(2) p(3)];
    fuzz1.input(1).mf(2).params = [p(4) p(5) p(6)];
    fuzz1.input(1).mf(3).params = [p(7) p(8) p(9)];
    
%par e
    fuzz1.input(2).mf(1).params = [p(10) p(11) p(12)];
    fuzz1.input(2).mf(2).params = [p(13) p(14)];
    fuzz1.input(2).mf(3).params = [p(15) p(16) p(17)];
    
% par u
    fuzz1.output.mf(1).params = [p(18) p(19) p(20) p(21)];
    fuzz1.output.mf(2).params = [p(22) p(23)];
    fuzz1.output.mf(3).params = [p(24) p(25) p(26) p(27)];
    fuzz1.output.mf(4).params = [p(28) p(29) p(30)];
    fuzz1.output.mf(5).params = [p(31) p(32) p(33)];

    
   opt = simset('SrcWorkspace','Current');
   sim('model_2015a.slx',5, opt);
   wsk = J3;
end
