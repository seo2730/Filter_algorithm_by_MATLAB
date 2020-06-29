clc
clear all

Nsamples = 500;
Xsaved   = zeros(Nsamples,1);
Xmsaved  = zeros(Nsamples,1);

for k=1:Nsamples
    zm = GetSonar();
    
    x = HPF(zm);
    
    Xsaved(k,:) = x;
    Xmsaved(k,:) = zm;
end

dt = 0.02;
t  = 0:dt:Nsamples*dt-dt;

figure
hold on
plot(t,Xmsaved,'r.') % 측정값
plot(t,Xmsaved-Xsaved,'b') % 측정값 - 잡음 = 참값
legend('Measured','Measured-HPF')