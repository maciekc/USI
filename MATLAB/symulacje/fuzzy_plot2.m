close all

%dane regulatora fuzzy_zestaw2.mat
figure(1)
subplot(211)
plot(ScopeData.time, ScopeData.signals(1).values())
grid on 
axis([0 5 -10 10])
xlabel('czas [s]')
legend('pr¹d [A]', 'k¹t [rad]','\omega [rad/s]','\xi [rad^2/s1]', 'wart. zad.')
subplot(212)
plot(ScopeData.time, ScopeData.signals(2).values())
grid on
xlabel('czas [s]')
ylabel('sterowanie [V]')

%%
% e 
x = -2:0.1:2;
yn = zmf(x, [-2 -0.2]);
yz = gaussmf(x, [0.7432 -4.163e-17]);
yp = smf(x,[0.2 2]);
figure(2)
plot(x,yn)
hold on 
plot(x,yz)
plot(x,yp)
grid on
xlabel('uchyb [rad]')
legend('neg.','zero','pos.')
ylim([-0.05 1.05])
%%
% de
x = -20:0.1:20;
yn = gauss2mf(x, [1.699 -20.5 0.6455 -1.81]);
yz = gaussmf(x,  [0.4247 0]);
yp = gauss2mf(x,  [0.6455 1.81 1.699 20.5]);
figure(3)
plot(x,yn)
hold on 
plot(x,yz)
plot(x,yp)
grid on
xlabel('pochodna uchybu [rad]')
legend('neg.','zero','pos.')
ylim([-0.05 1.05])
xlim([-5 5])
%%
%u

x = -1:0.1:1;
yn = trapmf(x, [-1.72 -1.5 -0.2 -0.05]);
ynp = trimf(x, [-10 -1.5 -0.05]);

yz = trimf(x,  [-0.35 0 0.35]);

yp = trapmf(x, [0.05 0.2 1.5 1.72]);
ypp = trimf(x, [0.05 1.5 10]);


figure(4)
hold on 
plot(x,yn)
plot(x,ynp)
plot(x,yz)
plot(x,yp)
plot(x,ypp)
grid on
xlabel('sterowanie [V]')
legend('neg.', 'neg. puste', 'zero', 'pos.', 'pos. puste')
ylim([-0.05 1.05])
xlim([-1 1])