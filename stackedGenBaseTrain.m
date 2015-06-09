function [pred, pre_True, accuracy, prob] = stackedGenBaseTrain(train, label, learner, option)
%%% stacked generalization for base learner training
if nargin < 3
    learner = 'KNN';
end

fold = 10;
indices = crossvalind('Kfold', label, fold);% 10-fold cross-validation
pred = [];
pre_True = [];
prob = [];
for j = 1:fold
    % data split
    testIndex = (indices == j);
    trainIndex = ~testIndex;
    trainBase = train(trainIndex, :);
    testBase = train(testIndex, :);
    trainLabel = label(trainIndex);
    testLabel = label(testIndex);
    % learning
    switch learner
        case 'KNN'
            % number of neighbors
            K = 9;
            [predL, accuracy, probL] = KNN(trainBase, trainLabel, testBase, testLabel, K);
            pred = [pred; predL];
            pre_True = [pre_True; testLabel];
            prob = [prob; probL];
        case 'SVM'
            % Libsvm package
            model = svmtrain_libsvm(trainLabel, trainBase, option);
            [predL, accuracy, probL] = svmpredict_libsvm(testLabel, testBase, model, '-b 1'); % test the training dat
            pred = [pred; predL];
            pre_True = [pre_True; testLabel];
            prob = [prob; probL];

    end
end



