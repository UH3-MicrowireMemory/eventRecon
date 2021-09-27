function [] = eventCHECKtest()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



% LOAD in one of Bernards Event Files
% 


%
tempNWB=nwbRead('C:\Users\darwinm\Documents\Thompson Lab\Microwire\PatientData\MW1\NWBSaves\MLD1_Session_9_raw.nwb');

%
% Get events file for each session
eventsFile = ['C:\Users\darwinm\Documents\Thompson Lab\Microwire\PatientData\MW1\recog_3.16.21_MW1.mat'];
load([eventsFile]);
events=outData.taskinformation;
%
TIME_SCALING = (10.^(-6));
events_description = ['The events coorespond to the TTL markers for each trial. ', ...
    'For the learning trials, the TTL markers are the following: 55 = start of the experiment, ', ...
    '1 = stimulus ON, 2 = stimulus OFF, 3 = Question Screen Onset, ', ...
    '20 = Yes (21 = NO) during learning, 6 = End of Delay after Response, ', ...
    '66 = End of Experiment. For the recognition trials, the TTL markers are the following: ', ...
    '55 = start of experiment, 1 = stimulus ON, 2 = stimulus OFF, 3 = Question Screen Onset, ' ...
    '31:36 = Confidence (Yes vs. No) response, 66 = End of Experiment'];
%
% Set Events
events_ts = types.core.AnnotationSeries('data', events.TTL_ID, 'data_unit', 'NA', ...
    'timestamps', cellfun(@(x) str2double(x),events.Timestamp).*TIME_SCALING, 'description', events_description);
%
% Set Experiment IDs
experiment_ids = types.core.TimeSeries('data',cellfun(@(x) int8(str2double(x)),events.TTLvalue), 'data_unit', 'NA', ...
    'timestamps', cellfun(@(x) str2double(x),events.Timestamp).*TIME_SCALING);
%
% Assign events + Experiment IDs to NWB file (nwb.acquisition)
tempNWB.acquisition.set('events_behavior', events_ts);
tempNWB.acquisition.set('experiment_ids', experiment_ids);
%
% Save NWB file 
nwbExport(tempNWB,'C:\Users\darwinm\Documents\Thompson Lab\Microwire\PatientData\MW1\NWBSaves\MLD1_Session_9_raw.nwb');








end