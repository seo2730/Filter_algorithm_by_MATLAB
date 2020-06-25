# Filter_algorithm_by_MATLAB
 This is filter algorithm code by MATLAB<br>
 매트랩으로 짠 필터 알고리즘 코드
 
# Average Filter(평균 필터)
평균 : 데이터 총합을 데이터 개수로 나눈 값 <br>
![image](https://user-images.githubusercontent.com/42115807/85668518-c8c9c600-b6f9-11ea-875c-f08099302bc1.png)<br>
배치식 : 위 사진처럼 데이터를 모두 모아서 한꺼번에 계산하는 식 -> 비효율 <br>
재귀식 : 이전 결과를 재사용하여 계산하는 식 -> 효율이 좋음 <br>
<br>
평균 필터에서는 재귀식이 이전 평균값과 추가된 데이터 그리고 데이터 개수만 저장하면 되기 때문에 메모리 저장공간 측면에서 효율적이다.<br>
<br>
평균필터를 재귀식으로 표현해보겠다. 아래식은 k-1개의 평균 계산식이다.<br>
![image](https://user-images.githubusercontent.com/42115807/85669929-522dc800-b6fb-11ea-84e8-6ab4a4b07160.png)<br>
배치식으로 표현한 k개 데이터가 있는 식 양변에 k를 곱한다<br>
![image](https://user-images.githubusercontent.com/42115807/85670483-e7c95780-b6fb-11ea-8500-2da92b90bc1f.png)<br>
위 식을 양변에 k-1로 나누면 아래 식처럼 된다.<br>
![image](https://user-images.githubusercontent.com/42115807/85670914-53132980-b6fc-11ea-8c3d-8bd96b05cc04.png)<br>
Xk만 따로 분리해서 우변을 두 개의 항으로 나눠보겠다.<br>
![image](https://user-images.githubusercontent.com/42115807/85671032-7342e880-b6fc-11ea-9cad-38053827541a.png)<br>
위 식을 보면 k-1개 평균 계산식이 표현된 것을 알 수 있다. 그럼 아래 식처럼 정리가 가능하다.<br>
![image](https://user-images.githubusercontent.com/42115807/85671328-ba30de00-b6fc-11ea-8e0e-a3bae12116de.png)<br>k-1
k/(k-1)로 나눈다. 그럼 최종적인 재귀식 평균 필터 식이 나온다.<br>
![image](https://user-images.githubusercontent.com/42115807/85671486-e0567e00-b6fc-11ea-88b3-56fbe61089fc.png)<br>
<br>

만약 a=(k-1)/k로 정의하면 a = 1 - 1/k이므로 아래 식처럼 표현된다.<br>
![image](https://user-images.githubusercontent.com/42115807/85672011-6bd00f00-b6fd-11ea-8341-d89d593268b5.png)<br>
a로 더 간결한 재귀식을 얻을 수 있다.<br>
![image](https://user-images.githubusercontent.com/42115807/85672159-90c48200-b6fd-11ea-9652-cb62e58ecc03.png)<br>
<br>
평균필터는 평균 계산 외에 센서 초기화에 유용하게 쓰인다.<br>

## code
    
    function avg = AvgFilter(x)
    %
    %
    persistent prevAvg k
    persistent firstRun


    if isempty(firstRun)
        k = 1;
        prevAvg = 0;
    
        firstRun = 1;
    end

    alpha = (k-1)/k;


    % 평균 필터 = (1-K)/K * 전 값들 평균 + 1/K * 현재 값 

    avg = alpha*prevAvg + (1-alpha)*x;

    prevAvg = avg;
    k = k+1;
    
prevAvg : 이전 평균값, k : 데이터 갯수, firstRun : 초기 시작인 것을 알려주는 변수<br>

# Moving Average Filter(이동 평균 필터)
평균의 단점 : 데이터의 동적인 변화는 모두 없애버리고 측정 데이터를 몽뚱그려 하나의 값만 내놓는다.<br>
-> 잡음을 없애는 동시에 시스템의 동적인 변화를 제대로 반영하는 방법 : 이동평균(Moving Average)<br>
<br>
이동평균 : 지정된 개수의 최근 측정값만 가지고 계산하는 평균<br>
-> 새로운 데이터가 들어오면 가장 오래된 데이터를 버리는 방식<br>
<br>
이동평균 식은 아래 식처럼 표현된다. 총 n개의 데이터로 고정되어 있다.<br>
![image](https://user-images.githubusercontent.com/42115807/85675621-d767ab80-b700-11ea-8154-ab215686c6e3.png)<br>
재귀식으로 표현하기 위해 이전 결과값도 아래 식에 표현할 수 있다.<br>
![image](https://user-images.githubusercontent.com/42115807/85675890-10a01b80-b701-11ea-9078-a53c4c167526.png)<br>
두 식 빼면 아래 식처럼 나온다.<br>
![image](https://user-images.githubusercontent.com/42115807/85676187-578e1100-b701-11ea-9540-28825fd57163.png)<br>
최종적으로 아래 식이 이동평균 필터 식이다.<br>
![image](https://user-images.githubusercontent.com/42115807/85676497-9d4ad980-b701-11ea-821f-6c95073a5e6f.png)<br>

## code
MovAvgFilter.m : 재귀식으로 짠 함수 MovAvgFilter2.m : 배치식으로 짠 함수 <br>

    function avg = MovAvgFilter(x)
    % 이동평균은 오래된 값은 버리고 최신 값은 넣어줘야한다.
    % FIFO 방식
    persistent prevAvg n xbuf
    persistent firstRun

    if isempty(firstRun)
        n = 10;                 % 갯수는 고정
        xbuf = x*ones(n+1,1);   % 초기화
    
        k=1;
        prevAvg = x;
    
        firstRun=1;
    end

    % 오래된 값 버리기
    for m=1:n
        xbuf(m) = xbuf(m+1);
    end

    % 최신 값 넣어주기
    xbuf(n+1) = x;

    % 이동평균 = 전 값들 평균 + (현재 값 - 오래된 값)/n
    avg = prevAvg + (x-xbuf(1))/n;

    prevAvg = avg;
    
n : 평균을 내는 데이터 갯수<br>
보통 내부 버퍼의 초기값을 0으로 지정 하지만 여기서는 처음 입력되는 측정 데이터로 내부 버퍼를 초기화함<br>
-> 0으로 초기화하는 것보다는 초기 오차를 줄일 수 있다.<br>
<br>
## 이동평균 고려사항
시간 지연이 있다. 만약 시간 지연이 너무 크다면 데이터 개수(n)를 줄여야한다. 대신 측정 잡음을 제거하는 성능은 떨어지게 된다.<br>
반대로 데이터 갯수를 늘리면 잡음 제거 성능은 개선되지만 시간 지연이 커져 측정 데이터의 변화가 실시간을 잘 반영되지 않는다.<br>
이동평균을 만들 때 데이터 갯수를 잘 선정해야한다.<br>

## 이동평균의 한계
![image](https://user-images.githubusercontent.com/42115807/85679902-ca4cbb80-b704-11ea-94cb-cd94f4e5a4e8.png)<br>
이동평균 필터를 별도의 항으로 풀어쓴 식이다.<br>
이 식을 보면 이동 평균은 모든 데이터에 동일한 가중치 1/n를 부여한다. 즉 이동평균은 모든 측정값에 동일한 가중치를 주고 처리한다.<br>
<br>

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
평균 필터와 비슷하지만 평균과 다르게 갯수가 정해져 있지 않아서 a를 임의로 결정할 수 있다. 여기서는 추정값이라고 하겠다.<br>

아래 식들은 가중치가 적용되었는지 보여주는 증명이다.<br>
![image](https://user-images.githubusercontent.com/42115807/85681755-92467800-b706-11ea-943c-3ef1753cf385.png)<br>
위 식을 앞에 있는 식에 대입하면 아래처럼 나온다<br>
![image](https://user-images.githubusercontent.com/42115807/85692554-76e06a80-b710-11ea-9b60-9f22dec03ece.png)<br>
a(1-a)와 1-a 크기를 비교할 때 0<a<1 이므로 a(1-a) < 1-a이다. 즉 최근 추정값이 이전 추정값보다 더 큰 가중치로 반영되었다.<br>
-> 이전 측정 데이터일수록 더 작은 계수가 곱해진다는 사실을 알 수 있다.<br>
-> 잡음제거와 변화 민감성이라는 상충되는 요구를 이동평균 필터보다 잘 충족한다.
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

# Kalman Filter(칼만필터)
## 칼만필터 알고리즘
![image](https://user-images.githubusercontent.com/42115807/85696258-bceafd80-b713-11ea-8b2a-8a8a7ecebfb1.png)<br>
k : 칼만 필터 알고리즘이 반복해서 수행된다는 점을 명시하기 위해 붙임<br>
윗첨자 '-' : 이름이 같더라도 전혀 다른 변수를 의미 -> 예측값 의미<br>
<br>
### 1. 1단계 : 예측단계
2단계~4단계에서 사용한 두 변수 X^-k, P-k를 계산한다.(윗첨자 '-' : 예측값을 의미)<br>
예측 단계의 계산식은 시스템 모델과 밀접하게 관련되어 있다.<br>
### 2. 2단계 : 칼만 이득 계산
변수 P-k는 앞 단계에서 계산한 값을 사용한다.<br>
H 와 R은 칼만 필터 알고리즘 밖에서 미리 결정하는 값이다.<br>
### 3. 3단계 : 추정값 계산
입력된 측정값으로 추정값을 계산한다.<br>
저주파 통과 필터와 관련있다.<br>
X^-k는 1단계에서 계산한 값이다.<br>
### 4. 오차 공분산 계산
오차 공분산은 추정값이 얼마나 정확한지를 알려주는 척도이다.<br>
보통 오차 공분산을 검토해서 앞서 계산한 추정값을 믿고 쓸지 아니면 버릴지를 판단한다.<br>
<br>

아래 사진은 칼만 필터 알고리즘의 변수들을 용도별로 구분해둔 표이다.
![image](https://user-images.githubusercontent.com/42115807/85733725-61326b80-b737-11ea-92e0-90801d8f5c8b.png)<br>
A, H, Q, R은 칼만 필터를 사용하는 대상 시스템 모델링할 때 쓰이는 변수다.<br>
-> 대상 시스템의 모델링에 따라 값이 다르다.<br>
-> 시스템 모델이 실제 시스템과 가까울수록 좋다.<br>
-> 나머지 변수들은 측정되거나 알고리즘에서 계산한 값이므로 임의로 변경할 수 없다.<br>
-> A와 Q : 예측 과정에서 사용되는 시스템 모델 변수 -> 최종 결과 : X^-k, P-k<br>
-> H와 R : 추정 과정에서 사용되는 시스템 모델 변수 -> 최종 결과 : X^k, Pk<br>
<br>
### 이론 정리
1. 시스템 모델(A,Q)을 기초로 다음 시각에 상태와 오차 공분산이 어떤 값이 될지를 예측한다 : X^-k, P-k<br>
2. 측정값과 예측값의 차이를 보상해서 새로운 추정값을 계산한다. 이 추정값이 칼만 필터의 최종 결과물이다 : X^k, Pk<br>
3. 위 두 과정을 반복한다.<br>

## 추정 과정

## 예측 과정

## 시스템 모델
