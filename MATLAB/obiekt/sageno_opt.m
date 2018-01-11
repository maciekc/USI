close all
clear all

data = load('daneFuzzy.mat');
time = data.SD1.time;
%%
figure(1)
plot(time, data.sterowanie(:,1))

figure(3)
plot(time, data.sterowanie(:,2))

figure(2)
plot(time, data.SD1.signals(2).values)

e = data.SD1.signals(2).values(:,2) -data.SD1.signals(2).values(:,1);
output = data.sterowanie(:,2);

%%
%------------------------------------------------------------------
% regultor dla niefiltrowanego sygna³u
data = [e output];
numMFs = [2];
mfType = char('gaussmf');
outType = 'constant';
fismat = genfis1(data,numMFs,mfType, outType);

fis = anfis(data, fismat)

%%
%--------------------------------------------------------------
% widmo sygna³u steruj¹cego
Y = fft(output);
L = length(output);
Fs = 1000;
f = Fs*(0:(L/2))/L;
 
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure(10)
plot(f,P1)
%%
%--------------------------------------------------------------
% filtracja sterowania
close all

if exist('fil', 'var') ~= 1
    load filtr.mat
end
windowSize = 5;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
filtered_output = filter(fil,a,output);
figure(5)
plot(time, filtered_output)
hold on
grid on
plot(time, output, 'r')
legend('filtered', 'original')
figure(6)
plot(time, filtered_output)
grid on
%%
%------------------------------------------------------------------
% regultor dla filtrowanego sterowania
data_f = [e filtered_output];
numMFs = [2];
mfType = char('gaussmf');
outType = 'constant';
fismat_f = genfis1(data_f, numMFs,mfType, outType);

fis_f = anfis(data_f, fismat_f)