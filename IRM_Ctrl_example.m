%% Manual Measurement
% measure=Calculate(Room); 
count = 3; 
% Motorprepare(Room); 
% pause;

Data = cell(count,1);
%% Measurement Go
% pause(10);
tic;
for ii = 1:(count)
    % Measurement
    [ recsig_cell, excsig ] = IRM_CoreAudio( config );
     
    % Parallel
    position = ii;
    if config.usingParallel
        f = parfeval(p,@IR_Process,1,excsig, recsig_cell, config, position);
    end
        
    % Motor Op.
%         if(ii~=count)
%             Motormove(Room,measure,ii);
%         end

    % Move Turntable
%     for j = 1:5
%     fwrite (u,'1');
%     flag = 1;
%         while flag
%             Check='none';
%             Check = fscanf(u,'%s');
%             if (strcmp(Check,'done'))
%                 flag = 0;
%             end
%         end
%     end

    % Fetch Result
    if config.usingParallel
        IRD = fetchOutputs(f);
    else
        IRD = IR_Process(excsig, recsig_cell, config, position);
    end
    
    Data{ii} = IRD;
    peek_IRD_cell(IRD,3);

    fprintf('Measured \t %d \t of %d \n' ,ii,count);
    
    if(ii<count)
        pause;
    end
end
toc;
