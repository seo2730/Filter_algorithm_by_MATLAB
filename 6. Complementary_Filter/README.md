# 칼만응용

## 상보필터(Complementary Filter)
칼만 필터의 특성 중 하나인 **센서 융합** 특성을 가지고 있어서 칼만 필터의 대안이 될 수 있다.<br>
칼만 필터보다 훨씬 단순하고 설계하기가 쉽다.<br>
칼만 필터와 달리 발산할 염려도 없다.<br>
주의할 점은 융합할 센서의 주파수 특성이 서로 보완적인 특성을 갖는 경우에만 적용 가능하다는 점이다.<br>
-> 한 센서는 저주파를 잘 측정하고 다른 한 센서는 고주파를 잘 측정하면 이 두 센서를 적절히 융합해서 개별 센서의 측정값보다 더 우수하게 얻을 수 있다.<br>
<br>
![image](https://user-images.githubusercontent.com/42115807/86071897-5cfda980-babb-11ea-84a7-d3701747e029.png)<br>
x(t) : 측정 물리량의 참값<br> 
n1(t), n2(t) : 각 센서의 측정값에 포함된 잡음<br>
G1(s),G2(s) : 센서의 측정값을 입력 받아 처리하는 필터<br>t
z(t) : 최종 측정 결과<br>
<br>
이 시스템을 상보필터에 맞게 구성하면 아래 사진처럼 나온다.<br>
![image](https://user-images.githubusercontent.com/42115807/86072207-09d82680-babc-11ea-807e-feafd102633d.png)<br>
![image](https://user-images.githubusercontent.com/42115807/86072238-1a889c80-babc-11ea-9367-a43c6e37755d.png)<br>
위 구성도에서 최종 출력 z(t)를 라플라스로 표현하면<br>
![image](https://user-images.githubusercontent.com/42115807/86072309-44da5a00-babc-11ea-98d3-e30e8493d21b.png)<br>
이 식에서 보면 참 값(X)은 필터(G)의 영향을 전혀 받지 않는다는 것이다.<br>
만약 n1이 저주파 잡음이고 n2가 고주파 잡음이면 G를 저주파 필터로 설계했다고 가정해보면<br>
-> G*n2는 아주 작은 값을 갖게 되고 (1-G)는 고주파 필터이므로 n1도 걸러진다.
-> 이렇게 두 측정 잡음이 상보적인 경우에는 상보 필터로 센서로 융합하면 아래 식처럼 상당한 성능 개선이 가능하다.<br>
![image](https://user-images.githubusercontent.com/42115807/86072856-8a4b5700-babd-11ea-8e03-b55c05c1710c.png)<br>
<br>
만약 측정 센서가 3개 이상일 경우 아래 사진처럼 상보필터를 쉽게 확장할 수 있다.<br>
![image](https://user-images.githubusercontent.com/42115807/86072920-b49d1480-babd-11ea-95e8-170573be296d.png)<br>
<br>
정리하자면 상보필터는 동일한 물리량을 복수의 센서로 측정할 때 그 측정값을 융합하는데 유용하다. 이 때 각 센서는 상보적인 특정을 가져야한다.<br>
-> 상보필터는 open-loop 구조이다.

### 수평 자세 측정
자이로 센서 : 자세각을 계산하고 단기간에는 정확하지만 시간이 지날수록 부정확해진다. -> 고주파<br>
가속도 센서 : 시간이 지나도 오차가 누적되지 않음 하지만 잡음이 유입되는 순간 오차가 커진다. -> 저주파<br>
<br>
아래 그림은 두 센서를 융합해서 row이나 pitch 각을 측정하는 알고리즘이다.<br>
![image](https://user-images.githubusercontent.com/42115807/86073829-8f110a80-babf-11ea-81cb-de0a16960005.png)<br>
먼저 가속도로 row(왼쪽)과 pitch(오른쪽)을 계산한다. 이 값은 나중에 자이로 자세각의 누적오차로 보정한다.<br>
![image](https://user-images.githubusercontent.com/42115807/86074085-24ac9a00-bac0-11ea-8171-06cda5279b6b.png)<br>
가속도 자세각과 자이로의 적분 자세각 사이의 오차를 구한 PI 제어기에 넣는다.그러면 출력으로 자이로 각속도 오차를 보정한다.<br>
각속도를 구했으면 적분해서 최종 자세각을 구할 수 있다.<br>
<br>
위 그림은 closed loop 구조이다. 이 구조에 대해 계산해보면<br>

1. 가속도계와 자이로의 자세각 오차(e)부터 계산<br>
![image](https://user-images.githubusercontent.com/42115807/86074431-e794d780-bac0-11ea-8426-26e7667f1bf2.png)<br>

2. 자이로의 자세각은 아래처럼 적분해준다.<br>
![image](https://user-images.githubusercontent.com/42115807/86074695-62f68900-bac1-11ea-8270-244c364b3c4a.png)<br>

3. 위 식을 양변에 s^2 곱해준다.<br>
![image](https://user-images.githubusercontent.com/42115807/86074827-a4873400-bac1-11ea-9aa1-cb76ea9241cf.png)<br>

4. 식을 정리하면<br>
![image](https://user-images.githubusercontent.com/42115807/86074925-c97ba700-bac1-11ea-9e97-8b44ee1ed107.png)<br>
![image](https://user-images.githubusercontent.com/42115807/86074940-d0a2b500-bac1-11ea-8f3e-d8404162d420.png)<br>

5. 상보적인 특성이 안 보이므로 최종 식을 약간 변형하면<br>
![image](https://user-images.githubusercontent.com/42115807/86075112-38f19680-bac2-11ea-8b28-95f0a587e747.png)<br>

6. 저주파 통과 필터(왼쪽), 고주파 통과 필터(오른쪽)을 정의할 수 있게 되었다.<br>
![image](https://user-images.githubusercontent.com/42115807/86075268-94bc1f80-bac2-11ea-8515-ded322c33c6a.png)
![image](https://user-images.githubusercontent.com/42115807/86075295-a998b300-bac2-11ea-97a1-b7fee66dd160.png)<br>

7. 정리<br>
![image](https://user-images.githubusercontent.com/42115807/86075336-c2a16400-bac2-11ea-95cb-872a7ef3eccc.png)<br>

#### 상보 필터 함수
이 함수는 각속도와 가속도를 입력 받아 오일러 각을 반환한다.<br>
수평 자세(row, pitch)는 상보 필터로 유용하지만 yaw 각은 단순히 각속도를 적분한 값이다. yaw 각까지 보상할려면 방위각을 측정하는 센서를 추가해야한다.<br>

- ComFilterWithPI.m

    function [phi, theta, psi] = ComFilterWithPI(p,q,r,ax,ay,dt)

    persistent p_hat q_hat
    persistent prevPhi prevTheta prevPsi

    if isempty(p_hat)
        p_hat = 0;
        q_hat = 0;
    
        prevPhi   = 0;
        prevTheta = 0;
        prevPsi   = 0;
    end

    [phi_a, theta_a] = EulerAccel(ax,ay);

    [dotPhi, dotTheta, dotPsi] = BodyToInertial(p,q,r,prevPhi,prevTheta);

    phi   = prevPhi + dt*(dotPhi - p_hat);
    theta = prevTheta + dt*(dotTheta - q_hat);
    psi   = prevPsi + dt*dotPsi;

    p_hat = PILawPhi(phi - phi_a);
    q_hat = PILawTheta(theta - theta_a);

    prevPhi   = phi;
    prevTheta = theta;
    prevPsi   = psi;

    end

    function [dotPhi,dotTheta, dotPsi] = BodyToInertial(p,q,r,phi,theta)
    % Bodyrate --> Euler angular rate
    %

    sinPhi   = sin(phi);   cosPhi   = cos(phi);
    cosTheta = cos(theta); tanTheta = tan(theta);

    dotPhi = p + q*sinPhi*tanTheta + r*cosPhi*tanTheta;
    dotTheta = q*cosPhi - r*sinPhi;
    dotPsi = q*sinPhi/cosTheta + r*cosPhi/cosTheta;

    end

아래는 자이로와 가속도 센서의 PI 제어기 함수다.<br>

- PILawPhi.m
    
    function p_hat = PILawPhi(delPhi)

    persistent prevP prevdelPhi

    if isempty(prevP)
        prevP = 0;
        prevdelPhi = 0;
    end

    p_hat = prevP + 0.1415*delPhi - 0.1414*prevdelPhi;

    prevP = p_hat;
    prevdelPhi = delPhi;

    end
    
- PILawTheta.m

    function q_hat = PILawTheta(delTheta)

    persistent prevQ prevdelTheta

    if isempty(prevQ)
        prevQ = 0;
        prevdelTheta = 0;
    end

    q_hat = prevQ + 0.1415*delTheta - 0.1414*prevdelTheta;

    prevQ = q_hat;
    prevdelTheta = delTheta;

    end

함수가 복잡한 이유는 적분기(1/s)를 수치적으로 구현하는 코드 때문이다. 아래 식은 PI 제어기 전달함수이다.<br>
![image](https://user-images.githubusercontent.com/42115807/86077096-56286400-bac6-11ea-92ed-ff26d727289b.png)<br>
여기서 Kp, Ki 값을 아래 사진처럼 선정하였다.<br>
![image](https://user-images.githubusercontent.com/42115807/86076820-ba96f380-bac5-11ea-9339-9f8a736148dd.png)<br>
MATLAB의 c2dm함수로 전달함수를 이산(discrete) 수식으로 변환하면 아래 식처럼 나온다.<br>
![image](https://user-images.githubusercontent.com/42115807/86076961-0cd81480-bac6-11ea-8c0e-8cd81bbeeffa.png)<br>
![image](https://user-images.githubusercontent.com/42115807/86076975-15c8e600-bac6-11ea-9565-f8d81cab9755.png)<br>
PI 제어기의 최종 계산식은<br>
![image](https://user-images.githubusercontent.com/42115807/86077240-94be1e80-bac6-11ea-9a28-2eebdd5ce317.png)
