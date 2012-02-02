function [s1,s2,s3]=gen_test_sound(len,fs,mic_dist)
% generate a stimulus that rotates 360degrees
% len=10; %sec


% simple: sinus of 1000 Hz
% raw_stimulus=sinus(10,fs,1000);
raw_stimulus=gennoise(signal(10,fs),1);


% od=cd('testbed2');
% raw_stimulus=loadwavefile(signal,'channelC.wav');
% cd(od)

% 1deg steps
degs=0:1:359;
c=1;

% some math from http://en.wikipedia.org/wiki/Circular_segment
r=mic_dist/sqrt(2-2*cos(120/180*pi)); %=radius of circle of microphones
% r=mic_dist;

angmic1=60/180*pi; % angle of first mic
angmic2=180/180*pi; % angle of third mic
angmic3=300/180*pi; % angle of second mic

n=ceil((mic_dist*fs)/343); % maxium possible delay in bins (32 @25cm)

for i=degs
    tstart(c)=(c-1)*len/length(degs);
    % calculate the relative shift against the origin of the circle
    dx1=r*-cos(i/180*pi-angmic1); %k
    dx2=r*-cos(i/180*pi-angmic2);%r
    dx3=r*-cos(i/180*pi-angmic3);%b
    
    dt1(c)=dx1/343;  % run time difference between source and A
    dt2(c)=dx2/343;  % run time difference between source and B
    dt3(c)=dx3/343;  % run time difference between source and C
    
    c=c+1;
end

% translate the dts into bins and shift each stimulus accordingly
stim=getvalues(raw_stimulus);
% stim=rand(fs*len,1);
s1=zeros(size(stim));
s2=zeros(size(stim));
s3=zeros(size(stim));
c=1;


for i=1:length(degs)-1;
    bstart=ceil(tstart(c)*fs)+1;
    bstop=ceil(tstart(c+1)*fs);
    sig=stim(bstart:bstop);
    
    nr_bins1=round(dt1(c)*fs);
    nr_bins2=round(dt2(c)*fs);
    nr_bins3=round(dt3(c)*fs);
    
    nb1(c)=nr_bins1;
    nb2(c)=nr_bins2;
    nb3(c)=nr_bins3;
    
    if nr_bins1>0
        stim1=[zeros(nr_bins1,1);sig(1:length(sig)-nr_bins1)];
    else
        stim1=[sig(-nr_bins1+1:length(sig));zeros(-nr_bins1,1)];
    end
       
        
    if nr_bins2>0
        stim2=[zeros(nr_bins2,1);sig(1:length(sig)-nr_bins2)];
    else
        stim2=[sig(-nr_bins2+1:length(sig));zeros(-nr_bins2,1)];
    end
            
    if nr_bins3>0
        stim3=[zeros(nr_bins3,1);sig(1:length(sig)-nr_bins3)];
    else
        stim3=[sig(-nr_bins3+1:length(sig));zeros(-nr_bins3,1)];
    end
        
    s1(bstart:bstop)=stim1; % signal at mic 1
    s2(bstart:bstop)=stim2; % signal at mic 2
    s3(bstart:bstop)=stim3;
    
%     figure(321),clf,hold on
%     plot(stim1,'k')
%     plot(stim2,'r')
%     plot(stim3,'b')
    
    c=c+1;
end

% add some random noise to it independent on each channel
% ampmax=max(s1);
% s1=s1+rand(size(s1))*2*ampmax;
% s2=s2+rand(size(s2))*2*ampmax;
% s3=s3+rand(size(s3))*2*ampmax;


% figure(3231),clf,hold on
% plot(nb1,'k')
% plot(nb2,'r')
% plot(nb3,'b')

% figure(321),clf,hold on
% plot(s1,'k')
% plot(s2,'r')
% plot(s3,'b')

return
% 
% figure(321),clf,hold on
% plot(dt1*50000,'k')
% plot(nr_bins1,'k');
% plot(dt2*50000,'b')
% plot(nr_bins2,'b');
% plot(dt3*50000,'r')
% plot(nr_bins3,'r');

