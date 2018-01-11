close all

time = ScopeData1.time;
prad = ScopeData1.signals(1).values(:,1);
alpha = ScopeData1.signals(1).values(:,2);
omega = ScopeData1.signals(1).values(:,3);
a = ScopeData1.signals(1).values(:,4);
zadana = ScopeData1.signals(1).values(:,5);

sterowanie = ScopeData1.signals(2).values();

figure(1)
subplot(211)
plot(time, alpha, 'b')
hold on 
grid on 
plot(time, zadana, 'r')
legend('po³o¿enie', 'wart. zad.')
xlabel('czas [s]')
ylabel('po³o¿enie [rad]')
subplot(212)
plot(time, sterowanie, 'g')
grid on
xlabel('czas [s]')
ylabel('sterowanie [v]')
