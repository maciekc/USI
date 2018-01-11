close all;
clearvars;
%% Laboratorium Problemowe 2 - Helikopter
fs=1e3;

%% Co trzeba zrobi�:
% 1. Wyznaczy� k�t alpha_0.
% 2. Zapisa� drgania wahad�a fizycznego.
% 3. Wyznaczy� dok��dniej moment niewywa�enia.
% 4. Funkcj� optymalizacyjn� znale�� t�umienie i moment bezw�adno�ci.
% 5. Wyznaczy� parametry z odpowiedzi skokowej pr�dko�ci �mig�a.

% Do napisania w MATLAB-ie:
% 1. Doda� przeliczenie z ADC na pr�dko�� obrotow�.
% 2. Dopasowywania wielomianu do punkt�w pomiarowych.
% 3. Dobieranie paramter�w funkcj� lsqnonlin.

%% Przeliczenie pr�dko�ci
vp = [-8.6 -7.3 -5.7 -3.6 3.58 5.7 7.2 8.3];
napiecie = [-1.41 -1.2 -0.933 -0.59 0.585 0.936 1.175 1.383];
wsp_V = polyfit(vp, napiecie, 1);

poly_V = linspace(-10,10,1e3);
poly_U = polyval(wsp_V,poly_V);
figure(1);
plot(vp,napiecie*1000/0.52/60*2*pi,'*',poly_V,poly_U*1000/0.52/60*2*pi);
grid on;
xlabel('Napi�cie [V]');
ylabel('Pr�dko�� k�towa [rad/s]');
title('Charakterystyka statyczna napi�cie-pr�dko��');

%% Moment si�y no�nej od pr�dko�ci �mig�a
pwm = [0.63 0.51 0.37 0.23 0 -0.35 -0.565 -0.85];
v = polyval(wsp_V,[7.1 6.3 5.2 3.75 0 -5.15 -7.05 -8.7])*1000/0.52/60*2*pi;
masa = [0 15 30 45 60 75 90 105];
moment = -masa.*0.001*0.26*9.81;
a=moment(pwm==0)/-sin(-0.5223);
moment = moment - moment(5);

wsp_M_V = polyfit(v, moment, 5);
poly_V = -350:0.1:350;
poly_M = polyval(wsp_M_V, poly_V);
figure(2);
plot(v, moment, 'r*', poly_V, poly_M, 'b');
title('Moment si�y w zale�no�ci od predko�ci silnika g��wnego');
xlabel('Pr�ko�� [rad/s]');
ylabel('Moment si�y [Nm]');
grid on;
legend('Pomiary', 'Aproksymacja');

%% Opory ruchu od pr�dko�ci obrotowej �mig�a
pred = [-3158 -2890 -2680 -2460 -2270 -2030 -1770 -1470 -1120 -670 0 670 1100 1440 1730 1990 2220 2420 2560 2720 2860]/60*2*pi;
PWM = -1:0.1:1;

poly_V = linspace(pred(1),pred(end),1e3);
wsp_U_V = polyfit(pred,PWM,5);
poly_PWM = polyval(wsp_U_V, poly_V);
figure(3);
plot(pred, PWM, '*', poly_V, poly_PWM, 'g');
grid on;
title('Opory �mig�a w zale�no�ci od pr�dko�ci silnika g��wnego');
xlabel('Pr�kdo�� [rad/s]');
ylabel('Wsp. PWM');
legend('Pomiary','Aproksymacja');

%% Dobranie parametr�w modelu uk�adu silnik DC - �mig�o
load('Pitch_char_U_V.mat');
I_v = 0.2;
Pitch_char(:,2)=1000/0.52*polyval(wsp_V,Pitch_char(:,2))/60*2*pi;
options = optimoptions(@lsqnonlin,'Display','iter');
cel=@(param) step_smiglo_test(param, wsp_U_V, Pitch_char);
I_v = lsqnonlin(cel, I_v, 0,[],options);

