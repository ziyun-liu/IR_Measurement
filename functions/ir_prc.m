function IR_Temp = ir_prc(sweep,recsig,Chirp)
% Calculating IR
% ref_sig should be in last colume of recsig.

% Change Log
% 2017-03-06 First Ed. by Shen Yuchen
% 2017-06-06 Averaging changed to N_repeat-2. liuziyun
% 2017-06-07 Multi-channel supported. liuziyun


% Signal Configuration
n_IR = size(recsig,2);

% Calculate the IR of the DUT using FFT
IR_Temp = zeros(length(sweep),n_IR);

for i=1:n_IR
    % Calculate the IR of the DUT using FFT
    RIR = io2ir(sweep, recsig(:,i), Chirp.fftsize);

%     % Averaging
    RIR = RIR(1:length(sweep)*(Chirp.N_repeat-1));
    RIR_Rep = reshape(RIR, length(sweep), Chirp.N_repeat-1);
    RIR_Rep = RIR_Rep(:,2:end);
    IR_Temp(:,i) = mean(RIR_Rep,2);


end

end