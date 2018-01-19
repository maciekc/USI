close all

%%
% fuzzy_reg_model_lqr - regulator fuzzy dla modelu i reg. LQR
% stan - stan modelu obiektu dla regulatora LQR
% sterowanie_lqr_model - przebieg sterowania modelu dla reg. LQR
%%

load('stan.mat')

x1 = stan.Data(:,1);
x2 = stan.Data(:,2);
x3 = stan.Data(:,3);

u = sterowanie.Data;

data = [x1 x2 x3 u];
numMFs = [4];
mfType = char('gaussmf');
outType = 'constant';
fismat = genfis1(data,numMFs,mfType, outType);

fis = anfis(data, fismat)

sim('Model_vertical_lqr_2016a', 10)