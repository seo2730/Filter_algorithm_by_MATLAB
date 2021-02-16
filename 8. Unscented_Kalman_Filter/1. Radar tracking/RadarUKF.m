function [pos, vel, alt] = RadarUKF(z,dt)
    persistent Q R
    persistent x P
    persistent n m
    persistent firstRun
    
    if isempty(firstRun)
       Q = [0.01    0    0;
               0 0.01    0;
               0    0 0.01];
           
       R = 100;
       
       x = [0 90 1100]';
       P = 100*eye(3);
       
       n = 3;
       m = 1;
       
       firstRun = 1;
    end
    
    [Xi W] = SigmaPoints(x,P,0);
    
end