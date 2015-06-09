function [pred, accuracy, prob] = stackedGenMeta(train, trainLabel, test, testLabel, meta)
% meta learner of stacking
if nargin < 5
    meta = 'KNN';
end
switch meta
    case 'KNN'
        K = 9;
        [pred, accuracy, prob] = KNN(train, trainLabel, test, testLabel, K);
    case 'SVM'
        % LIBSVM package
        model = svmtrain_libsvm(trainLabel, train, '-c 0.25 -t 0  -g 1 -b 1');
        [pred, accuracy_verbose, prob] = svmpredict_libsvm(testLabel, test, model, '-b 1');
        accuracy = accuracy_verbose(1, 1);
    case 'MLRC'
        %%% multi-response linear regression classifier (MLRC)
        [pred, accuracy, prob] = MLRC(train, trainLabel, test, testLabel);        
end