function [pos, vel] = DvKalman(z) % z는 측정값

persistent A H Q R % 시스템 모델 변수(모델링,잡음)
persistent x P     % 초기값
persistent firstRun

if isempty(firstRun)
    dt = 0.1;
    
    A = [1 dt;
         0  1];
     
    H = [1 0];
    
    Q = [1 0;
         0 3];
     
    R = 10;
    
    x = [0 20]'; % 초기 위치 : 0  초기 속도 : 20
    P = 5*eye(2); % 대각행렬 2x2 크기
    
    firstRun = 1;
end

xp = A*x;
Pp = A*P*A'+Q;

K = Pp*H'*(H*Pp*H'+R)^-1;

x = xp + K*(z-H*xp);
P = Pp-K*H*Pp;

pos = x(1,1);
vel = x(2,1);

end


    
    
