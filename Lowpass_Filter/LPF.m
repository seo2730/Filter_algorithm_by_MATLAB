function xlpf = LPF(x)
%
%
persistent prevX
persistent firstRun

if isempty(firstRun)
    prevX = x; % 오차를 줄이기 위해
    firstRun = 1;
end

% 0 < alpha < 0.7
alpha = 0.7;

% 현재 최신값에 가중치를 더 크게 줘야한다.
% alpha가 작으면 추정값에 잡음이 더 나타난다.
% alpha가 크면 직전 추정값의 비중이 더 커서 잡음이 줄어들고 변화가 무뎌진다.
xlpf = alpha*prevX+(1-alpha)*x;

prevX = xlpf;