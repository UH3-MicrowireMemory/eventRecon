function [] = eventCHECKtest()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

addpath('C:\Users\Admin\Documents\Github\NLX-Event-Viewer\NLX_IO_Code');

locs.BG_dataLOC = 'C:\Users\Admin\Dropbox\BernardTEST\BG_Events';
locs.JAT_dataLOC = 'C:\Users\Admin\Dropbox\BernardTEST\JAT_Events';


% LEARNING EVENT File
% LOAD in and clean up JAT NLX file
cd(locs.JAT_dataLOC)
[L_J_TS, L_Eids, L_J_TTLs, ~, L_J_EStrss, L_J_He] =...
           Nlx2MatEV('Events_0026.nev', [1 1 1 1 1], 1, 1, [] );

% Extract TTLs
ttlIND_LJ = logical(L_J_TTLs);
L_J_TSn = L_J_TS(ttlIND_LJ);
L_J_EStn = L_J_EStrss(ttlIND_LJ);


% Load JAT Learn TXT
cd(locs.JAT_dataLOC)
learnTAB = readtable('Learning3.16.21.MW1.txt');
L_J_EStre = reconEVENT(learnTAB);
L_J_TTLn = transpose(learnTAB.Var2);


save('MW1_Learn.mat',"L_J_EStre","L_J_TTLn","L_J_TSn","L_J_He");



% LOAD in one of Bernards Event Files
cd(locs.BG_dataLOC)
[L_B_TS, L_Eids, L_B_TTLs, ~, L_B_EStrss, ~] =...
           Nlx2MatEV('Events1.nev', [1 1 1 1 1], 1, 1, [] );

% Extract TTLs
ttlIND_LB = L_B_TTLs ~= 0;
L_B_TTLn = L_B_TTLs(ttlIND_LB);
L_B_TSn = L_B_TS(ttlIND_LB);
L_B_EStn = L_B_EStrss(ttlIND_LB);

% 55, 1, 2, 3, 20, 21, 6, 66
% Convert to values and extract Learning
% hex2dec(extractBetween(L_B_EStn,'(',')'))
% learnIND = ismember(L_B_TTLn,[55 , 66])
learnIND = [ find(L_B_TTLn == 55,1,'first') ; find(L_B_TTLn == 66,1,'first')];
% START = 1, TRIALS = 500 , STOP = 1; Total = 502



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
    '20 = Yes (21 = NO) during learning, 6 = End of Delay after Response, ', ['66 = End of Experiment;' ...
    'For the recognition trials, the TTL markers are the following: '], ...
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








function [new_EStn] = reconEVENT(indTab)


new_EStn = cell(height(indTab),1);
for ti = 1:height(indTab)

    hexV = dec2hex(indTab.Var2(ti));

    if length(hexV) == 2
        heXStr = ['0x00',hexV];
    else
        heXStr = ['0x000',hexV];
    end

    new_EStn{ti} = ['TTL Input on AcqSystem1_0 board 0 port 2 value (',...
        heXStr,').'];



end


end




