u_fuzz = load('sterowanie_fuzzy_model.mat');
u_lqr = load('sterowanie_lqr_model.mat');

fuzz_odp = load('fuzzy_model_odp.mat');
model_odp = load('lqr_model_odp.mat');
%%

figure(1)
subplot(211)
plot(fuzz_odp.lq_por.time, fuzz_odp.lq_por.signals.values, 'b')
grid on 
hold on
plot(model_odp.lq_por.time, model_odp.lq_por.signals.values, 'g')
xlabel('czas [s]')
ylabel('nachylenie [rad]')
legend('reg. fuzzy', 'reg. LQR')

subplot(212)
plot(u_fuzz.sterowanie.Time, u_fuzz.sterowanie.Data, 'b')
grid on 
hold on
plot(u_lqr.sterowanie.Time, u_lqr.sterowanie.Data, 'g')
xlabel('czas [s]')
ylabel('sterowanie [PWM]')
legend('reg. fuzzy', 'reg. LQR')

%----------------------------------------------
%               roznica w dzialaniu regulatorow
%----------------------------------------------
e = fuzz_odp.lq_por.signals.values - model_odp.lq_por.signals.values;
J_fuzz = (e).^2*0.001;

figure(2)
plot(model_odp.lq_por.time, e, 'r')
grid on

xlabel('czas [s]')
ylabel('b³¹d [rad]')
%%
%wskazniki jakosci
JLQ = sum(model_odp.lq_por.signals.values.^2*0.001)
JFUZZ = sum(fuzz_odp.lq_por.signals.values.^2*0.001)
