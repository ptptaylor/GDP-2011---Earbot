
fs=48000;                                    % Sampling frequency for the microphones

window_length=5;  % integration window in seconds
nr_p=fs*window_length;


sdata = pa_wavrecord(1,2,nr_p,fs);
channelA=sdata(:,1);
channelB=sdata(:,2);
channelC=sdata(:,3);


save cC channelC
save cA channelA
save cB channelB

wavwrite(channelA,fs,24,'channelA.wav')
wavwrite(channelB,fs,24,'channelB.wav')
wavwrite(channelC,fs,24,'channelC.wav')
% 
% % m=[channelA channelB channelC];
% % wavwrite
% 
%     load cA channelA
%     load cB channelB
%     load cC channelC