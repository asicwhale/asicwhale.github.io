L        = 4;         % Oversampling factor
M         = 2;  % Pam Order
rollOff  = 0.5;        % Pulse shaping roll-off factor
rcDelay  = 10;         % Raised cosine delay in symbols

%% PAM TX

% Filter:
htx = rcosine(1, L, 'sqrt', rollOff, rcDelay/2);
% Note half of the target delay is used, because when combined
% to the matched filter, the total delay will be achieved.
hrx  = conj(fliplr(htx));

% Arbitrary binary data
data          = zeros(1, 2*rcDelay);
data(1:2:end) = M-1;
% PAM-modulated symbols:
txSym         = real(pammod(data, M));
% Upsampling
txUpSequence = upsample(txSym, L);
% Pulse Shaping% Filter:
txSequence = filter(htx, 1, txUpSequence);

%% Channel
timeOffset = 1; % Delay (in samples) added
% Delayed sequence
rxDelayed = [zeros(1, timeOffset), txSequence(1:end-timeOffset)];

%% PAM RX
mfOutput = filter(hrx, 1, rxDelayed); % Matched filter output

figure
stem(mfOutput)
title('Matched Filter Output (Correlative Receiver)')
xlabel('Index')
ylabel('Amplitude')

rxSym = downsample(mfOutput, L);

% Generate a vector that shows the selected samples
selectedSamples = upsample(rxSym, L);
selectedSamples(selectedSamples == 0) = NaN;

% And just for illustration purposes
figure
stem(mfOutput)
hold on
stem(selectedSamples, '--r', 'LineWidth', 2)
title('Matched Filter Output (Correlative Receiver)')
xlabel('Index')
ylabel('Amplitude')
legend('MF Output', 'Downsampled Sequence (Symbols)')
hold off

figure
plot(complex(rxSym(rcDelay+1:end)), 'o')
grid on
xlim([-1.5 1.5])
title('Rx Scatterplot')
xlabel('In-phase (I)')
ylabel('Quadrature (Q)')







