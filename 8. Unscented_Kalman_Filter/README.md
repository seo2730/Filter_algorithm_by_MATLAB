# Unscented Kalman Filter
EKF(Extended Kalman Filter) 전략과 다름 -> 선형화 과정을 생략함<br>
즉 자코비안으로 구한 선형 모델 때문에 불안정해지는 문제에서 자유로움<br>
BUT 구현하기는 더 복잡함.<br>
<br>
전반적인 틀은 유효함<br>
-> 시스템 모델을 기반으로 상태변수를 예측하고 측정값으로 예측값을 보정해서 최종 추정값 구해내는 것.<br>
<br>

### Unscented 변환 알고리즘
Unscented 변환 목표 : x에 대해 임의의 함수 f(x)의 평균과 공분산을 구하는 것.<br>
![image](https://user-images.githubusercontent.com/42115807/110307550-5e1ba900-8042-11eb-9de2-2777a99ec562.png)<br>
<br>
그 다음 시그마 포인트와 가중치를 정해줘야한다. 아래가 관련 공식이다.<br>
![image](https://user-images.githubusercontent.com/42115807/110308966-1f86ee00-8044-11eb-876d-4f7ee35bb605.png)<br>
총 n개 데이터를 쓰므로 1~n+1, n+1~2n+1 이렇게 쓰이므로 총 2n+1 데이터로 부풀려서 쓰인다.<br>
여기서 u를 구하는 방법은 u 요소들로 이루어진 U 행렬이 아래와 같은 조건이 성립하면 된다.<br>
![image](https://user-images.githubusercontent.com/42115807/110309438-ae940600-8044-11eb-8cca-16e0b7b0e4ec.png)<br>
그러면 시그마 포인트의 가중 평균과 가중 공분산은 아래와 같다.<br>
![image](https://user-images.githubusercontent.com/42115807/110309711-07639e80-8045-11eb-9a60-80c2d41dd345.png)<br>
<br>
이 식들을 통해 알 수 있는 점은 무수히 많은 샘플들을 동원하지 않아도 2n+1개의 시그마 포인트와 가중치만 있으면 x의 평균과 공분산을 구할 수 있다.![image](https://user-images.githubusercontent.com/42115807/110309711-07639e80-8045-11eb-9a60-80c2d41dd345.png)<br>





![image](https://user-images.githubusercontent.com/42115807/110308372-60323780-8043-11eb-9753-f79e75fb7c0e.png)<br>
