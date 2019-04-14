
close all;
clear;
clc;

%% Para
L         = 4;          % Oversampling factor
M         = 2;          % Pam Order
rollOff   = 0.5;        % Pulse shaping roll-off factor
rcDelay   = 10;         % Raised cosine delay in symbols

%% PAM TX

% Filter:
htx = rcosine(1, L, 'sqrt', rollOff, rcDelay/2);
% Note half of the target delay is used, because when combined
% to the matched filter, the total delay will be achieved.
hrx  = conj(fliplr(htx));

% Arbitrary binary data
data          = zeros(1, 2*rcDelay);
%data          = floor(rand(1, 2*rcDelay));

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
h = [0.5 0 -0.5]; % central-differences kernel function
central_diff_mf = conv(h, hrx);
% Skip the kernel delay
dmf = central_diff_mf(2:1+length(hrx));

dmfOutput = filter(dmf, 1, rxDelayed);
mfOutput = filter(hrx, 1, rxDelayed); % Matched filter output

figure
stem(dmfOutput)
title('Derivative Matched Filter Output')
xlabel('Index')
ylabel('Amplitude')

rxSym = downsample(mfOutput, L, timeOffset);

% Generate a vector that shows the selected samples
selectedSamples = upsample(rxSym, L);
selectedSamples(selectedSamples == 0) = NaN;

dmfDownsampled_nosync = downsample(dmfOutput, L);
dmfDownsampled_withsync = downsample(dmfOutput, L, timeOffset);

% And just for illustration purposes
figure
stem(dmfDownsampled_nosync)
hold on
stem(dmfDownsampled_withsync, '--r', 'LineWidth', 2)
xlabel('Symbol Index')
ylabel('Amplitude')
legend('No Symbol Timing Sync', 'With Sync')
title('Downsampled dMF output')
hold off

% First do PAM-demodulation
rxdata_nosync   = pamdemod(downsample(mfOutput, L), M);
rxdata_withsync = pamdemod(downsample(mfOutput, L, timeOffset), M);
% Then, regenerate the corresponding constellation symbols
decSym_nosync   = real(pammod(rxdata_nosync, M));
decSym_withsync = real(pammod(rxdata_withsync, M));

% TED Output
e_nosync       = decSym_nosync .* dmfDownsampled_nosync;
e_withsync     = decSym_withsync .* dmfDownsampled_withsync;

% And just for illustration purposes
figure
stem(e_nosync)
hold on
stem(e_withsync, '--r', 'LineWidth', 2)
xlabel('Symbol Index')
ylabel('Amplitude')
legend('No Symbol Timing Sync', 'With Sync')
title('ML-TED Output - Timing Errors')
hold off





