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

- 오일러각과 각속도 동역학 관계<br>
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
![image](https://user-images.githubusercontent.com/42115807/86085569-6ea27980-bada-11ea-9ad4-15c3431a2703.png)<br>
![image](https://user-images.githubusercontent.com/42115807/86425682-c500f980-bd20-11ea-9e28-1b2107821382.png)<br>
위 식을 이산(discrete) 시스템으로 바꾸면<br>
![image](https://user-images.githubusercontent.com/42115807/86425697-cfbb8e80-bd20-11ea-862a-eb107ae80908.png)<br>
아래 식은 오일러 각을 쿼터니언으로 바꾸는 공식이다.<br>
![image](https://user-images.githubusercontent.com/42115807/86425725-de09aa80-bd20-11ea-9275-f95822383701.png)<br>
이 쿼터니언이 칼만필터의 측정값에 해당된다. 행렬 H는 단위행렬이 된다.<br>

#### 센서 융합 칼만 필터
쿼터니언은 물리적인 의미가 없기 때문에 추정 결과는 오일러 각으로 출력하는게 더 낫다.<br>
잡음의 공분산 행렬 Q와 R은 시스템의 신호 특성과 관련 있는 값으로 이론적으로 구하기 어렵고 실제 데이터를 분석해봐야한다.<br>

- EulerKalman.m
    
      function [phi, theta, psi] = EulerKalman(A,z)

      persistent H Q R
      persistent x P
      persistent firstRun
  
      if isempty(firstRun)
          H = eye(4);
    
          Q = 0.0001*eye(4);
          R = 10*eye(4);
      
          x = [1 0 0 0]';
          P = 1*eye(4);
    
          firstRun = 1; 
      end

      xp = A*x;
      Pp = A*P*A' + Q;

      K = Pp*H'*(H*Pp*H'+R)^-1;

      x = xp + K*(z - H*xp); % x = [q1, q2, q3, q4]
      P = Pp - K*H*Pp;

      phi = atan2( 2*(x(3)*x(4) + x(1)*x(2)) , 1-2*(x(2)^2 + x(3)^2) );
      theta = -asin( 2*(x(2)*x(4) - x(1)*x(3)) );
      psi = atan2( 2*(x(2)*x(3) + x(1)*x(4)), 1-2*(x(3)^2 + x(4)^2) );

      end
    
- EulerToQuaternion.m

      function z = EulerToQuaternion(phi,theta,psi)

      sinPhi   = sin(phi/2);   cosPhi   = cos(phi/2);
      sinTheta = sin(theta/2); cosTheta = cos(theta/2);
      sinPsi   = sin(psi/2);   cosPsi   = cos(psi/2);

      z = [cosPhi*cosTheta*cosPsi + sinPhi*sinTheta*sinPsi;
           sinPhi*cosTheta*cosPsi - cosPhi*sinTheta*sinPsi;
           cosPhi*sinTheta*cosPsi + sinPhi*cosTheta*sinPsi;
           cosPhi*cosTheta*sinPsi + sinPhi*sinTheta*cosPsi];
 
      end

일반적인 센서 융합 문제에서 시스템 모델이 칼만 필터가 요구하는 선형 시스템 모델로 표현되는 경우는 드물다.<br>
자이로와 가속도 융합이 특별한 경우다.

#### 사원수(쿼터니언)
: 복소수를 확장해 만든 수체계<br>
**a + bi + cj + dk**(a : 실수부 b,c,d : 허수부 및 벡터부)<br>
<br>
i^2 = j^2 = k^2 = ijk =-1<br>
ijk = -1로 통해 아래 식들이 성립한다.<br>
    
    ij = k
    ji = -k
    jk = i
    kj = -i
    ki = j
    ik = -j
    
<br>
두 사원수 w = w0 + w1i + w2j + w3k와 z = z0 + z1i + z2j + z3k에 대해 곱셈 wz는 다음과 같다.<br>

>wz = (Sw,Vw)(Sz,Vz) = Sw*Sz ㅡ Vw*Vz + Sw*Vz + Sz*Vw + Vw x Vz (S : 실수부, V : 벡터부)<br>

>wz = (w0 + w1i + w2j + w3k)(z0 + z1i + z2j + z3k)<br>
    = w0*z0 ㅡ  (w1*z1 + x2*z2 + w3*z3) + (w0*z1 + w1*z0 + w2*z3 - w3*z2)i + (w0*z2 + w2*z0 + w3*z1 - w1*z3)j + (w0*z3 + w3*z0 + w1*z2 - w2*z1)k<br>
    = w0*z0 ㅡ (w.z) + w0*[z] + z0*[w] + [w2*z3 - w3*z2; w3*z1 - w1*z3; w1*z2 - w2*z1]<br>
    = w0*z0 ㅡ (Vm.Vz) + w0*Vz + z0 * Vm + Vm x Vz (. : 내적, x : 외적)<br>
    
사원수 곱셈을 이용하여 다음과 같은 간단한 정리를 이끌어 낼 수 있다.<br>

>wz - zw = Sw*Sz ㅡ Vw.Vz + Sw*Vz + Sz*Vw + Vw x Vz ㅡ (Sz*Sw ㅡ Vz.Vw + Sz*Vw + Sw*Vz + Vz x Vw)<br>
         = (Vw x Vz) ㅡ (Vz x Vw)<br>
         = 2*(Vw x Vz)<br>
   
위 식은 **[w,z] = wz - zw**로 쓰기도 한다.<br>
<br>
사원수의 실수부가 0인 경우르 pure quaternion이라 한다.<br>
사원수 w,z가 pure quaternion이라 할 때<br>

>wz + zw = Sw*Sz ㅡ Vw*Vz + Sw*Vz + Sz*Vw + Vw x Vz + (Sz*Sw ㅡ Vz*Vw + Sz*Vw + Sw*Vz + Vz x Vw)<br>
         = -2*(Vw.Vz) + (Vw x Vz) + (Vz + Vw)<br>
         = -2*(Vw.Vz)<br>
<br>
복소수에 대응하는 켤레 복소수를 곱하면 복소수의 크기의 제곱을 얻는다.<br>
q = q0 + q1i + q2j + q3k -> q* = q0 - q1i - q2j - q3k<br>
qq* = (q0 + q1i + q2j + q3k)(q0 - q1i - q2j - q3k) = q0^2 + q1^2 + q2^2 + q3^2 = q의 크기 제곱(|q|^2)<br>
<br>
사원수 q의 크기 |q|가 1일 때 사원수 q를 **단위 사원수** 라고 한다.
->q* = q^-1<br>
<br>
#### 오일러 각과 사원수
w = w0 + w1i + w2j + w3k가 단위 사원수라 할 때 w^2 = w0^2 + w1^2 + w2^2 + w3^2 = 1이므로 -1<=w0<=1이다.<br>
-> **w0 = cosθ** 로 쓸 수 있다.<br>
<br>
w = cosθ + v(v = w1i + w2j + w3k)라 쓸 때 다음이 성립한다.<br>
|w|^2 = cosθ^2 + |v|^2 = 1<br>
-> |v|^2 = 1 - cosθ^2 = sinθ^2<br>
<br>
w의 벡터부 v를 |v|u라 할 때(u는 v와 방향이 같은 단위 벡터) 아래 식을 유도할 수 있다.<br>
v = u * sinθ<br>
<br>
따라서 w = cosθ + v를 다음과 같이 오일러 각에 대한 표현을 바꿀 수 있다.<br>
w = cosθ + u * sinθ = e^θ*u

#### 쿼터니언 회전
![image](https://user-images.githubusercontent.com/42115807/86202648-cd7cf700-bb9d-11ea-9e7d-d3601a2c3f98.png)<br>
![image](https://user-images.githubusercontent.com/42115807/86202661-da014f80-bb9d-11ea-9177-662fd38b4c18.png)<br>
![image](https://user-images.githubusercontent.com/42115807/86202724-0d43de80-bb9e-11ea-8271-728ae4bd1aa3.png)<br>
![image](https://user-images.githubusercontent.com/42115807/86202759-251b6280-bb9e-11ea-80be-6e177bc94b20.png)<br>
![image](https://user-images.githubusercontent.com/42115807/86202791-37959c00-bb9e-11ea-9c3e-ed62c9569b95.png)<br>
정리한 문서을 토대로 식을 전개하면 최종적으로 아래 공식이 나온다.(잘못되었음 고칠 예정)<br>
![image](https://user-images.githubusercontent.com/42115807/86425682-c500f980-bd20-11ea-9e28-1b2107821382.png)<br>
