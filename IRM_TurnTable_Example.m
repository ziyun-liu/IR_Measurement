%% Manual Measurement
count = 200; 

use_TurnTable = 1;
TurnTable_No = 2;
%%
Data = cell(count,1);

%% Turntable connect
if(use_TurnTable)
    if TurnTable_No == 1        
        u = udp('192.168.1.177',8888);
        fopen(u);
    elseif TurnTable_No == 2
        dAngle = 1.8;
        angle = dAngle*count;
        tcpclient = tcpip('192.168.181.181',8181, 'Timeout', 60,'OutputBufferSize',10240,'InputBufferSize',10240);
        fopen(tcpclient);
        fwrite(tcpclient,'CT+SPKMUTE(1);');
        fwrite(tcpclient,'CT+HEARTBEAT(0);');
    else
        error('No such TurnTable_No.');
    end
end
%% Measurement Go
% pause(10);
tic;
for ii = 1:(count)
    %% Measurement
    [ recsig_cell, excsig ] = IRM_CoreAudio( config );

    %% Turntable Op.
    if(use_TurnTable)
        if TurnTable_No == 1
            pause(0.5);
            fwrite (u,'1');
            flag = 1;
            while flag
                Check = 'none';
                Check = fscanf(u,'%s');
                if (strcmp(Check,'done'))
                    flag = 0;
                end
            end
        elseif TurnTable_No == 2
            pause(0.1);
            turnTable(tcpclient, dAngle);            
        else
            error(' No such TurnTable_No.');
        end
    end
    %% Fetch Result
    
    Data{ii} = recsig_cell;
    
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
    if TurnTable_No == 1        
        fclose(u);
    elseif TurnTable_No == 2
        pause(0.5);
        turnTable(tcpclient, -angle);
        fclose(tcpclient);
        delete(tcpclient);
    else
        error(' No such TurnTable_No.');
    end
end