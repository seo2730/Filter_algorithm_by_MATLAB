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
**시간 지연이 있다.** 만약 시간 지연이 너무 크다면 데이터 개수(n)를 줄여야한다. 대신 측정 잡음을 제거하는 성능은 떨어지게 된다.<br>
반대로 데이터 갯수를 늘리면 잡음 제거 성능은 개선되지만 시간 지연이 커져 측정 데이터의 변화가 실시간을 잘 반영되지 않는다.<br>
이동평균을 만들 때 데이터 갯수를 잘 선정해야한다.<br>

## 이동평균의 한계
![image](https://user-images.githubusercontent.com/42115807/85679902-ca4cbb80-b704-11ea-94cb-cd94f4e5a4e8.png)<br>
이동평균 필터를 별도의 항으로 풀어쓴 식이다.<br>
이 식을 보면 이동 평균은 모든 데이터에 동일한 가중치 1/n를 부여한다. 즉 이동평균은 모든 측정값에 **동일한 가중치**를 주고 처리한다.<br>
<br>
