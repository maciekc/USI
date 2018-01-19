close all
load('noweDane.mat')

figure(1)
yyaxis left
plot(stan.time, stan.signals.values(:,1:2))
hold on 
grid on
plot(zadana.time, -zadana.signals.values)
xlabel('czas [s]')

yyaxis right
plot(stan.time, stan.signals.values(:,3))
legend('nachylenie', 'pred. k�towa', 'wart. zad.', 'pr�d. �mig�a')

figure(2)
plot(sterowanie.time, sterowanie.signals.values)
grid on 
xlabel('czas [s]')
ylabel('sterowanie [PWM]')

