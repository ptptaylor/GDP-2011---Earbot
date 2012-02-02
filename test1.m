clear all
clc


%-------------------------------------------------------
%Input parameters

mic_distance = 0.22;        %Microphone spacing.

mics_theta = [pi/2 210*2*pi/360 2*pi*330/360]                    %Spatial position of microphones (angle)
mics_rho = (mic_distance/2)*[cosd(30),cosd(30),cosd(30)];        %Spatial position of microphones (distance from centre)

c0 = 343;                                                        %Speed of sound in air

%------------------------------------------------------


%----------------------------------------------
%Input Signals

% x1=wavread('channelA.wav');
% x2=wavread('channelB.wav');
% x3=wavread('channelC.wav');
phi1 = pi/2;
phi2 = 3*pi/2;


f = 10;                                         %Input excitation frequency
fs = 48000;                                     %Sampling Frequency
dt= 1/fs;                                       %Sample spacing

t0=0.1;                                         %Length of sample (s)
t=0:dt:t0;                                      %Time vector (s)

x1 = sin(2 * pi * f * t);
x2 = sin(2*pi*f*t + phi1);
x3 = sin(2*pi*f*t + phi2);

%-------------------------------------------------------


figure(1)
plot(t,x1,t,x2,t,x3)
legend '1' '2' '3'

%Calculating cross correlation
max_lag = 1000*ceil((mic_distance / c0)/dt);

cross_1_2 = xcorr(x1,x2,[max_lag]);
cross_1_3 = xcorr(x1,x3,max_lag);
cross_2_3 = xcorr(x2,x3,max_lag);


[position_1_2,strength_1_2] = peaksearch(cross_1_2);
[position_1_3,strength_1_3] = peaksearch(cross_1_3);
[position_2_3,strength_2_3] = peaksearch(cross_2_3);

sigout = reconstruct_signal(x1,x2,x3,position_1_2,position_1_3,position_2_3);

lag_1_2 = dt*position_1_2;
lag_1_3 = dt*position_1_3;
lag_2_3 = dt*position_2_3;

distance_1_2 = lag_1_2*c0;
distance_1_3 = lag_1_3*c0;
distance_2_3 = lag_2_3*c0;


angle_1_2 = 210;
angle_1_2 = angle_1_2 + atan(distance_1_2/mic_distance)

figure(2)
plot(cross_1_3)

figure(3)
polar(mics_theta,mics_rho,'or')
