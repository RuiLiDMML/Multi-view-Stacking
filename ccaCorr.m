function [corr] = ccaCorr(data)
%%% canonical correlation coefficient
% number of views
m = size(data, 2);
% significance level
thres = 0.05;

if m == 3
    pairs(1, :) = [1, 2];
    pairs(2, :) = [1, 3];
    pairs(3, :) = [2, 3];
    ncomb = size(pairs, 1);
    %%% CCA for every pair
    for i = 1:ncomb
        X = data{1, pairs(i, 1)};
        Y = data{1, pairs(i, 2)};
        [U V r A B stat] = canoncorr(X, Y);
%         [A1 B1 r1 mu] = CCA_magnus(X, Y);
        dim = size(stat.p, 2);
        count = 0;
        rho = 0;
        % significance check
        for j = 1:dim
            if stat.p(1, j) < thres
                count = count + 1;
                rho = rho + r(1, j);
            end
        end
        corr(i, 1) = rho/count;
    end

elseif m == 4
    pairs(1, :) = [1, 2];
    pairs(2, :) = [1, 3];
    pairs(3, :) = [1, 4];
    pairs(4, :) = [2, 3];
    pairs(5, :) = [2, 4];
    pairs(6, :) = [3, 4];
    ncomb = size(pairs, 1);
    %%% CCA for every pair
    for i = 1:ncomb
        X = data{1, pairs(i, 1)};
        Y = data{1, pairs(i, 2)};
        [U V r A B stat] = canoncorr(X, Y);
%         [A1 B1 r1 mu] = CCA_magnus(X, Y);
        dim = size(stat.p, 2);
        count = 0;
        rho = 0;
        % significance check
        for j = 1:dim
            if stat.p(1, j) < thres
                count = count + 1;
                rho = rho + r(1, j);
            end
        end
        corr(i, 1) = rho/count;
    end

elseif m == 5
    pairs(1, :) = [1, 2];
    pairs(2, :) = [1, 3];
    pairs(3, :) = [1, 4];
    pairs(4, :) = [1, 5];
    pairs(5, :) = [2, 3];
    pairs(6, :) = [2, 4];
    pairs(7, :) = [2, 5];
    pairs(8, :) = [3, 4];
    pairs(9, :) = [3, 5];
    pairs(10, :) = [4, 5];
    ncomb = size(pairs, 1);
    %%% CCA for every pair
    for i = 1:ncomb
        X = data{1, pairs(i, 1)};
        Y = data{1, pairs(i, 2)};
        [U V r A B stat] = canoncorr(X, Y);
%         [A1 B1 r1 mu] = CCA_magnus(X, Y);
        dim = size(stat.p, 2);
        count = 0;
        rho = 0;
        % significance check
        for j = 1:dim
            if stat.p(1, j) < thres
                count = count + 1;
                rho = rho + r(1, j);
            end
        end
        corr(i, 1) = rho/count;
    end

else
    pairs(1, :) = [1, 2];
    pairs(2, :) = [1, 3];
    pairs(3, :) = [1, 4];
    pairs(4, :) = [1, 5];
    pairs(5, :) = [1, 6];
    pairs(6, :) = [2, 3];
    pairs(7, :) = [2, 4];
    pairs(8, :) = [2, 5];
    pairs(9, :) = [2, 6];
    pairs(10, :) = [3, 4];
    pairs(11, :) = [3, 5];
    pairs(12, :) = [3, 6];
    pairs(13, :) = [4, 5];
    pairs(14, :) = [4, 6];
    pairs(15, :) = [5, 6];
    ncomb = size(pairs, 1);
    %%% CCA for every pair
    for i = 1:ncomb
        X = data{1, pairs(i, 1)};
        Y = data{1, pairs(i, 2)};
        [U V r A B stat] = canoncorr(X, Y);
%         [A1 B1 r1 mu] = CCA_magnus(X, Y);
        dim = size(stat.p, 2);
        count = 0;
        rho = 0;
        % significance check
        for j = 1:dim
            if stat.p(1, j) < thres
                count = count + 1;
                rho = rho + r(1, j);
            end
        end
        corr(i, 1) = rho/count;
    end
end
% check NAN
nans = sum(isnan(corr), 2) > 0;
corr = corr(~nans, 1);
corr = mean(corr);





