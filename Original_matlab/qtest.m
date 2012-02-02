function qtest

global speed_of_sound mic_dist fs window_length                                     

% general parameter
speed_of_sound=343;
% distance between horizontal microphones in meters
mic_dist=0.32;
window_length=0.5;  % integration window in seconds
fs=48000;                                    % Sampling frequency for the microphones

tmaxdelay=mic_dist/speed_of_sound; % maximum delay between mics in seconds (0.73@25cm)
nr_bins=ceil(tmaxdelay*fs); % maxium possible delay in bins (32 @25cm)
overlap=window_length/2;


% % load wave files
od=cd('test32cm');
cA=loadwavefile(signal,'channelA.wav');
cB=loadwavefile(signal,'channelB.wav');
cC=loadwavefile(signal,'channelC.wav');
chanA=get(cA);chanB=get(cB);chanC=get(cC);
cd(od);
% chanA=chanA(1:200000);
% chanB=chanB(1:200000);
% chanC=chanC(1:200000);
% figure(342),clf,hold on
% plot(chanA,'.-k')
% plot(chanB,'.-r')
% plot(chanC,'.-b')
% 
[chanA,chanB,chanC]=pre_filter_stims(chanA,chanB,chanC,fs,200,10000);

%whitening?

% [chanA,chanB,chanC]=gen_test_sound(10,fs,mic_dist); %length, sample rate,

% wavplays(chanA,chanB)

nr_p=ceil(fs*window_length); % how many bins in each window
ccounter=1; % counts the bins in the whole stimuls
nr_windows=floor(length(chanA)/fs/window_length*2)-1;
for i=1:nr_windows
    present_time(i)=window_length*i-window_length/2;
    win_counter{i}=ccounter:ccounter+nr_p-1;
    ccounter=ccounter+nr_p/2;
end

allangs=zeros(nr_windows,1);
astr=zeros(nr_windows,1);
ccorrs1=zeros(nr_windows,nr_bins*2+1);
ccorrs2=zeros(nr_windows,nr_bins*2+1);
ccorrs3=zeros(nr_windows,nr_bins*2+1);

grafix=0;
for ncount=1:nr_windows
    c1=chanA(win_counter{ncount});
    c2=chanB(win_counter{ncount});
    c3=chanC(win_counter{ncount});
    [d12,astr1(ncount),ccorrs1(ncount,:),lags]=qcalc_crosscorr(c1,c2,grafix);%k
    allangs1(ncount)=asin(d12/tmaxdelay)*180/pi; %k=front

    [d13,astr2(ncount),ccorrs2(ncount,:),lags]=qcalc_crosscorr(c1,c3,grafix);%k
    allangs2(ncount)=asin(d13/tmaxdelay)*180/pi; %k=front
    allangs2(ncount)=allangs2(ncount);
    
    [d23,astr3(ncount),ccorrs3(ncount,:),lags]=qcalc_crosscorr(c2,c3,grafix);%k
    allangs3(ncount)=asin(d23/tmaxdelay)*180/pi; %k=front
    allangs3(ncount)=allangs3(ncount);

    
    if grafix
        wavplays(c1,c2);
    end
    
end

figure(342),clf,hold on
plot_corr(ccorrs1,allangs1,astr1,lags,present_time)
figure(343),clf,hold on
plot_corr(ccorrs2,allangs2,astr2,lags,present_time)
figure(344),clf,hold on
plot_corr(ccorrs3,allangs3,astr3,lags,present_time)

function plot_corr(corrs,allang,stren,lags,present_time)
surf(corrs');
nr_windows=size(corrs,1);
nr_bins=size(corrs,2)/2-1;
shading flat
set(gca,'xlim',[1 nr_windows]);
set(gca,'ylim',[1 nr_bins*2+1]);
x=get(gca,'xtick');
set(gca,'xticklabel',present_time(x));
y=get(gca,'ytick');
set(gca,'yticklabel',round(lags(y)*size(lags,2)/45)+1);
% plot all results
% figure(22);clf;hold on
nrs=1:nr_windows;
for i=1:nr_windows
    if stren(i)>0
        ang=allang(i)/(180/length(lags))+length(lags)/2+1;
        plot3(nrs(i),ang,10,'o','markersize',stren(i)/max(stren)*20,'markeredgecolor','w','markerfacecolor','k');
    end
end
h=line([0 length(allang)],[length(lags)/2 length(lags)/2],[10 10]);set(h,'color','k');
% plot(nrs,allangs(:,2),'xk')
set(gca,'xlim',[1 nr_windows]);
set(gca,'ylim',[1 size(lags,2)]);



function [delay,strength,crosscor,lags]=qcalc_crosscorr(S1,S2,grafix)
global speed_of_sound mic_dist fs window_length                                     
tmaxdelay=mic_dist/speed_of_sound; % maximum delay between mics in seconds (0.73@25cm)
n=ceil(tmaxdelay*fs); % maxium possible delay in bins (32 @25cm)

% cross correlation in the time domain
[crosscor,lags]=xcorr(S1,S2,n);
[strength, xdel]=max(crosscor);                             %Find peak in cross correlation
delay=lags(xdel)/fs;%Delay time of peak in s

if delay>tmaxdelay,    delay=tmaxdelay;end
if delay<-tmaxdelay,    delay=-tmaxdelay;end

if grafix
    
    figure(24);clf;hold on;
    tlags=lags/(fs/1000);
    plot(lags,crosscor,'.-')
    plot(lags(xdel),strength,'o','markersize',10,'color','g','markerfacecolor','g')
%     set(gca,'ylim',[-0.8 0.8])
    
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