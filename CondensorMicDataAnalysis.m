%________________________________________________________________________________________________________________________
% Written by Kevin L. Turner
% The Pennsylvania State University, Dept. of Biomedical Engineering
% https://github.com/KL-Turner
%________________________________________________________________________________________________________________________
%
%   Purpose: Analyze voltage data from the condensor microphone to identify the relative strength of the hearing range
%            frequencies. This is important as many laboratory animals can hear high-frequencies that we cannot.
%________________________________________________________________________________________________________________________
%
%   Inputs: Run the code by hitting play. You will be prompted to select a single TDMS file, and then type in the
%           the sampling rate to the command window.
%
%   Outputs: One figure with three subplots. Raw data, Power spectrum of the entire signal, and the spectrogram of the
%            power in each sound frequency as a function of time.
%
%   Last Revised: April 24th, 2019
%________________________________________________________________________________________________________________________

clear
clc

audioFile = uigetfile('*.tdms', 'Multiselect', 'off');
% samplingRate = input('Input the sampling rate: '); disp(' ')
samplingRate = 200000;
[convertedData, ~] = ConvertTDMS_CM(0, audioFile);
audioData = detrend(convertedData.Data.MeasuredData.Data, 'constant');

%% Parameters for spectral analysis
params.Fs = samplingRate;
params.tapers = [3 5];   % Tapers [n, 2n - 1]
params.pad = 1;
params.fpass = [2000 (samplingRate/2)];   % Pass band [0, nyquist] - mic isn't sensitive below 2 kHz
params.trialave = 1;
params.err = [2 0.05];
movingwin = [1 0.1];

disp('Running spectral analysis - This may take a moment.'); disp(' ')
[S_ps, f_ps, ~] = mtspectrumc_CM(audioData, params);
[S,t,f,~] = mtspecgramc_CM(audioData, movingwin, params);

% scaling for spectrogram - limits of caxis are mean of top/bottom 5% of points in spectrogram
Svec = sort(S(:), 'descend');
numSamples = floor(0.05*length(S));
cMin = mean(S(1:numSamples));
cMax =  mean(S(end-numSamples:end));

%% Summary figure(s)
figure('NumberTitle', 'off', 'Name', 'Condensor Microphone Audio');
subplot(2,1,1)
plot((1:length(audioData))/samplingRate, audioData, 'k');
title('Raw audio (voltage) data')
xlabel('Time (sec)')
ylabel('Volts (v)')

subplot(2,1,2)
loglog(f_ps, S_ps, 'k')
title('Power Spectrum')
xlabel('Frequency (Hz)')
xlim([2000 (samplingRate/2)])
ylabel('Power')

figure;
imagesc(t,f,S')
title('Audio Spectrogram')
xlabel('Time (sec)')
ylabel('Frequency (Hz)')
axis xy
caxis([cMin cMax])
colorbar

figure;
semilog_imagesc_CM(t,f,S','y')
title('Audio Spectrogram (log-scale)')
xlabel('Time (sec)')
ylabel('Frequency (Hz)')
axis xy
caxis([cMin cMax])
colorbar
