%% Optimalizacja nastaw sieci neuronowej

global L R Ke J z_min z_max U_g1 U_g2 b_nc T alpha_0;
L = 0.05;
R = 10;
Ke = 10;
J = 1/3*2*0.4^2;
Umax1 = 0.5;
Umin1 = -Umax1;

Umax2 = 1;
Umin2 = -Umax2;

P1 = 3;
D1 = 1.5;
I1 = 0.3;
N1 = 1e3;

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

z_min = -1;
z_max = 1;
U_g1 = 0.5;
U_g2 = 1;
sat_wsp1 = -2.65;
sat_wsp2 = -5.33;
b_nc = [0 0 0]';
W = [kd1 kp1 ki1 0;
    kd2 kp2 ki2 0;
    0 0 0 1];


A = -eye(8);
A(7,7) = 1;
A(8,8) = 1;
B = zeros(8,1);
%% Optymalizacja pe³na szklanka
alpha_0 = 0;
T = 3;
options = optimoptions(@lsqnonlin,'Display','iter');
% options = optimoptions('fmincon', 'Display','iter');
par0=[kp1;kd1;ki1;kp2;kd2;ki2;sat_wsp1;sat_wsp2];
% [par_full,fval]=fmincon(@neuron_cel, par0, A, B, [], [], [], [], '', options);
[par_full,fval]=fminunc(@neuron_cel, par0, options);


%%
% Optymalizacja pusta szklanka
alpha_0 = 1;
T = 2;
options = optimoptions(@lsqnonlin,'Display','iter');
par0=[kp1;kd1;ki1;kp2;kd2;ki2;sat_wsp1;sat_wsp2];
[par_empty,fval]=fminunc(@neuron_cel, par0, options);

par_full
par_empty

%% Test
alpha_0 = 0;

kp1=par_full(1);
kd1=par_full(2);
ki1=par_full(3);
kp2=par_empty(4);
kd2=par_empty(5);
ki2=par_empty(6);
sat_wsp1=par_full(7);
sat_wsp2=par_empty(8);
W = [kd1 kp1 ki1 0;
    kd2 kp2 ki2 0;
    0 0 0 1];
sim('Model_opt', 5)
