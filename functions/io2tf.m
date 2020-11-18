function [ RTF ] = io2tf( input, output, nfft )
% Compute Transfer Function unsing I/O signals of the system
% Change Log:
% 2016-12-24    First Ed. by Liu Ziyun

in_fft = fft(input,nfft);       % input Signal FFT

out_fft = fft(output,nfft);     % output Signal FFT

RTF = out_fft./in_fft;          % Two-side Transfer Function

end

