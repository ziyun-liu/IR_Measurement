%% Measurement System Calibration
% Shen Yuchen
% 2017-03-06
% Change Log:
%   170531  STD_SPL = 93.8 dB/94.0 dB/114 dB etc.;
%   170905  Calibration Method Revised. Liuziyun

% close all;clc;clear; 
addpath('../IR_toolbox');
clear;clc;
%% Configuration Parameters
run('IRM_config_example.m');
STD_SPL = 93.8;

%% Calibration - Record
disp('Please TURN ON the calibrator and insert microphone into it.')
pause(1);
disp('Make sure the system is STILL!');
pause(1);
disp('The calibration process will start in 3 seconds.');
pause(3);

[ recsig_cell, excsig ] = IRM_FIREFACE( config );

%% Post-processing
recsig = cell2mat(recsig_cell);
Mic_sensitivity = db(rms(recsig(:,1))/rms(excsig));
Cal_Gain = STD_SPL-Mic_sensitivity;

Mic_info = [Mic_sensitivity,Cal_Gain]