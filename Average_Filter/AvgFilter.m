function avg = AvgFilter(x)
%
%
persistent prevAvg k
persistent firstRun


if isempty(firstRun)
    k = 1;
    prevAvg = 0;
    
    firstRun = 1;
end

alpha = (k-1)/k;

% 평균 필터 = (1-K)/K * 전 값들 평균 + 1/K * 현재 값 

avg = alpha*prevAvg + (1-alpha)*x;

prevAvg = avg;
k = k+1;
