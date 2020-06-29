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