t_vect=(0:(length(Pitch_char)-1))/fs;
[t,w]=ode45(@(t,w) (Pitch_char(floor(t*fs)+1,1)-polyval(wsp_U_V,w))/I_v,t_vect,0);
figure(4);
plot(t_vect, Pitch_char(:,2), 'b', t, w, 'r');
grid on;
title('Identyfikacja parametr�w uk�adu silnik DC - �mig�o g��wne');
xlabel('Czas [s]');
ylabel('Pr�dko�� k�towa [rad/s]');
legend('Pomiary','Aproksymacja');

%% Co trzeba zrobi�:
% 1. Wyznaczy� zale�no�� sterowania od pr�dko�ci obrotowej dla wirnika
% bocznego.
% 2. Zapisa� odpowiedzi skokowe pr�dko�ci silnika bocznego i dobra� moment
% bezw�adno�ci.
% 3. Zapisanie odpowiedzi po�o�enia k�towego w celu identyfikacji
% parametr�w.

% Do napisania w MATLAB-ie:
% 1. Zrobi� model w Simulink na podstawie r�wna� r�niczkowych.

%% Opory ruchu od pr�dko�ci obrotowej �mig�a bocznego
pred_az = [-3010 -2730 -2520 -2270 -2020 -1740 -1450 -1130 -790 -415 0 420 800 1150 1460 1750 2010 2270 2500 2700 2900]/60*2*pi;
PWM_az = -1:0.1:1;

poly_V_az = linspace(pred_az(1),pred_az(end),1e3);
wsp_U_V_az = polyfit(pred_az,PWM_az,5);
poly_PWM_az = polyval(wsp_U_V_az, poly_V_az);
figure(5);
plot(pred_az, PWM_az, '*', poly_V_az, poly_PWM_az, 'g');
grid on;
title('Opory �mig�a w zale�no�ci od pr�dko�ci silnika g��wnego');
xlabel('Pr�kdo�� [rad/s]');
ylabel('Wsp. PWM');
legend('Pomiary','Aproksymacja');

%% Dobranie parametr�w modelu uk�adu silnik DC - �mig�o boczne
load('Azimuth_char_U_V.mat');
I_h = 1e-3;
Azimuth_char(:,2)=1000/0.52*polyval(wsp_V,Azimuth_char(:,2))/60*2*pi;
options = optimoptions(@lsqnonlin,'Display','iter');
cel=@(param) step_smiglo_test(param, wsp_U_V_az, Azimuth_char);
I_h = lsqnonlin(cel, I_h, 0,[],options);

t_vect=(0:(length(Azimuth_char)-1))/fs;
[t,w]=ode45(@(t,w) (Azimuth_char(floor(t*fs)+1,1)-polyval(wsp_U_V_az,w))/I_h,t_vect,0);
figure(6);
plot(t_vect, Azimuth_char(:,2), 'b', t, w, 'r');
grid on;
title('Identyfikacja parametr�w uk�adu silnik DC - �mig�o boczne');
xlabel('Czas [s]');
ylabel('Pr�dko�� k�towa [rad/s]');
legend('Pomiary','Aproksymacja');

%% Moment si�y no�nej od pr�dko�ci �mig�a bocznego
load('daneN04.mat');
signals = [pred/60*2*pi,kat*pi/180];
wsp_M_h = 1;
f_h = 0.05;
decision=[f_h wsp_M_h];
options = optimoptions(@lsqnonlin,'Display','iter');
cel=@(param) step_azimuth(param, signals);
decision = lsqnonlin(cel, decision, [0;-1e3],[1;1e3],options);
f_h = decision(1);
wsp_M_h = decision(2);

