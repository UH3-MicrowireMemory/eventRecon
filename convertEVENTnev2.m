function [] = convertEVENTnev2(loadLOC , saveLOC , caseNAME , session)
%convertEVENTnev
%   Load in NEV file and text file for specific Learning or memory epoch
%   Save out structure with restructure TTL, timestamps and strings

addpath('C:\Users\John\Documents\GitHub\NLX-Event-Viewer\NLX_IO_Code');

cd(loadLOC)

% Find .nev file
nevDi = dir('*.nev');
nevDu = {nevDi.name}; 

% LEARNING EVENT File
% LOAD in and clean up JAT NLX file
[oldTS, oldEpochIDs, oldTTLs, ~, oldStrings, oldHeader] =...
           Nlx2MatEV(nevDu{1}, [1 1 1 1 1], 1, 1, [] );

% Index for Start Recording
startIINd = 196;
ttlSSS = 199:1202;
stopIINd = 1203;

newTS = oldTS([startIINd , ttlSSS , stopIINd]);
newStrings = oldStrings([startIINd , ttlSSS , stopIINd]);
ttlStrings = matches(newStrings,'ttl');
newTS2 = newTS(ttlStrings);


% Extract TTLs
% ttlINDEX_old = logical(oldTTLs);
% newTS = oldTS(ttlINDEX_old);
% newStrings = oldStrings(ttlINDEX_old);

% Find txt file
textDi = dir('*.txt');
textDu = {textDi.name}; 

% Load JAT Learn TXT
% Look for more than one txt
if length(textDu) > 1

    allTxt = table;
    for ti = 1:length(textDu)
        tmpTab = readtable(textDu{ti});
        allTxt = [allTxt ; tmpTab]; %#ok<AGROW> 
    end
    learnTAB = allTxt;

else
    learnTAB = readtable(textDu{1});
end


newStrings2 = reconEVENT(learnTAB);
newTTLs = transpose(learnTAB.Var2);
eventRecon = struct;
% if ~(length(newTS) == 502) || ~(length(newTS) == 1004)
% 
%     keyboard
%     % MAJOR offset point is the start of new SESSION
%     %
% %     [~ , maxPOINT] = max(diff(newTS));
% %     maxIND = maxPOINT + 1;
% 
%     startIND = find(matches(oldStrings,'ttl'),1,'first');
% 
%     % b + 1:end ===== 2nd session
%     newTS2b = newTS(startIND:startIND+499);
% %     newTS2a = newTS(maxPOINT-501:maxPOINT);
% %     newTS2 = [newTS2a , newTS2b];
% 
%     newTS2 = newTS2b;
%     disp(['Length of vec is ' , num2str(length(newTS2))])
%     %     newTS2 = newTS(1:length(newTS) ~= b);
%     eventRecon.TS = newTS2;
% else
%     eventRecon.TS = newTS;
% end

eventRecon.TS = newTS2;
% Create Save structure
eventRecon.Header = oldHeader;
eventRecon.TTL = newTTLs;
eventRecon.EventStrs = newStrings2;
eventRecon.EpochIDs = newTTLs;

cd(saveLOC)

saveNAME = [caseNAME , '_' , session , '_nev.mat'];

save(saveNAME , "eventRecon");


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