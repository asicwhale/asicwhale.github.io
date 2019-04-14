L        = 4;          % Oversampling factor
M         = 2;  % Pam Order
rollOff  = 0.5;        % Pulse shaping roll-off factor
rcDelay  = 10;         % Raised cosine delay in symbols


% Filter:
htx = rcosine(1, L, 'sqrt', rollOff, rcDelay/2);
% Note half of the target delay is used, because when combined
% to the matched filter, the total delay will be achieved.
hrx  = conj(fliplr(htx));



h = [0.5 0 -0.5]; % central-differences kernel function
central_diff_mf = conv(h, hrx);
% Skip the kernel delay
dmf = central_diff_mf(2:1+length(hrx));

figure
plot(hrx, '-*')
hold on, grid on
plot(dmf, '-r>')
legend('MF', 'dMF')
title('MF vs. dMF')
xlabel('Index')
ylabel('Amplitude')
hold off