t_vect = (0:(length(signals)-1))/fs;
[t,x] = ode45(@(t,x) ([x(2);-f_h*x(2)+wsp_M_h]),t_vect,[0;0]);
figure(7);
plot(t_vect, signals(:,2), 'b', t, x(:,1), 'r');
grid on;
title('Identyfikacja wsp�czynnika tarcia lepkiego dla osi pionowej');
xlabel('Czas [s]');
ylabel('Po�o�enie k�towe [rad]');
legend('Pomiary','Aproksymacja');

%% Pr�dko�� obrotowa
figure(8);
t=(0:length(pred)-1)/fs;
plot(t,signals(:,1));
grid on;
title('Pr�dko�� silnika');
ylabel('Pr�dko�� obrotowa silnika [rad/s]');
xlabel('Czas [s]');

%% Moment si�y no�nej od pr�dko�ci �mig�a bocznego - total
% signals = cell(1,8);
% load('daneN-08.mat');
% signals{1} = [pred/60*2*pi,kat*pi/180];
% load('daneN-06.mat');
% signals{2} = [pred/60*2*pi,kat*pi/180];
% load('daneN-04.mat');
% signals{3} = [pred/60*2*pi,kat*pi/180];
% load('daneN-02.mat');
% signals{4} = [pred/60*2*pi,kat*pi/180];
% load('daneN02.mat');
% signals{5} = [pred/60*2*pi,kat*pi/180];
% load('daneN04.mat');
% signals{6}=[pred/60*2*pi,kat*pi/180];
% load('daneN06.mat');
% signals{7} = [pred/60*2*pi,kat*pi/180];
% load('daneN08.mat');
% signals{8}=[pred/60*2*pi,kat*pi/180];
% poly_rank = 1;
% wsp_M_h = ones(1,poly_rank+1)*1;
% f_h = 1e-2;
% decision=[f_h wsp_M_h];
% options = optimoptions(@lsqnonlin,'Display','iter');
% cel=@(param) step_azimuth_total(param, signals);
% decision = lsqnonlin(cel, decision, [0;-1e3*(ones(poly_rank+1,1))],[1;1e3*(ones(poly_rank+1,1))],options);

%% Moment si�y w p�aszczy�nie poziomej
load('kat_-04.mat');
load('pred_-04.mat');
signals = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];
poly_rank = 3;
wsp_M_h = ones(1,poly_rank+1)*1e-8;

options = optimoptions(@lsqnonlin,'Display','iter');
cel=@(param) step_azimuth_M_h(param, f_h, signals);
wsp_M_h = lsqnonlin(cel, wsp_M_h, [],[],options);

%% Test parameters
load('kat_-04.mat');
load('pred_-04.mat');
signals = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];

t_vect = (0:(length(signals)-1))/fs;
[t,x] = ode45(@(t,x) ([x(2);-f_h*x(2)+polyval(wsp_M_h,signals(floor(t*fs)+1,1))]),t_vect,[0;0]);
figure(9);
plot(t_vect, signals(:,2), 'b', t, x(:,1), 'r');
grid on;
xlabel('Czas [s]');
ylabel('Po�o�enie k�towe [rad]');
legend('Pomiary','Aproksymacja');

%% Moment si�y no�nej od pr�dko�ci �mig�a bocznego - total
signals = cell(1,6);
load('kat_-06.mat');
load('pred_-06.mat');
signals{1} = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];
load('kat_-04.mat');
load('pred_-04.mat');
signals{2} = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];
load('kat_-02.mat');
load('pred_-02.mat');
signals{3} = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];
load('kat_02.mat');
load('pred_02.mat');
signals{4} = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];
load('kat_04.mat');
load('pred_04.mat');
signals{5} = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];
load('kat_06.mat');
load('pred_06.mat');
signals{6} = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];
poly_rank = 5;
% wsp_M_h = ones(1,poly_rank+1)*1e-13;
options = optimoptions(@lsqnonlin,'Display','iter');
cel=@(param) step_azimuth_M_h_total(param, f_h, signals);
wsp_M_h = lsqnonlin(cel, wsp_M_h, [],[],options);

