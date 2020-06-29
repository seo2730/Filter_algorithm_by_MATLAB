clc
clear all

dt = 0.2;
t = 0:dt:10;

Nsamples = length(t);

Xsaved = zeros(Nsamples,3); % 행렬 선언 -> 배열
Zsaved = zeros(Nsamples,1); % 행렬 선언 -> 배열

for k=1:Nsamples
    z = GetVolt(); % 측정된 값
    [volt,Cov,Kg] =  SimpleKalman2(z); % 칼만 
    
    Xsaved(k, :) = [volt,Cov,Kg];
    Zsaved(k) = z; % 측정된 전압
end

figure
plot(t,Xsaved(:,1),'r:o');
hold on
plot(t,Zsaved,'b:*')
xlabel('Time[sec]')
ylabel('Voltage[V]')
legend('Kalman Filter','Measured')

figure
plot(t,Xsaved(:,2),'r:o');
xlabel('Time[sec]')
ylabel('P')

figure
plot(t,Xsaved(:,3),'r:o');
xlabel('Time[sec]')
ylabel('K')
