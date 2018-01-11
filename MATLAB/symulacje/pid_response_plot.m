dane
%%
time = ScopeData.time;
responseData = ScopeData.signals(1).values;
controlsignal = ScopeData.signals(2).values;

figure(1)
subplot(211)
plot(time, responseData)
legend('prad [A]','kπt [rad]','omega [rad/s]','przyspieszenie [rad/s^2]','wart. zad. [rad]');
xlabel('czas [s]')
ylabel('odpowiedü')
grid on
subplot(212)
plot(time, controlsignal)
xlabel('czas [s]')
ylabel('sterowanie [V]')
grid on
axis([0 15 -1.1 1])