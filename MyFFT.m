function [Amplitude,frequency] = MyFFT(SignalVector, SampleFrequency, MaxDisplayFrequency, figurenumber  )

% function [Amplitude,frequency] = MyFFT(SignalVector, SampleFrequency, MaxDisplayFrequency , figurenumber, )
% if figurenumber is 0, no plot will be carried out
% MaxDisplayFrequency is the x-axis maximum (display only)

Spectrum=fft(SignalVector);

PowerSpectrum=(Spectrum.*conj(Spectrum))/(length(Spectrum));
Amplitude=PowerSpectrum(2:(length(Spectrum)/2 + 1));
Amplitude=Amplitude/max(Amplitude);
frequencyincrement=SampleFrequency/length(Spectrum);
frequency=SampleFrequency*(1:(length(Spectrum)/2))/length(Spectrum);
maxDisplayIndex=length(Spectrum)/2 - 1;


if (MaxDisplayFrequency < SampleFrequency/2) % check if Nyquist would be happy
    % adjust the display to the desired frequency range
    maxDisplayIndex=ceil(MaxDisplayFrequency/frequencyincrement);
end


if (figurenumber ~= 0)
    
    figure(figurenumber)
    plot(frequency(1:maxDisplayIndex), Amplitude(1:maxDisplayIndex));
    title('FFT Power Spectrum')
    xlabel('Frequency / Hz')
    ylabel('Normalised Amplitude')
end