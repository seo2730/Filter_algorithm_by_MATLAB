function r = GetRadar(dt)
persistent posp

if isempty(posp)
  posp = 0;
end

vel = 100  +  5*randn;  % 5m/s 정도 오차를 준다.
alt = 1000 + 10*randn;  % 10m 정도 오차를 준다.

pos = posp + vel*dt;    % 현재 위치 = 이전 위치 + 속도 x dt 
v = 0 + pos*0.05*randn;
r = sqrt(pos^2 + alt^2) + v; % 레이더에서 목표물까지의 직선거리

posp = pos;