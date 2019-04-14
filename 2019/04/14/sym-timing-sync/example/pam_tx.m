L        = 4;   % Oversampling factor
M         = 2;  % Pam Order
rollOff  = 0.5; % Pulse shaping roll-off factor
rcDelay  = 10;  % Raised cosine delay in symbols

% Arbitrary binary data
data          = zeros(1, 2*rcDelay);
data(1:2:end) = M-1;

% PAM-modulated symbols:
txSym         = real(pammod(data, M));

figure
stem(txSym)
title('Symbol Sequence')
xlabel('Symbol Index')
ylabel('Amplitude')

% Upsampling
txUpSequence = upsample(txSym, L);

figure
stem(txUpSequence)
title('Upsampled Sequence')
xlabel('Sample Index')
ylabel('Amplitude')

% Pulse Shaping% Filter:
htx = rcosine(1, L, 'sqrt', rollOff, rcDelay/2);
txSequence = filter(htx, 1, txUpSequence);

figure
stem(txSequence)
title('Shaped Transmit Sequence')
xlabel('Index')
ylabel('Amplitude')