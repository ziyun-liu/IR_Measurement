function [ ir ] = tf2ir( tf , nfft, method)
%Compute IR using transfer function
%   method == 1 include the distortion part in negetive time region 
%   method == 0 exclude the distortion part in negetive time region 

% Change Log:
% 2016-12-24    First Ed. by Liu Ziyun

if nargin < 2
    method = 0;
end

ir = ifft(tf,nfft);

if method == 0
    ir = ir(1:end/2);
end

end
