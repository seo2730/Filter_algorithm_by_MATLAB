clc
clear all

dt = 0.2;
t = 0:dt:10;

Nsamples = length(t);

Xsaved = zeros(Nsamples,1); % 행렬 선언 -> 배열
Zsaved = zeros(Nsamples,1); % 행렬 선언 -> 배열

for k=1:Nsamples
    z = GetVolt(); % 측정된 값
    volt = SimpleKalman(z); % 칼만 
    
    Xsaved(k) = volt; % 칼만을 씌운 전압
    Zsaved(k) = z; % 측정된 전압
end

figure
plot(t,Xsaved,'r:o');
hold on
plot(t,Zsaved,'b:*')
legend('Kalman Filter','Measured')