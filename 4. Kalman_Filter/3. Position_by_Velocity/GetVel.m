function [z,pos] = GetVel()

persistent Velp Posp

if isempty(Posp)
    Posp = 0;
    Velp = 80;
end

dt = 0.1;

w = 0 + 10*randn;
v = 0 + 10*randn;

p = Posp + Velp*dt + v;

Posp = p - v;  % true position
Velp = 80 + w; % true speed

z = Velp;
pos = Posp;
end