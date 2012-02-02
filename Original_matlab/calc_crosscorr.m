function [delay,strength]=calc_crosscorr(S2,S1,fs,mic_dist,grafix)


method='xcorr';


if isequal(method,'xcorr')
    
    n=ceil((mic_dist*fs)/343); % maxium possible delay in bins (32 @25cm)
    tmaxdelay=mic_dist/343; % maximum delay between mics in seconds (0.73@25cm)
    
    % cross correlation in the time domain
    [crosscor,lags]=xcorr(S1,S2,n);
    [strength, xdel]=max(crosscor);                             %Find peak in cross correlation
    d=lags(xdel);
    delay=d/fs;%Delay time of peak in s
    
    if delay>tmaxdelay
        delay=tmaxdelay;
    end
    if delay<-tmaxdelay
        delay=-tmaxdelay;
    end
    
    
    if grafix
        
        figure(24);clf;hold on;
        tlags=lags/(fs/1000);
        plot(lags,crosscor,'.-')
        plot(lags(xdel),strength,'o','markersize',10,'color','g','markerfacecolor','g')
        set(gca,'ylim',[-0.8 0.8])

        ang=asin(delay/tmaxdelay)*180/pi;
        text(tlags(xdel),strength,sprintf('t=%2.2fms, deg=%2.2f',delay*1000,ang));
        
        figure(25);clf;hold on;
        plot(S1,'.-b');
        plot(S2,'.-r')

        figure(26);clf;hold on;
        S2=circshift(S2,lags(xdel));
        plot(S1,'.-b');
        plot(S2,'.-r')
       
    end

    
    
    
    
    
    
    
    
elseif isequal(method,'spectral')
    L=length(S1);
    L1=fft(S1,2*L);                            %Zero padded fft of left signal
    R1=fft(S2,2*L);                           %Zero padded fft of right signal
    xc = ifft(fft(L1).*conj(fft(R1)));
    xc = real(xc);
    t1=fftshift(t0(1:length(r1)));
    
%     t0=[0:length(r)-1]/(fs*2);                   %new time vector for zero padded signal
%     r1=fftshift(real(r));                        %fftshift to put cross correlation peak in the centre
%     t1=fftshift(t0(1:length(r1)));               %Shift the time vector to put zero in the centre
%     B=find(t1 == 0);                             %ditto
%     t1(1:B-1)=(t1(1:B-1)-t0(length(r1))).*2;          %ditto
%     n=round((mic_dist*fs)/343);
%     
%     r1(1:fs-2*n)=0;                              %Set all parts of the cross correlation to
%     r1(fs+2*n:end)=0;                            %zero other than realistic delay times
%     r1(fs-4:fs+4)=0; % set the one at exactly zero to zero
%     
%     [Y1 I1]=max(r1);                             %Find peak in cross correlation
%     delay=t1(I1);                                %Delay time of peak
%     delay=343*delay;                          %Calculate path difference
%     
    
    
end