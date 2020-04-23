function avg = MovAvgFilter2(x)
%
%
persistent n xbuf
persistent firstRun

if isempty(firstRun)
    n=10;
    xbuf = x*ones(n,1);
    
    firstRun = 1;
end

% 오래된 값 버리기
for m=1:n-1
    xbuf(m) = xbuf(m+1);
end

% 최신 값 넣어주기
xbuf(n) = x;

% 가독성은 좀 떨어지는 방법 -> 데이터 개수가 크면 재귀식이 훨씬 나음
avg = sum(xbuf)/n;