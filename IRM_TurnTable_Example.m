%% Manual Measurement
% measure=Calculate(Room); 
count = 200; 
% Motorprepare(Room); 
% pause;
use_TurnTable = 1;
%%
Data = cell(count,1);

%% TurnTable Prepare  
if(use_TurnTable)
    u = udp('192.168.1.177',8888); 
    fopen(u);
end
%% Measurement Go
% pause(10);
tic;
for ii = 1:(count)
    %% Measurement
    [ recsig_cell, excsig ] = IRM_CoreAudio( config );
%       [ recsig_cell, excsig ] = IRM_CoreAudio_filter( config );

    %% Parallel
    position = ii;
    if config.usingParallel
        f = parfeval(p,@IR_Process,1,excsig, recsig_cell, config, position);
    end
        
    %% Motor Op.
%         if(ii~=count)
%             Motormove(Room,measure,ii);
%         end

    %% Turntable Op.
    if(use_TurnTable)
        fwrite (u,'1');
        flag = 1;
        while flag
            Check = 'none';
            Check = fscanf(u,'%s');
            if (strcmp(Check,'done'))
                flag = 0;
            end
        end
%         pause(0.5)
%         fwrite (u,'1');
%         flag = 1;
%         while flag
%             Check = 'none';
%             Check = fscanf(u,'%s');
%             if (strcmp(Check,'done'))
%                 flag = 0;
%             end
%         end
    end
    %% Fetch Result
    if config.usingParallel
        IRD = fetchOutputs(f);
    else
        IRD = IR_Process(excsig, recsig_cell, config, position);
    end
    
    Data{ii} = IRD;
    
    if(~use_TurnTable)
        peek_IRD_cell_noSm(IRD,3);
    end

    fprintf('Measured \t %d \t of %d \n' ,ii,count);
    
    if(ii<count && ~use_TurnTable)
        pause;
    end
    
end
toc;
%%
filename = string(datetime,'yyyyMMdd_HH_mm_ss');
save(filename,'Data');
%% TurnTable
if(use_TurnTable)
    fclose(u);
end