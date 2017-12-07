close all
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

alpha_0 = -1;
sim('Model_opt_Matlab_2015a', 10);

time = ScopeData1.time;
zadana = ScopeData1.signals(1).values(:,5);
alpha = ScopeData1.signals(1).values(:,2);
e = zadana - alpha;

sterowanie = ScopeData1.signals(2).values(:,1)';

alpha_0 = 1;
sim('Model_opt_Matlab_2015a', 10);
time = ScopeData1.time;
zadanaS = ScopeData1.signals(1).values(:,5);
alphaS = ScopeData1.signals(1).values(:,2);
eS = zadanaS - alphaS;

sterowanieS = ScopeData1.signals(2).values(:,1)';

%%
index = 1;
perfs = zeros(1,10);
nets = cell(1,10);


% input = [e(3:end), e(2:end-1), e(1:end-2)]';
% input = [e(3:end), e(2:end-1), e(1:end-2) sterowanie(2:end-1)']';
input = [e(3:end), e(2:end-1), e(1:end-2), zadana(3:end), sterowanie(2:end-1)']';
% sterowanie=sterowanie(3:end);
sterowanie=sterowanie(3:end);

% inputS = [eS(3:end), eS(2:end-1), eS(1:end-2)]';
% inputS = [eS(3:end), eS(2:end-1), eS(1:end-2), sterowanieS(2:end-1)']';
inputS = [eS(3:end), eS(2:end-1), eS(1:end-2),zadanaS(3:end), sterowanieS(2:end-1)']';
sterowanieS=sterowanieS(3:end);

for i =1:10

    net = feedforwardnet(2);
    net = configure(net, input, sterowanie);
    [net, tr] = train(net, input, sterowanie);
    nets{i}=net;
    perfs(i)= tr.best_tperf;
end

%%
[best_perf, ind] = min(perfs);
best_net = nets{ind};
y_train = best_net(input);
y_inv = best_net(inputS);

%%
close all

uchyb = sterowanie - y_train;
figure(1)
subplot(211)
plot(time(1:end-2), sterowanie', time(1:end-2), y_train)
legend('referencyjny','wyjscie sieci')
xlabel('czas [s]')
grid on;
hold on;
subplot(212)
plot(time(1:end-2), uchyb)
xlabel('czas [s]')
ylabel('\Delta U[v]')
grid on;

%%
uchyb = sterowanieS - y_inv;
figure(2)
subplot(211)
plot(time(1:end-2), sterowanieS', time(1:end-2), y_inv)
legend('referencyjny','wyjscie sieci')
xlabel('czas [s]')
grid on;
hold on;
subplot(212)
plot(time(1:end-2), uchyb)
xlabel('czas [s]')
ylabel('\Delta U[v]')
grid on;
