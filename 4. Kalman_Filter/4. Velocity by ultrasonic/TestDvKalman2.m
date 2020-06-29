clc 
clear all

Nsamples = 500;

Xsaved = zeros(Nsamples,2);
Zsaved = zeros(Nsamples,1);

for k=1:Nsamples
    z = GetSonar();
    [pos, vel] = DvKalman(z);
    
    Xsaved(k,:) = [pos, vel];
    Zsaved(k) = z;
end

dt = 0.02;
t = 0:dt:Nsamples*dt-dt;

figure
plot(t,Xsaved(:,1),'r')
hold on
plot(t,Zsaved,'b.')
legend('Kalman','Pos')
plot(t,Xsaved(:,2),'g--')