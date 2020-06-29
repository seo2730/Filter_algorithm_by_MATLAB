# 칼만필터 응용

## 초간단 예제
>배터리 전압을 측정하는데 잡음이 심해서 잴 때마다 달라서 칼만필터로 측정 데이터의 잡음을 제거해보기로 했다. 전압은 0.2초 간격으로 측정한다.<br>

#### 시스템 
아래 식은 예제의 시스템 모델을 상태공간에 표현한 식이다.<br>
![image](https://user-images.githubusercontent.com/42115807/85975819-0d17d780-ba14-11ea-875d-d01ae9dc47f4.png)<br>

1. 첫 번째 식은 배터리의 전압은 일정하게 유지되는데 그 값이 14V이다.<br>
2. 두 번째 식은 전압이 측정값인데 잡음이 섞여 있다는 의미다. Vk는 평균이 0이고 표준편차가 2인 정규분포를 따른다<br>
3. 이 식을 이용해 시스템 변수인 A, H, Q, R을 아래 식으로 구할 수 있다.<br>

![image](https://user-images.githubusercontent.com/42115807/85976627-e35fb000-ba15-11ea-861f-91d4a7bc4f91.png)<br>
<br>
만약 초기값에 대한 정보가 없다면 오차 공분산은 크게 잡는게 좋다.<br>

#### 칼만 필터의 함수


      function volt = SimpleKalman(z)
      %
      %
      persistent A H Q R  % 시스템 모델 변수
      persistent x P      % 초기값
      persistent firstRun

      if isempty(firstRun)
          A = 1;
          H = 1;
          Q = 0;
          R = 4;
    
          x = 14;
          P = 6;
    
          firstRun = 1;
      end

      xp = A*x;                   % 추정값 예측
      Pp = A*P*A'+ Q;             % 오차 공분산 예측

      K = Pp*H'* (H*Pp*H'+R)^-1;  % 칼만이득 계산

      x = xp + K*(z - H*xp);      % 추정값 계산
      P = Pp - K*H*Pp;            % 오차 공분산 계산

      volt = x;                   % 반환값
      end

구현 코드를 보면 시스템 모델 변수는 최초로 실행될 때 한 번만 초기화해준다. 초기 예측값도 이 때 지정한다.<br>
간혹 이 변수들을 내부에서 초기화하지 않고, 함수의 인자로 받도록 구현하는 경우도 있다. 언어에 따라 선택하면 된다.<br>
코드에서 예측값을 나타내는 변수를 이름 뒤에 p 를 붙였다.<br>
마지막 줄은 추정값을 반환하기 위한 코드이다. MATLAB에서 함수의 첫 번째 줄에서 반환값으로 지정한 변수에 값을 대입해주면 함수 실행이 끝날 때 이 값이 자동으로 반환된다.<br>

#### 오차 공분산과 칼만 이득
위 함수에서 오차 공분산과 칼만 이득을 반환하고 싶으면 아래 코드처럼 짜면 된다.<br>

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
