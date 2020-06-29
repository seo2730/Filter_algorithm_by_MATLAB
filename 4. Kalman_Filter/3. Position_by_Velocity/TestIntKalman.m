clc
clear all

dt = 0.1;
t = 1:dt:10;

Nsamples = length(t);

Xsaved = zeros(Nsamples,2);
Zsaved = zeros(Nsamples,2);

for k=1:Nsamples
    [z, pos_t] = GetVel();
    [pos, vel] = IntKalman(z);
    
    Xsaved(k,:) = [pos, vel];
    Zsaved(k,:) = [z, pos_t];
end

figure
plot(t,Xsaved(:,1),'r')
hold on
plot(t,Zsaved(:,2),'b.')
legend('Kalman','Pos')

figure
plot(t,Xsaved(:,2),'b')
hold on
plot(t,Zsaved(:,1),'g--')
legend('Kalman','Vel')