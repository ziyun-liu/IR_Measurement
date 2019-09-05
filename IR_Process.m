function IRD=IR_Process(excsig, recsig_cell, config, position)
%% IR Processing
IR = cell(size(config.Rec_in_chn,2),size(config.out_chn_select,2));

for k = 1:config.N_measure
    for i = 1:size(config.Rec_in_chn,2) 
        IR_tmp = ir_prc(excsig,cell2mat(recsig_cell(k)),config);
        IR(i,k) = {IR_tmp(:,i)};
    end
end

%% Export to IRD
IRD.config = config;
IRD.fs = config.fs;
IRD.length = config.sweep_length;
IRD.IR = IR;
IRD.position = position;
IRD.date = datetime;

IRD.idx = config.out_chn_select;
IRD.idx_type = 'L,R';

IRD.note = 'LIR & NIR in Demo Room';

% oct_sm = 12;
% peek_IRD_cell( IRD , oct_sm );

filename = string(datetime,'yyyyMMdd_HH_mm_ss');
save(filename,'IRD');

end