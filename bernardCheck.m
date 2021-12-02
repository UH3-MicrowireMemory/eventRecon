%% Bernard event check
clear
addpath([userpath , filesep , 'NLX_IO_Code\'])

% cd to bernard and load nev
cd('C:\Users\Admin\Dropbox\BernardTEST\BG_Events')
fname = 'Events1.nev';

[~, ~, bgTTL, ~, bgStrings, ~] =...
           Nlx2MatEV(fname, [1 1 1 1 1], 1, 1, [] );

bgTTL = transpose(bgTTL);



%% Jat event check

% cd to jat and load mat
cd('J:\01_Coding_Datasets\NLX_GUI_Tests\MW4\Behavior');
load("AMC_PY21NO04_learning_nev.mat","eventRecon");

jtTTL = eventRecon.TTL;
jtStrings = eventRecon.EventStrs;

jtTTL = transpose(jtTTL);