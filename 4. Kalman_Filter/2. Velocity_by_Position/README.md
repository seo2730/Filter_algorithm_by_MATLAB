# 칼만필터 응용
    
## 위치로 속도 측정
>열차의 성능 시험을 한다. 시험 내용은 직선 선로에서 열차가 80m/s의 속도를 유지하는지 확인하는 것이다. 위치와 속도 정보는 0.1초 간격으로 측정해서 저장하도록 되어 있다. 하지만 속도 데이터가 모두 0 찍히는 현상이 일어났다. 다행히 위치 정보는 이상이 없다.<br>

#### 시스템 모델
속도 = 이동거리/시간 공식을 이용하여 속도를 구할 수 있지만 오차가 크게 나온다. 이동 평균 필터를 이용할 수 있지만 지저분하게 나오므로 칼만필터를 사용해서 깨끗하게 나오게 할 수 있다.<br>
<br>
여기서 관심 있는 물리량은 열차의 위치와 속도이므로 이 두 변수를 상태변수로 정의한다.<br>
![image](https://user-images.githubusercontent.com/42115807/85978150-0b9cde00-ba19-11ea-9d8a-f7354e9a0a93.png)<br>
![image](https://user-images.githubusercontent.com/42115807/85978308-6b938480-ba19-11ea-9548-4febc899baaa.png)<br>
위 식들 풀어보면<br>
![image](https://user-images.githubusercontent.com/42115807/85978796-6a168c00-ba1a-11ea-907d-0ae737beeaaa.png)
![image](https://user-images.githubusercontent.com/42115807/85978862-831f3d00-ba1a-11ea-9428-bbbfb5cfae59.png)<br>
시스템 잡음(Wk)를 제외하면 열차의 속도는 일정하므로 모델링이 잘 되었다.<br> 
여기서 잡음은 마찰, 엔진 제어기의 오차 등 속도에 영향을 주는 요인들의 모든 합이다.<br>
측정하는 값이 위치이고 측정값에 잡음이 섞여 있다는 것이다.<br>
이처럼 행렬 A와 H는 임의로 선정한 것이 아니라 시스템의 물리적인 관계를 모델링한 결과이다.<br>
잡음의 공분산인 Q는 시스템 잡음(Wk)은 구하기 어려워서 시스템에 대한 지식과 경험에 의존해야한다.<br>
잡음의 공분산인 R는 측정 잡음(Vk)은 센서 제작사에서 오차 특성을 제공하지만 그렇지 않다면 실험을 통해 결정해야한다.<br>
즉 두 공분산 행렬은 해석적으로 구하기 어렵다면 칼만 필터의 설계 인자로 보고 시행착오로 거쳐 선정해야한다.<br>

#### 칼만 필터 함수

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
