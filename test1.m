clear all
close all
clc

%-------------------------------------------------------
%Input parameters

mic_distance = 0.22;        %Microphone spacing.

mics_theta = [pi/2 7/6*pi 11/6*pi];                    %Spatial position of microphones (angle)
mics_rho = (mic_distance/2)*[cosd(30),cosd(30),cosd(30)];        %Spatial position of microphones (distance from centre)

c0 = 343;                                                        %Speed of sound in air

%------------------------------------------------------


%----------------------------------------------
%Input Signals

% x1=wavread('channelA.wav');
% x2=wavread('channelB.wav');
% x3=wavread('channelC.wav');

phi1 = 0;
phi2 = pi;

f = 1000;                                         %Input excitation frequency
fs = 48000;                                     %Sampling Frequency
dt= 1/fs;                                       %Sample spacing

t0=0.1;                                         %Length of sample (s)
t=0:dt:t0;                                      %Time vector (s)

x1 = sin(2 * pi * f * t);
x2 = sin(2*pi*f*t + phi1);
x3 = sin(2*pi*f*t + phi2);

%-------------------------------------------------------


% figure(1)
% plot(t,x1,t,x2,t,x3)
% legend '1' '2' '3'

%Calculating cross correlation

max_lag = ceil((mic_distance / c0)/dt);    % Maximum lag in samples between microphones due to spacing

[cross_1_2,lag_1_2] = xcorr(x1,x2,max_lag);
[cross_1_3,lag_1_3] = xcorr(x1,x3,max_lag);
[cross_2_3, lag_2_3] = xcorr(x2,x3,max_lag);



[position_1_2,strength_1_2] = peaksearch(cross_1_2,lag_1_2);
[position_1_3,strength_1_3] = peaksearch(cross_1_3,lag_1_3);
[position_2_3,strength_2_3] = peaksearch(cross_2_3,lag_2_3);


lag_d_1_2 = dt*position_1_2*c0/(mic_distance/2);
lag_d_1_3 = dt*position_1_3*c0/(mic_distance/2);
lag_d_2_3 = dt*position_2_3*c0/(mic_distance/2);

%Calculate angle and possible mirror angle
%--------------------------------------------------
angle_1_2 = sin(lag_d_1_2*pi/2);
angle_1_2_a = 5/6*pi-angle_1_2;
angle_1_2_b = 11*pi/6 + angle_1_2;

angle_1_3 =  sin(lag_d_1_3*pi/2);
angle_1_3_a = 1/6*pi + angle_1_3;
angle_1_3_b = 7/6*pi - angle_1_3;

angle_2_3 = sin(lag_d_1_3*pi/2);
angle_2_3_a = 9*pi/6 - angle_2_3;
angle_2_3_b = 3*pi/6 + angle_2_3;

%------------------------------------------------

%Compare angles for matches
%------------------------------------------------






% angle_1_2 = 210;
% angle_1_2 = angle_1_2 + atan(distance_1_2/mic_distance)

% figure(2)
% plot(cross_1_3)

figure(3)
polar(mics_theta,mics_rho,'or')
hold on
polar(angle_1_2_a,0.1,'ob')
polar(angle_1_2_b,0.1,'ob')
polar(angle_1_3_a,0.1,'oc')
polar(angle_1_3_b,0.1,'oc')
polar(angle_2_3_a,0.1,'ok')
polar(angle_2_3_b,0.1,'ok')