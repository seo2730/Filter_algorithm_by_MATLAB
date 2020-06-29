# 칼만 응용

## High Pass Filter(고주파 통과 필터)
저주파 통과 필터와는 반대로 입력 신호에서 저주파 성분은 걸러내고 고주파 성분만 통과시키는 필터<br>
즉 측정 신호와 잡음이 섞인 입력이 들어오면 측정 신호는 걸러지고 잡음만 출력된다.<br>
-> 대표적인 분야 : 제어분야<br>
-> 어떤 장치를 제어할 때 측정 신호 탓인지 잡음 탓인지 모르므로 두 입력을 구별할 때 고주파 필터가 유용하다.<br>
<br>
이처럼 입력 주파수의 특성에 따라 제어기의 작동 여부를 나누고 싶을 때 고주파 통과 필터가 유용하게 쓰인다.<br>
참고 : 고주파 필터를 이해할려면 라플라스 변환(Laplace Transform)을 알아야한다.<br>
<br>

- 전달함수(transer function)
![image](https://user-images.githubusercontent.com/42115807/86015824-06618280-ba5d-11ea-9ecf-a4f5489fa07d.png)<br>
<img width="111" alt="스크린샷 2020-06-29 오후 8 37 33" src="https://user-images.githubusercontent.com/42115807/86000361-6ef23480-ba48-11ea-820b-bb1ecd0eef87.png">
-> s가 0에 가까워지면 전달함수도 0으로 수렴한다. 즉 주파수가 낮으면 입력 신호가 통과하지 못한다.<br>
-> s가 무한대면 전달함수가 1로 수렴한다. 즉 주파수가 높으면 입력 신호 그대로 통과한다.<br>
-> 즉 고주파 필터이다.<br>
<br>
우변에서 분자와 분모를 a로 나누면 (ㅜ=1/a)<br>

![image](https://user-images.githubusercontent.com/42115807/86015469-93f0a280-ba5c-11ea-97f7-09e85bb16d18.png)<br>
G를 Y/U로 바꿔서 양변을 정리하면<br>

![image](https://user-images.githubusercontent.com/42115807/86016109-5e988480-ba5d-11ea-84ac-1a5eb68ab14b.png)<br>
양변에 라플라스 역변환을 취하면<br>

![image](https://user-images.githubusercontent.com/42115807/86016330-9f909900-ba5d-11ea-8a84-2e18a0cdd59a.png)<br>

연속 시간(continuous)에서 이산 시간(discrete)으로 바꾸면<br>
![image](https://user-images.githubusercontent.com/42115807/86016566-e4b4cb00-ba5d-11ea-9bec-59bb51f091b2.png)<br>

시간의 변화량(t)를 곱하고 정리하면 아래 식이 고주파 통과필터이다.<br>

![image](https://user-images.githubusercontent.com/42115807/86016730-23e31c00-ba5e-11ea-8f9e-cee8d00eb1a0.png)<br>

#### 고주파 통과 필터 함수

    function xhpf = HPF(u)

    persistent prevX
    persistent prevU
    persistent dt tau
    persistent firstRun

    if isempty(firstRun)
        prevX = 0;
        prevU = 0;
        dt = 0.01;
        tau = 0.0233;
    
        firstRun = 1;
    end

    alpha = tau/(tau+dt);
    xhpf = alpha*prevX + alpha*(u-prevU);

    prevX = xhpf;
    prevU = u;

    end

#### 저주파 식과 비교
- 저주파 필터 전달함수

![image](https://user-images.githubusercontent.com/42115807/86018339-2e9eb080-ba60-11ea-967b-b4599eeee295.png)<br>
-> 전달함수가 0으로 수렴하면 필터의 출력도 1로 수렴한다. 즉 주파수가 낮으면 입력 신호가 필터 그대로 통과한다.<br>
-> 전달함수가 무한대면 필터의 출력은 0으로 수렴한다. 즉 주파수가 높으면 입력 신호가 필터를 통과하지 못한다.<br>
즉 저주파 필터라는 것을 알 수 있다.<br>
<br>
우변에서 분자와 분모를 a로 나누면 (ㅜ=1/a)<br>

![image](https://user-images.githubusercontent.com/42115807/86018982-ff3c7380-ba60-11ea-9972-d02a879586ed.png)<br>
G를 Y/U로 바꿔서 양변을 정리하면<br>

![image](https://user-images.githubusercontent.com/42115807/86019055-15e2ca80-ba61-11ea-89ea-557f248f87a2.png)<br>
양변에 라플라스 역변환을 취하면<br>

![image](https://user-images.githubusercontent.com/42115807/86019168-3b6fd400-ba61-11ea-96f9-9c5716f77e7f.png)<br>
연속 시간(continuous)에서 이산 시간(discrete)으로 바꾸면<br>

![image](https://user-images.githubusercontent.com/42115807/86019600-c3ee7480-ba61-11ea-8a09-305d5b552646.png)<br>
이 식들을 풀면<br>

![image](https://user-images.githubusercontent.com/42115807/86019747-f26c4f80-ba61-11ea-9d2a-ac186999ecd5.png)<br>
이 식을 통해 a는 아래 관계를 만족한다.<br>

![image](https://user-images.githubusercontent.com/42115807/86019822-116ae180-ba62-11ea-82f9-4fd759ad9e45.png)<br>
a는 앞서 단순한 가중치로만 이해했지만 식을 풀면 더 복잡한 의미가 담겨져 있다.<br>
즉 시스템의 주파수 특성과 필터의 요구 성능을 고려해 a를 선정한다.<br>
<br>
주파수 필터를 개발할 때는 **라플라스 변환**을 이용해 주파수 영역에서 설계하고 분석하는게 바람직하다.<br>
실제 구현을 위한 이산 시간 수식은 라플라스 역변환을 통해 유도하거나 MATLAB 같은 도구를 이용해 수치적으로 구해야한다.
