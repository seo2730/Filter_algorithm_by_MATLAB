# 칼만 응용

## 속도로 위치 측정하기
![image](https://user-images.githubusercontent.com/42115807/85978150-0b9cde00-ba19-11ea-9d8a-f7354e9a0a93.png)<br>
![image](https://user-images.githubusercontent.com/42115807/85983492-933b1a80-ba22-11ea-94c6-428b46e7860d.png)<br>
![image](https://user-images.githubusercontent.com/42115807/85983259-258eee80-ba22-11ea-97ad-83e2f10b7326.png)<br>
![image](https://user-images.githubusercontent.com/42115807/85983280-33447400-ba22-11ea-8de7-3252e12426db.png)<br>
측정값이 위치에서 속도로 변경되었으므로 시스템 모델 행렬 H가 달라진다.

#### 칼만 필터 함수
    function [pos, vel] = IntKalman(z) % z는 측정값

    persistent A H Q R % 시스템 모델 변수(모델링,잡음)
    persistent x P     % 초기값
    persistent firstRun

    if isempty(firstRun)
        dt = 0.1;
    
        A = [1 dt;
             0  1];
     
        H = [0 1];
    
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
