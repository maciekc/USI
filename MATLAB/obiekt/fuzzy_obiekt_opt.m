close all
%clear all
%%
% fuzzy_reg_model_lqr - regulator fuzzy dla modelu i reg. LQR
% stan - stan modelu obiektu dla regulatora LQR
% sterowanie_lqr_model - przebieg sterowania modelu dla reg. LQR
%%

load('noweDane.mat')
%%
x1 = decimate(stan.signals.values(20001:40000,1),10);
x2 = decimate(stan.signals.values(20001:40000,2),10);
x3 = decimate(stan.signals.values(20001:40000,3),10);
x4 = decimate(stan.signals.values(20001:40000,4),10);

u = decimate(sterowanie.signals.values(20001:40000),10);
% x1 = decimate(stan.signals.values(:,1),10);
% x2 = decimate(stan.signals.values(:,2),10);
% x3 = decimate(stan.signals.values(:,3),10);
% x4 = decimate(stan.signals.values(:,4),10);
% 
% u = decimate(sterowanie.signals.values(),10);


data = [x1 x2 x3 x4 u];
numMFs = [5];
mfType = char('gaussmf');
outType = 'constant';
fismat = genfis1(data,numMFs,mfType, outType);

fis = anfis(data, fismat)
%fuzzy_model_reg
% sim('Model_vertical_lqr_2016a', 10)