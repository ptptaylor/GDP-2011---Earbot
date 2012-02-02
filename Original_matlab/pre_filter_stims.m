% pre filter stimulus
function [chanA,chanB,chanC]=pre_filter_stims(chanA,chanB,chanC,fs,low_f,high_f)


% 
% % ignore all frequencies whos wavelengths are too long
cutofffre=low_f;
fNorm = cutofffre / (fs/2); % 200 Hz
% freqz(b,a,128,fs); % look at the frequency response of the filter
[b,a] = butter(6, fNorm, 'high');
chanA = filtfilt(b, a, chanA);
chanB = filtfilt(b, a, chanB);
chanC = filtfilt(b, a, chanC);
% %
cutofffre=high_f;
fNorm = cutofffre / (fs/2); % 200 Hz
[b,a] = butter(6, fNorm, 'low');
chanA = filtfilt(b, a, chanA);
chanB = filtfilt(b, a, chanB);
chanC = filtfilt(b, a, chanC);