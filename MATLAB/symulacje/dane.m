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

sim('model_2015a',5)

sprintf(['Wska¿niki jakoœci:\n'...
    'Regulator      J1      J2      J3\n'...
    'PID %14.3f %7.3f %7.3f\n'...
    'Neuron %11.3f %7.3f %7.3f'],J1,J2,J3,J1_n,J2_n,J3_n)

%%
%porównaie sterowania 2 neurony - 1 neuron
figure(12)
subplot(211)
plot(por_ster_n.time, por_ster_n.signals.values(:,1),'b')
hold on
grid on 
plot(por_ster_n.time, por_ster_n.signals.values(:,2),'r')
xlabel('czas [s]')
ylabel('sterownaie [V]')
legend('saturacja','f. sigmoidalna')
subplot(212)
plot(por_ster_n.time, (por_ster_n.signals.values(:,1) - por_ster_n.signals.values(:,2)).^2)
xlabel('czas [s]')
ylabel('\Delta u^2 [V^2]')
grid on

%%
%porównanie saturacji i funkcji sigmoidalnej
limit = .5;
%    ref1 = ones(1,40); 
ref1 = ones(1,25); 
y_ref = [ref1.*-limit,-1*limit:0.1:1*limit,ref1*limit];
t = -3:0.1:3;
y = 2*limit./(1+exp(sat_wsp1.*t))-limit;
figure(323)
plot(t,y_ref, 'r')
hold on
grid on
plot(t,y, 'b')
xlabel('x')
ylabel('y')
legend('saturacja','f. sigmoidalna')
