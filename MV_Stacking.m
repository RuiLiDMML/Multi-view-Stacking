%%%%% multi-view stacking
% Each view is a data source 
% You need to specifiy your 'train_view1', 'test_view1' etc. 
% 'trueLabel' is the data label
% The code implements a four-view stacking, extend or modify the code if
% you have different number of views.

% reference:
% A case study of stacked multi-view learning in dementia research
% In: Proceedings of the 13th Conference on Artificial Intelligence in Medicine, 
% pp. 60–69, Bled, Slovenia, Springer-Verlag. Lecture Notes in Computer Science (LNCS).

clc
clear
close all

fold = 10;
K = 9;
% times to repeat experiments
rep = 10;
% hard or soft class label
output = 'soft';
%%% set base learner type
V1 = 'KNN'; % change to 'SVM' if svm is used as a base learner
V2 = 'KNN';
V3 = 'KNN';
V4 = 'KNN';
%%% meta learner
Meta = 'MLRC';
%%% if KNN is used, 'para' is not used, if SVM is used, para is the svm
%%% parameter setting
para = 'non_SVM';
    
% repeat experiments
for R = 1:rep
    % 10-fold cross-validation
    indices = crossvalind('Kfold', trueLabel, fold);
    accur = zeros(fold, 1);
    for i = 1:fold
        % global index
        testIndex = (indices == i);
        trainIndex = ~testIndex;
        trainLabel = trueLabel(trainIndex);
        testLabel = trueLabel(testIndex);

        %% view 1
        train_view1 = 'fill your data here!'; % training data of view 1
        test_view1 = 'fill your data here!'; % test data of view 1
        % base learner, global training data is split into training and test
        if strcmp(V1, 'SVM') % view 1
            para = '-c 0.25 -t 0  -g 1 -b 1';
        end
        [predB1, predB1_True, accuracyB1, probB1] = stackedGenBaseTrain(train_view1, trainLabel, V1, para);
        % base learner final output
        [pred1, accuracy1, prob1] = stackedGenBaseTest(train_view1, trainLabel, test_view1, testLabel, V1, para);
        % accuracy of view 1
        accur1(i, 1) = accuracy1; % accuracy for all folds

        %% view 2
        train_view2 = 'fill your data here!';
        test_view2 = 'fill your data here!';
        if strcmp(V2, 'SVM')
            para =  '-c 0.25 -t 0  -g 1 -b 1';
        end
        [predB2, predB2_True, accuracyB2, probB2] = stackedGenBaseTrain(train_view2, trainLabel, V2, para);
        % base learner final output
        [pred2, accuracy2, prob2] = stackedGenBaseTest(train_view2, trainLabel, test_view2, testLabel, V2, para);
        accur2(i, 1) = accuracy2;

        %% view 3
        train_view3 = 'fill your data here!';
        test_view3 = 'fill your data here!';
        if strcmp(V3, 'SVM')
            % view 3
            para =  '-c 0.25 -t 0  -g 1 -b 1';
        end
        [predB3, predB3_True, accuracyB3, probB3] = stackedGenBaseTrain(train_view3, trainLabel, V3, para);
        % base learner final output
        [pred3, accuracy3, prob3] = stackedGenBaseTest(train_view3, trainLabel, test_view3, testLabel, V3, para);
        accur3(i, 1) = accuracy3;

        %% view 4
        train_view4 = 'fill your data here!';
        test_view4 = 'fill your data here!';
        if strcmp(V4, 'SVM')
            para =  '-c 0.25 -t 0  -g 1 -b 1';
        end
        [predB4, predB4_True, accuracyB4, probB4] = stackedGenBaseTrain(train_view4, trainLabel, V4, para);
        % base learner final output
        [pred4, accuracy4, prob4] = stackedGenBaseTest(train_view4, trainLabel, test_view4, testLabel, V4, para);
        accur4(i, 1) = accuracy4;
        
        %% canonical correlation
        [corr(i, 1)] = ccaCorr({train_view1, train_view2, train_view3, train_view4});
        singleView = [accuracyB1, accuracyB2, accuracyB3, accuracyB4];
        % variation of single views
        vari(i, 1) = std(singleView);
        
       %% stack all base learners for final prediction
       % training data: base learners' training output
       if strcmp(output, 'hard')
           S_fea = [predB1, predB2, predB3, predB4];
       else
           S_fea = [probB1, probB2, probB3, probB4]; % probabilistic output
       end
       % training label: base learner' benchmark label
       S_label = predB1_True;
       % base learners' final testing output
       if strcmp(output, 'hard')
           S_fea_Test = [pred1, pred2, pred3, pred4];
       else
           S_fea_Test = [prob1, prob2, prob3, prob4]; % probabilistic output
       end
       [corrMeta(i, 1)] = ccaCorr({probB1, probB2, probB3, probB4});
       % true label
       S_label_Test = testLabel;
       %%% meta learner
       [pred, accuracy, pb, weight, pvalue] = stackedGenMeta(S_fea, S_label, S_fea_Test, S_label_Test, Meta);
       finalAccur(i, 1) = accuracy;
       wt(i, :) = weight;
       pv(i, :) = pvalue;
    end
    
    nans = sum(isnan(corr), 2) > 0;
    corr = corr(~nans, 1);
    nansM = sum(isnan(corrMeta), 2) > 0;
    corrMeta = corrMeta(~nansM, 1);
    
    accurV1(R, 1) = mean(accur1);
    accurV2(R, 1) = mean(accur2);
    accurV3(R, 1) = mean(accur3);
    accurV4(R, 1) = mean(accur4);
    
    accurV(R, 1) = mean(finalAccur);

end
