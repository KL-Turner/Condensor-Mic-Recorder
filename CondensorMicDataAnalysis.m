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

audioFile = uigetfile('*.tdms', 'Multiselect', 'off');
[convertedData, ~] = ConvertTDMS_CM(0, audioFile);
audioData = convertedData.Data.MeasuredData.Data;
samplingRate = input('Input the sampling rate: '); disp(' ')

params.Fs = samplingRate;
params.fpass = [100 1/samplingRate];
params.tapers = [3 5];
params.err = [2 0.95];
movingwin = [5 1/5];

disp('Running spectral analysis...'); disp(' ')
[S_ps, f_ps, ~] = mtspectrumc_CM(audioData, params);
[S, t, f, ~] = mtspecgramc(audioData, movingwin, params);

figure('NumberTitle', 'off', 'Name', 'Condensor Microphone Audio');
subplot(3,1,1)
plot((1:length(audioData))/samplingRate, audioData, 'k');
title('Raw audio (voltage) data')
xlabel('Time (sec)')
ylabel('Volts (v)')

subplot(3,1,2)

subplot(3,1,3)
