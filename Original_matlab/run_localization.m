clc
clear all


%Load signal function
%------------------------------
cd('tools/@signal/');
signal
cd('..');
cd('..');
%------------------------------
% close all

% general parameter
mic_dist=0.31;                                       % distance between horizontal microphones in meters
window_length=0.1;  % integration window in seconds




% generate stimulus
fs=48000;                                    % Sampling frequency for the microphones
% testbed 1: one male speaker straight in front
% testbed 2: one male speaker from -90deg to +90deg
% testbed 3: one male speaker from front, one make speaker from 90deg
% testbed 4: one female speaker from front
% testbed 5: one female from front, one male from side
% testbed 6: one male speaker moving through the room

% % load wave files
angle_test=[]
cd ..
cd Experiments
for n = 2:19
od=cd(['2011_tests/Volume12(55dba)/Test' num2str(n)]);
% cA=loadwavefile(signal,'channelA.wav');
% cB=loadwavefile(signal,'channelB.wav');
% cC=loadwavefile(signal,'channelC.wav');

cd ..
cd ..
cd ..
cd ..
cd(['Localisation scripts'])
t = 0:1/fs:1;
phi1 = 0;
phi2 = 0;
phi3 = 0;
f=500;

cA = sin(2*pi*f*t+phi1);
cB = sin(2*pi*f*t+phi2);
cC = sin(2*pi*f*t+phi3);
chanA = cA;
chanB = cB;
chanC = cC;
% chanA=get(cA);chanB=get(cB);chanC=get(cC);

cd(od);

% % % load wave files
% od=cd('testbed directional');
% cas=loadwavefile(signal,'test002-1.wav');
% cbs=loadwavefile(signal,'test002-3.wav');
% ccs=loadwavefile(signal,'test002-5.wav');
% cd(od);
% chanA=get(cas);chanB=get(cbs);chanC=get(ccs);

% 
% [chanA,chanB,chanC]=gen_test_sound(10,fs,mic_dist); %length, sample rate,



% pre filter stimulus
[chanA,chanB,chanC]=pre_filter_stims(chanA,chanB,chanC,fs,100,15000);
% 
% figure(2343)
% clf
% hold on
% range=10000:30000;
% plot(chanA(range),'.-k')
% plot(chanB(range),'.-r')
% plot(chanC(range),'.-b')
% 
% 
% % pre-processing (desperate): subtract the average from each channel, to
% % get rid of correlated noise
% av=(chanA+chanB+chanC)/3;
% c1=chanA-av;
% c2=chanB-av;
% c3=chanC-av;
% 
% figure(2333)
% clf
% hold on
% plot(c1(range),'k')
% plot(c2(range),'r')
% plot(c3(range),'b')




nr_p=ceil(fs*window_length); % how many bins in each window
ccounter=1; % counts the bins in the whole stimuls
nr_windows=floor(length(chanA)/fs/window_length);

for i=1:nr_windows
    present_time(i)=window_length*(i-1);
    win_counter{i}=ccounter:ccounter+nr_p-1;
    ccounter=ccounter+nr_p;
end

final_angle=zeros(nr_windows,1);
allangs=zeros(nr_windows,6);

for ncount=1:nr_windows
    c1=chanA(win_counter{ncount});    
    c2=chanB(win_counter{ncount});    
    c3=chanC(win_counter{ncount});
    
    % here the direction is calcuated:
    accuracy=30; % in degrees
    [final_angle(ncount),allangs(ncount,:),final_strength(ncount)]=calc_direction(c1,c2,c3,mic_dist,fs,accuracy,0);
    
    grafix=1;
    if grafix
        
        cha1=c1;
        cha2=c2;
        
        % plot stimuli
      % figure(91),clf,hold on
      % plot(cha1,'.-k')
     %  plot(cha2,'.-r')
        
        % plot correlation
%         figure(92),clf,hold on
        %calc_crosscorr(cha1,cha2,fs,mic_dist,1);

        % plot gaussian weights
%         figure(93),clf,hold on
%         [final_angle(ncount),allangs(ncount,:)]=calc_direction(cha1,cha2,c3,mic_dist,fs,accuracy,1);
%         
        %wavplays(cha1,cha2);
        
    end
    
end

% plot all results
% figure(22);clf;hold on
nrs=1:size(allangs,1);
plot(nrs,allangs(:,1),'ok')
% plot(nrs,allangs(:,2),'xk')
plot(nrs,allangs(:,3),'ob')
% plot(nrs,allangs(:,4),'xb')
plot(nrs,allangs(:,5),'or')
% plot(nrs,allangs(:,6),'xr')
set(gca,'ylim',[0 360]);



% figure(432),clf,hold on
for i=1:length(final_angle)
    plot(present_time(i),final_angle(i),'.','markersize',final_strength(i)*20)
end
set(gca,'ylim',[0 360])


angle_test(n) = sum(final_angle)/i;



end