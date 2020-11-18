function [ IR ] = io2ir( input, output, nfft )
%Compute IR using I/O signals of the system
%   method == 1 include the distortion part in negetive time region 

% Change Log:
% 2016-12-24    First Ed. by Liu Ziyun

method = 1;

RTF = io2tf( input, output, nfft );

IR = tf2ir( RTF , nfft, method);

end

