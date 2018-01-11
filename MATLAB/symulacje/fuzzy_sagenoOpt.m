load('referenceDataForSageno.mat')
time = ScopeData.time;

output = ScopeData.signals(2).values;
e = ScopeData3.signals(1).values;
de = ScopeData3.signals(2).values;

de = max(de, -10);
de = min(de, 10);

%%
data = [de e output];
numMFs = [3];
mfType = char('gaussmf', 'gaussmf');
outType = 'constant';
fismat = genfis1(data,numMFs,mfType, outType);

fis = anfis(data, fismat)
sim('model_fuzzy2015a', 5)