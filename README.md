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

# Moving Average Filter(이동 평균 필터)

# Lowpass Filter(저주파 필터)

# Kalman Filter(칼만필터)

