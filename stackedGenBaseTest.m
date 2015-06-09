function [pred, accuracy, prob] = stackedGenBaseTest(train, trainLabel, test, testLabel, learner, option)
% stacking base learner test

if nargin < 5
    learner = 'KNN';
end


switch learner
    case 'KNN'
        K = 9;
        [pred, accuracy, prob] = KNN(train, trainLabel, test, testLabel, K);
    case 'SVM'
        % LIBSVM package      
        model = svmtrain_libsvm(trainLabel, train, option);
        [pred, accuracy_verbose, prob] = svmpredict_libsvm(testLabel, test, model, '-b 1');
        accuracy = accuracy_verbose(1, 1);
end