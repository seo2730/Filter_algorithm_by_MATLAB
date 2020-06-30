# 칼만 응용

## 수평 자세 측정
위치와 자세를 측정하는 방버은 가속도계와 자이로스코프를 이용하는 것이다.<br>
이 두 개의 센서는 수평 자세를 측정하는 모든 시스템에 적용이 가능하다.<br>

### 예제
> 가속도계와 자이로를 이용해 헬기가 수평면에 대해 앞뒤와 좌우로 기울어진 각도를 찾아보자

수평 자세에만 관심이 있으므로 세 개의 각도 중에서 row와 pitch 각도만 찾으면 된다.<br>
(오일러 각(Euler angle) : row, pitch, yaw)<br>
<br>
#### 자이로를 이용한 자세 결정
자이로 : 오일러각의 변화율이 아닌 **각속도(p,q,r)** 를 측정한다.<br>
-> 자이로의 측정값을 적분해야한다.<br>

- 오일러각과 각속도 동역학 관계
![image](https://user-images.githubusercontent.com/42115807/86082379-8c6be080-bad2-11ea-9575-f92b12046f01.png)<br>
위 식을 이용해 EulerGyro.m 코드로 자이로에서 측정한 각속도와 샘플링 시간을 인자로 받아 오일러각을 반환하다.<br>

    function [phi, theta, psi] = EulerGyro(p,q,r,dt)

    persistent prevPhi prevTheta prevPsi % ÃøÁ¤°ª

    if isempty(prevPhi)
        prevPhi   = 0;
        prevTheta = 0;
        prevPsi   = 0;
    end

    sinPhi    = sin(prevPhi);   cosPhi   = cos(prevPhi);
    cosTheta = cos(prevTheta); tanTheta = tan(prevTheta);

    phi   = prevPhi + dt*(p+q*sinPhi*tanTheta+r*cosPhi*tanTheta);
    theta = prevTheta + dt*(q*cosPhi-r*sinPhi);
    psi = prevPsi + dt*(q*sinPhi/cosTheta + r*cosPhi/cosTheta);

    prevPhi = phi;
    prevTheta = theta;
    prevPsi = psi;

    end

초기 값을 알고 있다는 가정하에 (p,q,r)를 대입하여 적분하면 현재의 자세를 구할 수 있지만 적분하면 자세에서 오차가 누적된다.<br>
-> 이 방법은 센서가 아주 정밀하거나 운용 시간이 짧지 않으면 실제로 사용하기 어렵다.<br>
<br>
정리 : 자이로는 단기간 측정은 비교적 정확하지만 장신간의 변화에는 오차 누적에 인해 부정확한 센서가 된다.<br>
<br>
#### 가속도를 이용한 자세 결정
가속도 센서에서 측정한 가속도(fx,fy,fz)에 중력 가속도와 속도의 크기나 방향이 바뀔 때 생기는 가속도 등 다양한 종류의 가속도가 있다.
![image](https://user-images.githubusercontent.com/42115807/86083184-84ad3b80-bad4-11ea-9fd8-c0776d621e1a.png)<br>
u,v,w : 이동 속도<br>
p,q,r : 회전 각속도<br>
g : 중력 가속도<br>
<br>
가속도와 각속도는 측정값이고 알고 있고 중력 가속도도 마찬가지로 알고 있다. 그럼 남은 것은 이동 속도와 이동 가속도뿐인데 이 두 값은 아주 고가의 항법센서가 아니면 측정불가이다.<br> 
>만약 시스템이 정지해 있거나 일정한 속도로 직진하는 조건(가속도=0)라는 조건이면 아래 사진처럼 간단한 형태가 된다.<br>

![image](https://user-images.githubusercontent.com/42115807/86083828-3e58dc00-bad6-11ea-9846-ed321076c160.png)<br>
그럼 이 식에서 row와 pitch 각 공식을 유도할 수 있다.<br>
![image](https://user-images.githubusercontent.com/42115807/86083914-76f8b580-bad6-11ea-83fc-75fb761c8cda.png)<br>
움직이는 속도가 충분히 느리거나 속도의 크기와 방향이 빠르게 변하지 않는 경우에 위 식으로 수평 자세를 구할 수 있다.<br>
-> 근사식이다. -> 빠른 속도로 회전하거나 속도 변화 심하면 오차가 커질 수 있다.<br>
위 식을 이용한 EulerAccel.m 코드다.<br>

    function [phi theta] = EulerAccel(ax,ay)

    g = 9.81;

    theta = asin(ax/g);
    phi = asin(-ay/(g*cos(theta)));

    end

자이로와 달리 기동이 끝나면 다시 0으로 정확히 돌아온다. 즉 오차가 누적되지 않는다.<br>
하지만 실제 값을 측정하지 못해 오차가 상당히 커서 가속도 센서 단독으로 사용하기 힘들다.<br>
<br>
정리 : 가속도 센서는 오차가 발산하지 않고 일정한 범위 안에 머무르는(안정성) 장점이 있지만 정말도가 떨어지는 단점이 있다.(가속도와 각속도가 충분히 작은 상황인 경우)<br> 

#### 센서 융합으로 자세 결정
단기적으로 자이로 센서가 낫고 장기적으로는 가속도 센서가 더 낫다 -> 상호 보완관계<br>
**센서 융합** : 여러 센서 출력을 모아서 더 좋은 성능을 끌어내는 기법<br>
-> 센서 구성이 나쁘면 시너지 효과를 기대하기 어렵다.<br>
-> 상호 보완이 되는 센서끼리 묶는 것이 중요하다.<br>
-> 최종 출력은 각 센서의 장점만 담아야한다.<br>
<br>
가속도, 자이로 센서 융합 구성도
![image](https://user-images.githubusercontent.com/42115807/86085299-c4c2ed00-bad9-11ea-8bdd-1a66795d2734.png)<br>

#### 시스템 모델
오일러각은 문제가 많으므로 쿼터니언(Quantemion)으로 상태변수로 잡겠다.<br>
![image](https://user-images.githubusercontent.com/42115807/86085569-6ea27980-bada-11ea-9ad4-15c3431a2703.png)
->![image](https://user-images.githubusercontent.com/42115807/86085613-81b54980-bada-11ea-8872-ed418294a2fc.png)
