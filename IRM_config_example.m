%% IR Measurmnent
% Liu Ziyun
% 2020-11-17

clear config;

%% Config Hardware
samplerate_speed = 1;
config.fs = 48e3 * samplerate_speed;
config.frameSize = 512;
% config.frameSize = 1024/samplerate_speed;
% conifg.nBits = 24;      

config.inSens = 2.449;           % Input Sensitivty in V @ 0 dBFS
config.outSens = 6.904;          % Output Sensitivty in V @ 0 dBFS

config.micSense = -37.9;		 % 1 Pa = -37.9 dBFS

config.Vout = 0.01;
config.OutGain = 0.2;            % Initial OutGain Value

config.Rec_in_chn = [ 2 ];

config.out_chn_select = [ 11 12 ];


config.RecorderChannelMapping = [ config.Rec_in_chn ];
config.PlayerChannelMapping = [ config.out_chn_select ];

config.DeviceName = 'Fireface UC Mac (23935003)';

%% Config Measurment
config.fl = 4;                  % fl and fh are the lowest and highest 
                                 % frequencies of this measurment respectively.
config.fh = config.fs/2;

config.sweep_length = 8192*samplerate_speed*2;      % as fftsize/2
config.sweep_time = config.sweep_length / config.fs; 
config.fftsize = config.sweep_length*16;

config.N_repeat = 6;             % Repeat for 6 times
config.N_measure = size(config.out_chn_select,2);

