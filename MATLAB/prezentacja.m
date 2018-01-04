figure(1)
subplot(211)
plot(ScopeData1.time, ScopeData1.signals(1).values(:,2),'b')
hold on 
grid on
plot(ScopeData1.time, ScopeDatan.signals(1).values(:,2),'g')
plot(ScopeData1.time, ScopeDatan.signals(1).values(:,5),'r')
xlabel('czas [s]')
ylabel('po³o¿enie [rad]')
axis([0 5 -1.1 1.3])
subplot(212)
plot(ScopeData1.time(1:500), (ScopeData1.signals(1).values(1:500,2) - ScopeDatan.signals(1).values(1:500,2)).^2)
grid on
xlabel('czas [s]')
ylabel('e^2 [rad^2]')
