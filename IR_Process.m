function IRD=IR_Process(excsig, recsig_cell, config, position)
%% IR Processing
IR = cell(size(config.Rec_in_chn,2),config.N_measure);

for k = 1:config.N_measure
    for i = 1:size(config.Rec_in_chn,2) 
        IR_tmp = ir_prc(excsig,cell2mat(recsig_cell(k)),config);
        IR(i,k) = {IR_tmp(:,i)};
    end
end

%% Export to IRD
IRD.config = config;
IRD.fs = config.fs;
IRD.length = size(IR_tmp,1);
IRD.IR = IR;
IRD.position = position;
IRD.date = datetime;

IRD.idx = config.out_chn_select;
IRD.idx_type = '';

IRD.note = '';

% oct_sm = 12;
% peek_IRD_cell( IRD , oct_sm );
%%
if "maci64" == computer('arch')
    slash = '/';
else 
    slash = '\';
end

actpath = cd;   

if ~exist('IRD_Data','dir')
    mkdir('IRD_Data');
end

filename = string(datetime,'yyyyMMdd_HH_mm_ss');
path = [actpath,slash,'IRD_Data',slash, filename, '.mat'];

save(join(path,''),'IRD');

end