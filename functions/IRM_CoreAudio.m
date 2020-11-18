function [ recsig_cell, excsig ] = IRM_CoreAudio( config )
%Handling IR Measurement I/O for macOS CoreAudio or Windows ASIO Device
%   
%% Chirp Setup
% chirp = dsp.Chirp(...
%     'Type', 'Logarithmic', ...
%     'InitialPhase', pi/2, ...
%     'TargetFrequency', config.fh, ...
%     'InitialFrequency', config.fl,...
%     'TargetTime', config.sweep_time, ...
%     'SweepTime', config.sweep_time, ...
%     'SamplesPerFrame', config.frameSize, ...
%     'SampleRate', config.fs);
%% Logarithmic Chirp Signal Generation
t = 0:1/config.fs:config.sweep_time;
t = t(1:end-1);
excsig = chirp(t,config.fl,config.sweep_time,config.fh,'logarithmic',-90)';  % log Chirp Generation
excsig = [excsig;excsig.*0];
outsig = excsig.*config.OutGain;
% excsig = repmat(excsig,1,size(config.PlayerChannelMapping,2));    

NG_flag = 1;

while(NG_flag >= 1)
    
%% Audio Player Recorder Setup
aPR = audioPlayerRecorder('SampleRate',config.fs,...
    'BitDepth','24-bit integer',...
    'RecorderChannelMapping', config.RecorderChannelMapping,...
    'Device',config.DeviceName);

% devices = getAudioDevices(aPR);
% aPRInfo = info(aPR);
        
%% Measurement I/O
recsig_cell = cell(config.N_measure,1);
totalUnderrun = 0;
totalOverrun = 0;

aPR.PlayerChannelMapping =config.PlayerChannelMapping;


for k = 1:config.N_measure
%     aPR.PlayerChannelMapping = [ config.out_chn_select(k) ];
    audioToDevice = zeros(config.frameSize, size(config.out_chn_select,2));
    recsig = zeros(config.sweep_length*2 *config.N_repeat, size(config.Rec_in_chn,2));

    for j = 1:config.N_repeat
        recsig_tmp = zeros(config.sweep_length*2, size(config.Rec_in_chn,2));
        
        for i = 1:(config.sweep_length*2/config.frameSize)
            idx_s = config.frameSize*(i-1)+1;
            idx_e = config.frameSize*i;

            audioToDevice(:,k) = outsig(idx_s:idx_e,:);

            [audioFromDevice,numUnderrun,numOverrun] = step(aPR,audioToDevice);

            recsig_tmp(idx_s:idx_e,:) = audioFromDevice;

            totalUnderrun =  totalUnderrun + numUnderrun;
            totalOverrun = totalOverrun + numOverrun;
            
        end
        recsig(config.sweep_length*2*(j-1)+1:config.sweep_length*2*j,:) = recsig_tmp;
    end
    release(aPR);
    
    recsig_cell(k) = {recsig};
    
end

excsig = excsig(:,1);

if totalUnderrun > 0
    fprintf('Audio player queue was underrun by %d samples.\n',totalUnderrun);
end
if totalOverrun > 0
    fprintf('Audio recorder queue was overrun by %d samples.\n',totalOverrun);
end
NG_flag = totalUnderrun + totalOverrun;

end

end