%% Test parameters
load('kat_-06.mat');
load('pred_-06.mat');
signals = [v(1:2e3)/60*2*pi,k(1:2e3)*pi/180];

t_vect = (0:(length(signals)-1))/fs;
[t,x] = ode45(@(t,x) ([x(2);-f_h*x(2)+polyval(wsp_M_h,signals(floor(t*fs)+1,1))]),t_vect,[0;0]);
figure(9);
plot(t_vect, signals(:,2), 'b', t, x(:,1), 'r');
grid on;
title('Identyfikacja momentu si�y w p�aszczy�nie poziomej');
xlabel('Czas [s]');
ylabel('Po�o�enie k�towe [rad]');
legend('Pomiary','Aproksymacja');

%% Pr�dko�� obrotowa
figure(10);
t=(0:length(signals)-1)/fs;
plot(t,signals(:,1));
grid on;
title('Pr�dko�� silnika');
ylabel('Pr�dko�� obrotowa silnika [rad/s]');
xlabel('Czas [s]');

%% Wykres momentu si�y od pr�dko�ci obrotowej
poly_V = -200:0.1:200;
poly_M_h = polyval(wsp_M_h, poly_V);
figure(11);
plot(poly_V, poly_M_h, 'b');
title('Moment si�y w zale�no�ci od predko�ci silnika bocznego');
xlabel('Pr�ko�� [rad/s]');
ylabel('Moment si�y [Nm]');
grid on;

%% Moment bezw�adno�ci dla osi poziomej
alpha_0 = -0.5223;
load('kat_bezwladnosc.mat');
signals = SD1.signals(2).values(7580:end)*pi/180;
J_v = 0.0604;
f_v = 0.0042;
parameters = [J_v f_v alpha_0];
options = optimoptions(@lsqnonlin,'Display','iter');
cel=@(param) step_inertial(param, a, signals);
parameters = lsqnonlin(cel, parameters, [0;0;-30*pi/180],[],options);

J_v = parameters(1);
f_v = parameters(2);
alpha_0 = parameters(3);

t_vect=(0:(length(signals)-1))/fs;
[t,x]=ode45(@(t,x) ([x(2);a/J_v*sin(x(1)-alpha_0)-f_v/J_v*x(2)]),t_vect,[signals(1);0]);
figure(12);
plot(t_vect, signals, 'b', t, x(:,1), 'r');
grid on;
title('Identyfikacja momentu bezw�adno�ci w p�aszczy�nie pionowej');
xlabel('Czas [s]');
ylabel('Po�o�enie k�towe [rad]');
legend('Pomiary','Aproksymacja');

%% Wyliczenie punktu r�wnowagi
lin_alpha_v = 0;
lin_velocity_v = 0;
lin_w_v = roots(wsp_M_V+[zeros(1,length(wsp_M_V)-1) a*sin(lin_alpha_v-alpha_0)]);
lin_w_v = real(lin_w_v(lin_w_v>-330 & lin_w_v<300 & imag(lin_w_v)==0));
lin_u_v = polyval(wsp_U_V, lin_w_v);
% 
% vect_lin_alpha_v = linspace(-pi/3+pi/65,pi/6-pi/170,1e3);
% vect_lin_w_v = zeros(1, length(vect_lin_alpha_v)); 
% for i=1:length(vect_lin_alpha_v)
%     temp_lin_w_v = roots(wsp_M_V+[zeros(1,length(wsp_M_V)-1) a*sin(vect_lin_alpha_v(i)-alpha_0)]);
%     vect_lin_w_v(i) = real(temp_lin_w_v(temp_lin_w_v>-330 & temp_lin_w_v<300 & imag(temp_lin_w_v)==0));
% end
% vect_lin_u_v = polyval(wsp_U_V, vect_lin_w_v);
% 
% figure(13);
% plot3(vect_lin_alpha_v, vect_lin_w_v, vect_lin_u_v);
% grid on;
% title('Zbi�r punkt�w r�wnowagi');
% xlabel('x_1 [rad]');
% ylabel('x_3 [rad/s]');
% zlabel('u');
% 
% figure(14);
% plot(vect_lin_alpha_v,vect_lin_w_v);
% grid on;
% title('Pr�dko�� silnika w punktach r�wnowagi');
% xlabel('x_1 [rad]');
% ylabel('x_3 [rad/s]');
% 
% figure(15);
% plot(vect_lin_alpha_v,vect_lin_u_v);
% grid on;
% title('Sterowanie w punktach r�wnowagi');
% xlabel('x_1 [rad]');
% ylabel('u');

