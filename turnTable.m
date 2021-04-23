function [CR] = turnTable(tcpclient, angle)
%TURNTABLE 
if angle>0
    turn = 0;
elseif angle<0
    turn = 1;
    angle = -angle;
else
    error('angle');
end

fwrite(tcpclient,['CT+TRUNSINGLE(',num2str(turn),',',num2str(angle),');']);
idx = 0;
while(1) %Polling untile data received
    nBytes = get(tcpclient,'BytesAvailable');
    if nBytes>0
        receive = fread(tcpclient,nBytes);% read data from tcp server
        data=char(receive'); % tranform ASCII 2 str
        if contains(data,'CR+OK;')
            CR = 'CR+OK;';
        elseif contains(data,'CR+EVENT=TB_PAUSE;')
            CR = 'CR+EVENT=TB_PAUSE;';
            break;
%         elseif strcmp(data,'#')            
        else
            error(data);
        end
    end
    pause(0.1);
    idx = idx+1;
%     assert(  idx < 100, ' Turntable time out! ' );
    if (idx>100)
        break;
    end

end
CR = 0;
end

