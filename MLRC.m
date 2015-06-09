function [pred, acc, prob] = MLRC(training, trLabel, test, tstLabel)
%%% multi-response linear regression classifier (MLRC)
% reference
% K.M. Ting and I.H. Witten. Issues in stacked generalization. Journal of Artificial
% Intelligence Research, 10(1):271¨C289, 1999

% binary class
uniLabel = unique(trLabel);
inter = ones(size(training, 1), 1);
coefs = regress(trLabel, [inter training]);
inter2 = ones(size(test, 1), 1);
yhat = [inter2 test]*coefs;

yhatC1 = abs(uniLabel(1, 1) - yhat);
yhatC2 = abs(uniLabel(2, 1) - yhat);

subC = yhatC1-yhatC2;
pred(find(subC>0), 1) = uniLabel(2, 1);
pred(find(subC<0), 1) = uniLabel(1, 1);

acc = 100*size(find(pred == tstLabel), 1)/size(tstLabel, 1);

prob(:, 1) = yhatC2./(yhatC1+yhatC2);
prob(:, 2) = 1-prob(:, 1);