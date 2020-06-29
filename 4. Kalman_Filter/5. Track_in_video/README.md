# 칼만 응용

## 영상 속의 물체 추적
2차원 평면 위의 물체를 추적하는 방법을 설명하는 예제이다.<br>
특정 표적을 감시하고자 할 때 자주 등장한다.<br>
여기서는 영상처리 기법으로 특정 물체의 위치를 입력 받아 정확한 위치를 추정하는 역할이다.<br>
영상처리 알고리즘으로 얻은 위치의 오차를 제거하고 이동 속도 등을 추정하는데 활용한다.<br>

#### 시스템 모델
![image](https://user-images.githubusercontent.com/42115807/85986288-f29b2980-ba26-11ea-811c-ef3e0a16de10.png)<br>
![image](https://user-images.githubusercontent.com/42115807/85986336-08a8ea00-ba27-11ea-8a38-d61bda2c96f3.png)<br>
![image](https://user-images.githubusercontent.com/42115807/85986405-25452200-ba27-11ea-9878-423ca71ff491.png)<br>

시스템 잡음인 Q가 위치 및 속도 계산할 때 영상에서는 잡음이 생길 수 있다.<br>
측정 잡음인 R는 위치를 측정하는 것이므로 위치에 해당되는 행렬 위치에 값을 넣는다.<br>

#### 칼만필터 함수

    function [xh,yh] = TrackKalman(xm,ym)

    persistent A H Q R;
    persistent x P
    persistent firstRun

    if isempty(firstRun)
        dt = 1;
    
        A = [1 dt 0  0;
             0  1 0  0;
             0  0 1 dt;
             0  0 0  1];
     
        H = [1 0 0 0;
             0 0 1 0];
     
        Q = 1.0*eye(4);
    
        R = [50  0;
              0 50];
     
        x = [0 0 0 0]';
        P = 100*eye(4);
    
        firstRun = 1;
    end

    xp = A*x;
    Pp = A*P*A'+Q;

    K = Pp*H'*(H*Pp*H'+R)^-1;

    z= [xm, ym]';
    x = xp + K*(z-H*xp);
    P = Pp - K*H*Pp;

    xh = x(1);
    yh = x(3);