%% Linearyzacja w punkcie r�wnowagi
lin_M_V_diff = polyder(wsp_M_V);
lin_U_V_diff = polyder(wsp_U_V);
lin_A = [0 1 0;...
    a/J_v*cos(lin_alpha_v-alpha_0) -f_v/J_v polyval(lin_M_V_diff, lin_w_v)/J_v;...
    0 0 -polyval(lin_U_V_diff, lin_w_v)/I_v];
lin_B = [0; 0; 1/I_v];
lin_C = [1 0 0];
lin_D = 0;

%% Regulator LQ dla osi poziomej
ctr = ctrb(lin_A, lin_B);
Q = [1 0 0;0 0 0;0 0 0];
R = 1;
N = zeros(3,1);
K_lqr = lqr(lin_A, lin_B, Q, R, N);

%% Regulator LQI dla osi poziomej
lin_sys = ss(lin_A, lin_B, lin_C, lin_D);
Q = [1 0 0 0;0 0 0 0;0 0 0 0;0 0 0 1];
R = 1;
N = zeros(4,1);
K_lqi = lqi(lin_sys, Q, R, N);

%% Pe�ny obserwator Luenbergera dla modelu liniowego
obs = obsv(lin_A, lin_C);
R_ob = rank(obs);
lambda = [-3 -2 -1]*3;
L = place(lin_A.', lin_C.', lambda).';

t=(0:length(sim_alpha_v)-1)/fs;
figure(16);
plot(t,sim_alpha_v(:,1),'b',t,sim_alpha_v(:,2),'r');
title('Obserwator Luenbergera - nachylenie');
xlabel('Czas [s]');
ylabel('Po�o�enie k�towe [rad]');
grid on;
legend('Model','Obserwator');
figure(17);
plot(t,sim_dalpha_v(:,1),'b',t,sim_dalpha_v(:,2),'r');
title('Obserwator Luenbergera - pr�dko�� k�towa');
xlabel('Czas [s]');
ylabel('Pr�dko�� k�towa [rad/s]');
grid on;
legend('Model','Obserwator');
figure(18);
plot(t,sim_w_v(:,1),'b',t,sim_w_v(:,2),'r');
title('Obserwator Luenbergera - pr�dko�� silnika');
xlabel('Czas [s]');
ylabel('Pr�dko�� silnika [rad/s]');
grid on;
legend('Model','Obserwator');

%%
t=(0:length(sim_alpha_v)-1)/fs;
figure(19);
plot(t,sim_alpha_v(:,1));
title('Regulator LQI - nachylenie');
xlabel('Czas [s]');
ylabel('Po�o�enie k�towe [rad]');
grid on;
figure(20);
plot(t,sim_dalpha_v(:,1));
title('Regulator LQI - pr�dko�� k�towa');
xlabel('Czas [s]');
ylabel('Pr�dko�� k�towa [rad/s]');
grid on;
figure(21);
plot(t,sim_w_v(:,1));
title('Regulator LQI - pr�dko�� silnika');
xlabel('Czas [s]');
ylabel('Pr�dko�� silnika [rad/s]');
grid on;