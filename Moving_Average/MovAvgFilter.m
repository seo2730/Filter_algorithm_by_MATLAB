function avg = MovAvgFilter(x)
% 이동평균은 오래된 값은 버리고 최신 값은 넣어줘야한다.
% FIFO 방식
persistent prevAvg n xbuf
persistent firstRun

if isempty(firstRun)
    n = 10;                 % 갯수는 고정
    xbuf = x*ones(n+1,1);   % 초기화
    
    k=1;
    prevAvg = x;
    
    firstRun=1;
end

% 오래된 값 버리기
for m=1:n
    xbuf(m) = xbuf(m+1);
end

% 최신 값 넣어주기
xbuf(n+1) = x;

% 이동평균 = 전 값들 평균 + (현재 값 - 오래된 값)/n
avg = prevAvg + (x-xbuf(1))/n;

prevAvg = avg;
