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

# Lowpass Filter(저주파 필터)


# Kalman Filter(칼만필터)

