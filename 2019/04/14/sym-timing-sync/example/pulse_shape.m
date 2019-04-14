L        = 4;         % Oversampling factor
rollOff  = 0.5;        % Pulse shaping roll-off factor
rcDelay  = 10;         % Raised cosine delay in symbols

% Filter:
htx = rcosine(1, L, 'sqrt', rollOff, rcDelay/2);
% Note half of the target delay is used, because when combined
% to the matched filter, the total delay will be achieved.
hrx  = conj(fliplr(htx));

figure
plot(htx)
title('Transmit Filter')
xlabel('Index')
ylabel('Amplitude')

figure
plot(hrx)
title('Rx Filter (Matched Filter)')
xlabel('Index')
ylabel('Amplitude')

p = conv(htx,hrx);

figure
plot(p)
title('Combined Tx-Rx = Raised Cosine')
xlabel('Index')
ylabel('Amplitude')

% And let's highlight the zero-crossings
zeroCrossings = NaN*ones(size(p));
zeroCrossings(1:L:end) = 0;
zeroCrossings((rcDelay)*L + 1) = NaN; % Except for the central index
hold on
plot(zeroCrossings, 'o')
legend('RC Pulse', 'Zero Crossings')
hold off