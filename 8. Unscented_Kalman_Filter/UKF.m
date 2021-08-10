classdef UKF< handle
    properties
        % Initial value
        x,P;
        
        % 
        kappa
        
        % Noise
        Q,R;
    end
    
    methods
        function model = UFK(x0,P0,Q,R,kappa)
            model.x = x;
            model.P = P0;
            
            model.kappa = kappa;
            
            model.Q = Q;
            model.R = R;
        end
        
        function xhat = Filtering(model,m)
            [Xi, W, n] = SigmaPoints(model.x,model.P,0);
            
            fXi = zeros(n,2*n+1);
            for k=1:2*n+1
                fXi(:,k) = fx(Xi(:,k),dt);
            end
            
            [xp, Pp] = UT(fXi,W,model.Q);
    
            hXi = zeros(m,2*n+1);
            for k=1:2*n+1
               hXi(:,k) = hx(fXi(:,k));
            end   
            
            [zp, Pz] = UT(hXi,W,model.R);
    
            Pxz = zeros(n,m);
            for k=1:2*n+1
               Pxz = Pxz + W(k)*(fXi(:,k)-xp)*(hXi(:,k)-zp)'; 
            end

            K = Pxz*inv(Pz);

            model.x = xp + K*(z-zp);
            model.P = Pp - K*Pz*K';
            
            xhat = model.x;
        end
        
        function [Xi,W,n] = SigmaPoints(model,xm,P)
            n = numel(xm);
            Xi = zeros(n,2*n+1);            % sigma points = col of Xi
            W = zeros(n,1);

            Xi(:,1) = xm;
            W(1) = model.kappa / (n+model.kappa);
            U = chol((n+model.kappa)*P);          % U*U = (n+kappa)*P

            for k=1:n
               Xi(:,k+1) = xm + U(k,:)';    % row of U 
               W(k+1) = 1/(2*(n+model.kappa));
            end

            for k=1:n
               Xi(:,n+k+1) = xm - U(k,:)';
               W(n+k+1) = 1/(2*(n+model.kappa));
            end          
        end
        
        function [xm, xcov] = UT(model,Xi,W,noiseCov)
            [n,kmax] = size(Xi);
    
            xm = 0;
            for k=1:kmax
               xm = xm + W(k)*Xi(:,k); 
            end

            xcov = zeros(n,n);
            for k=1:kmax
                xcov = xcov + W(k)*(Xi(:,k) - xm)*(Xi(:,k) - xm)';
            end
            xcov = xcov + noiseCov;
        end
        
        % system model f(x), h(x)
        function xp = fx(model,x,vel,ang_vel,dt)
            xp(1,1) = x(1) + vel*dt * cosd(x(3) + 0.5*ang_vel*dt);
            xp(2,1) = x(2) + vel*dt * sind(x(3) + 0.5*ang_vel*dt);
            xp(3,1) = x(3) + ang_vel*dt;
        end
        
        function yp = hx(model,x,a1,a2,a3,a4)
            z(1,1) = sqrt((x(1) - a1(1))^2+(x(2) - a1(2))^2);
            z(2,1) = sqrt((x(1) - a2(1))^2+(x(2) - a2(2))^2);
            z(3,1) = sqrt((x(1) - a3(1))^2+(x(2) - a3(2))^2);
            z(4,1) = sqrt((x(1) - a4(1))^2+(x(2) - a4(2))^2);
            z(5,1) = x(3);
        end
    end
end