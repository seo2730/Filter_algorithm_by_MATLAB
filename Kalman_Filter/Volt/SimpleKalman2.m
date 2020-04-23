function  [volt,P_out, K]= SimpleKalman2(z)
%
%
persistent A H Q R  % 시스템 모델 변수
persistent x P  % 초기값
persistent firstRun

if isempty(firstRun) % 영속변수 선언할 때 초기값들 선언
    A = 1;
    H = 1;
    Q = 0;
    R = 4;
    
    x = 14;
    P = 6;
    
    firstRun = 1;
end

xp = A*x; % 추정값 예측
Pp = A*P*A'+ Q; % 오차 공분산 예측

K = Pp*H'* (H*Pp*H'+R)^-1; % 칼만이득 계산

x = xp + K*(z - H*xp); % 추정값 계산
P = Pp - K*H*Pp; % 오차 공분산 계산

P_out = P;
volt = x;

end