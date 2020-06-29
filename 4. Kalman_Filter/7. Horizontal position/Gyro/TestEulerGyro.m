clc
clear all

Nsamples = 41500;
Eulersaved = zeros(Nsamples,3);

dt = 0.01;

for k = 1:Nsamples
    [p, q, r] = GetGyro();
    [phi, theta, psi] = EulerGyro(p,q,r,dt);
    
    EulerSaved(k,:) = [phi, theta, psi];
end

PhiSaved = EulerSaved(:,1) * 180/pi;
ThetaSaved = EulerSaved(:,2) * 180/pi;
PsiSaved = EulerSaved(:,3) * 180/pi;

t = 0:dt:Nsamples*dt-dt;

figure
plot(t,PhiSaved)
xlabel('Timep[sec]')
ylabel('Roll angle(deg)')

figure
plot(t,ThetaSaved)
xlabel('Timep[sec]')
ylabel('Pitch angle(deg)')

figure
plot(t,PsiSaved)
xlabel('Timep[sec]')
ylabel('Yaw angle(deg)')