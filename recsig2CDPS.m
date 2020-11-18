for ii = 1:(count)

    IRD = IR_Process(excsig, Data{ii}, config, ii);
    
    CDPS{ii} = IRD;
    
end

%%
filename = string(datetime,'yyyyMMdd_HH_mm_ss');
save(filename,'CDPS');

