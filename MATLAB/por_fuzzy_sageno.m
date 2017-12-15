close all

set1 = load('fuzzy_sagenoManData.mat');
set2 = load('fuzzy_sagenoOpt.mat');
%%
figure(1)
subplot(211)
plot(set1.ScopeData.time, set1.ScopeData.signals(1).values(:,2),'m')
hold on 
grid on
plot(set2.ScopeData.time, set2.ScopeData.signals(1).values(:,2), 'g')
plot(set2.ScopeData.time, set2.ScopeData.signals(1).values(:,5), 'b')
xlabel('czas [s]')
ylabel('po³o¿enie k¹towe [rad]')
legend('manual', 'optymalizacja', 'wart. zad.')

subplot(212)
e = (set1.ScopeData.signals(1).values(:,2) - set2.ScopeData.signals(1).values(:,2));
plot(set1.ScopeData.time, e)
xlabel('czas [s]')
ylabel('e = \alpha_1 - \alpha_2 [rad]')
grid on