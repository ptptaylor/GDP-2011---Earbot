function [final_angle,allangs,final_strength]=calc_direction(c1,c2,c3,mic_dist,fs,accuracy,grafix)
tmaxdelay=mic_dist/343; % maximum delay between mics in seconds (0.73@25cm)
[d12,s12]=calc_crosscorr(c1,c2,fs,mic_dist,0);%k
[d13,s13]=calc_crosscorr(c2,c3,fs,mic_dist,0);%b
[d23,s23]=calc_crosscorr(c3,c1,fs,mic_dist,0);%r

strength(1)=s12;strength(2)=s12;strength(3)=s23;strength(4)=s23;strength(5)=s13;strength(6)=s13;

a=asin(d12/tmaxdelay)*180/pi; %k=front
b=asin(d13/tmaxdelay)*180/pi; %b=left
c=asin(d23/tmaxdelay)*180/pi; %r=right

amirror=180-a;
a=mod(a,360);amirror=mod(amirror,360);
ang1a=a;
ang1b=amirror;

b=b+120; %240
bmirror=60-b; %300
b=mod(b,360);
bmirror=mod(bmirror,360);
ang2a=b;
ang2b=bmirror;

c=c+240; %120
cmirror=300-c; %60
c=mod(c,360);
cmirror=mod(cmirror,360);
ang3a=c;
ang3b=cmirror;

% save the individual angles for later display
allangs=[ang1a ang1b ang2a ang2b ang3a ang3b];


% calculate the most likely candiate from the 6 angles
% by adding them up with gaussian functions
nr_bins=360;
hits=zeros(nr_bins,1);
colors={'k';'k';'r';'r';'b';'b'};

if grafix
    figure(93),clf
end

for i=1:6
    ahi=add_angle(allangs(i),accuracy)*strength(i);
    hits=hits+ahi;
    if grafix
        figure(93),hold on
        plot(ahi,'.-','color',colors{i},'markerfacecolor',colors{i},'markeredgecolor',colors{i})
        set(gca,'xlim',[0 360])
        set(gca,'ylim',[-0.8 0.8])
    end
end

% search for the single highest peak. If several peaks have the same
% hight,do something!
[final_strength,final_angle]=max(hits);


if grafix
    plot(hits,'g')
    set(gca,'xlim',[0 360])
    set(gca,'ylim',[-0.8 0.8])
end
return


function hitone=add_angle(ang,accuracy)
% nr_bins=360/accuracy;
nr_bins=360;
hitone=zeros(nr_bins,1);
a=round(ang);

bins=-round(accuracy)/2:round(accuracy)/2;
weights=exp((-bins.*bins)/(accuracy));

for i=bins
    cc=a+i;
    cc=mod(cc,nr_bins)+1;
    
    w=weights(i+round(accuracy/2)+1);
    hitone(cc)=hitone(cc)+w;
end

return

