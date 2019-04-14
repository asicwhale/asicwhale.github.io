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

mfOutput = filter(hrx, 1, rxDelayed); % Matched filter output

figure
stem(mfOutput(41:41+L))
hold on
plot(mfOutput(41:41+L))
hold off
xlabel('Index')
ylabel('Amplitude')

% First do PAM-demodulation
rxdata_nosync   = pamdemod(downsample(mfOutput, L), M);
rxdata_withsync = pamdemod(downsample(mfOutput, L, timeOffset), M);
% Then, regenerate the corresponding constellation symbols
decSym_nosync   = real(pammod(rxdata_nosync, M));
decSym_withsync = real(pammod(rxdata_withsync, M));

% Midpoint samples
midSamples_nosync     = mfOutput((L/2 + 1):L:end);
midSamples_withsync   = mfOutput((L/2 + 1 + timeOffset):L:end);

% Sign correction values based on symbol decisions:
signcorrection_nosync   = [-diff(decSym_nosync), 0];
signcorrection_withsync = [-diff(decSym_withsync), 0];
% Note: the padded zero is just for the signcorrection vector
% to have a length equivalent to the the vector of midsamples.

% ZC-TED output:
zcted_nosync   = midSamples_nosync .* signcorrection_nosync;
zcted_withsync = midSamples_withsync .* signcorrection_withsync;

% Plot
figure
stem(zcted_nosync)
hold on
stem(zcted_withsync, '--r', 'LineWidth', 2)
hold off
xlabel('Symbol Index')
ylabel('Amplitude')
legend('No Symbol Timing Sync', 'With Sync')
title('ZC-TED Output - Timing Errors')





