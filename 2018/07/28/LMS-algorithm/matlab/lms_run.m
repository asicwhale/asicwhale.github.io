close  all
clear
%  signal generation
t=0:99;
xs=10*sin(0.5*t);
% generate random noise
randn('state',sum(100*clock));
xn=randn(1,100);
% Adative filter
xn = xs+xn;
xn = xn.' ;   % filter inpput
dn = xs.' ;   % referce signal
M  = 20   ;   % fiter order
rho_max = max(eig(xn*xn.'));   % The max Eiggen value of correlative matrix
mu = rand()*(1/rho_max)   ;    % step factor

[yn,W,en] = lms_func(xn,dn,M,mu);
% draw figures
figure;
subplot(2,1,1);
plot(t,xn);grid;
ylabel('Amptitude');
xlabel('Time');
title('{Filter input signal}');
% draw filter output
subplot(2,1,2);
plot(t,yn);grid;
ylabel('Amptitude');
xlabel('Time');
title('{Adaptive filter output signal}');
% Compare figure
figure 
plot(t,yn,'b',t,dn,'g',t,dn-yn,'r');grid;
legend('adaptive out','reference','error');
ylabel('Amptitude');
xlabel('Time');
title('{Adaptive LMS filter}');