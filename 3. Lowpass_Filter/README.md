# Lowpass Filter(저주파 필터)
저주파 필터 :  저주파 신호는 통과시키고 고주파 신호는 걸러내는 필터<br>
-> 잡음 제거용으로 많이 쓰임.<br>
-> 대부분 측정할려는 신호는 저주파이고 잡음은 고주파 성분으로 이루어져 있음.<br>
<br>

## 1차 저주파 통과 필터
최근 측정값에는 높은 가중치를 두고 오래된 값일수록 가중치 낮게 주면 된다. 1차 저주파 통과 필터로 가능하다. 아래 사진이 관련 식이다.<br>
![image](https://user-images.githubusercontent.com/42115807/85680871-a8a00400-b705-11ea-8e44-b1c026040faa.png)
![image](https://user-images.githubusercontent.com/42115807/85680926-b786b680-b705-11ea-8acc-d85378612bd4.png)
<br>
평균 필터와 비슷하지만 평균과 다르게 갯수가 정해져 있지 않아서 a를 임의로 결정할 수 있다. 여기서는 **추정값**이라고 하겠다.<br>

아래 식들은 가중치가 적용되었는지 보여주는 증명이다.<br>
![image](https://user-images.githubusercontent.com/42115807/85681755-92467800-b706-11ea-943c-3ef1753cf385.png)<br>
위 식을 앞에 있는 식에 대입하면 아래처럼 나온다<br>
![image](https://user-images.githubusercontent.com/42115807/85692554-76e06a80-b710-11ea-9b60-9f22dec03ece.png)<br>
a(1-a)와 1-a 크기를 비교할 때 0<a<1 이므로 a(1-a) < 1-a이다. 즉 최근 추정값이 이전 추정값보다 더 큰 가중치로 반영되었다.<br>
-> 이전 측정 데이터일수록 더 작은 계수가 곱해진다는 사실을 알 수 있다.<br>
-> **잡음제거**와 **변화 민감성**이라는 상충되는 요구를 이동평균 필터보다 잘 충족한다.
<br>
## code
    function xlpf = LPF(x)
    %
    %
    persistent prevX
    persistent firstRun

    if isempty(firstRun)
        prevX = x; % 오차를 줄이기 위해
        firstRun = 1;
    end

    % 0 < alpha < 0.7
    alpha = 0.7;

    % 현재 최신값에 가중치를 더 크게 줘야한다.
    % alpha가 작으면 추정값에 잡음이 더 나타난다.
    % alpha가 크면 직전 추정값의 비중이 더 커서 잡음이 줄어들고 변화가 무뎌진다.
    xlpf = alpha*prevX+(1-alpha)*x;

    prevX = xlpf;
<br>
