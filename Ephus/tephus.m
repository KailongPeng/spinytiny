%% STARTUP BOILERPLATE 
%Set up a wait bar to show the progress.
wb = waitbarWithCancel(0, 'Starting ephus...', 'Name', 'Loading software...');
pos = get(wb, 'Position');
pos(2) = pos(2) - pos(4);
set(wb, 'Position', pos);
   
%% CONFIG EPHYS/ACQUIRER/STIM  (DEVICES/CHANNELS) --> Please adjust!
%Amplifier objects for ephys
patch{1} = axopatch_200B('scaledOutputBoardID', 2, 'scaledOutputChannelID', 4, 'gain_daq_board_id', 2, 'gain_channel', 1, 'mode_daq_board_id', 2, 'mode_channel', 2,  ...
    'v_hold_daq_board_id', 3,  'v_hold_channel', 3, 'vComBoardID', 3, 'vComChannelID', 0);%<<<<<<<<<<---------- CONFIG

%Acquirer channels 
acqChannelNames = {'Trial_number'};
acqBoardIDs = [2];
acqChanIDs = [5];

%Stimulator channels 
stimChannelNames = {'LED1'};
stimBoardIDs = [3];
stimChanIDs =  [1];

%% CONFIG VARS --> Please adjust!
triggerOrigin = '/dev3/port0/line0'; 
triggerDest = 'PFI1';

xsgStartDirectory = 'C:\Data\';

%% TIMING/CLOCK CONFIG --> Adjust with care...
%Set up the triggering.   
acqJob = daqjob('acquisition');
scopeJob = daqjob('scope');
setTriggerOrigin(acqJob, triggerOrigin);%Corresponds to EXSTRB on a BNC2090 on connector 0 for a PCI-6259 board.
setTriggerOrigin(scopeJob, triggerOrigin);
setTriggerDestination(acqJob, triggerDest);
setTriggerDestination(scopeJob, triggerDest);

%% START PROGRAMS --> Add/remove/configure with care...
if waitbarUpdate(0.0, wb, 'Starting experimentSavingGui...'); return; end
xsg = openprogram(progmanager,{'xsg', 'experimentSavingGui'});
setLocalBatch(progmanager, xsg, 'directory',xsgStartDirectory);
setLocal(progmanager,xsg,'autosave',1);  %turns off autosave

if waitbarUpdate(0.1, wb, 'Starting ephys...'); return; end
ep = openprogram(progmanager,'ephys',patch);

if waitbarUpdate(0.16, wb,  'Starting ephysScopeAccessory...'); return; end
openprogram(progmanager,'ephysScopeAccessory',patch);

if waitbarUpdate(0.24, wb,  'Starting stimulator...'); return; end
stim = openprogram(progmanager, 'stimulator');
stim_addChannels(stim,stimChannelNames,stimBoardIDs,stimChanIDs);

if waitbarUpdate(0.32, wb, 'Starting acquirer...');return;end
acq = openprogram(progmanager,'acquirer');
acq_addChannels(acq,acqChannelNames,acqBoardIDs,acqChanIDs);

if waitbarUpdate(0.48, wb, 'Starting pulseJacker...');return;end
openprogram(progmanager, 'pulseJacker',{ep,stim});

if waitbarUpdate(0.52, wb, 'Starting userFcns...');return;end
openprogram(progmanager, 'userFcns');

if waitbarUpdate(0.56, wb, 'Starting autonotes...');return;end
openprogram(progmanager, 'autonotes');

if waitbarUpdate(0.60, wb, 'Starting headerGui...');return;end
openprogram(progmanager, 'headerGUI');

if waitbarUpdate(0.64, wb, 'Starting HotSwitch...');return;end
openprogram(progmanager,{'hotswitch', 'hotswitch', 'hotswitch', 'hs_config', 'hs_config'});


%% DEVELOPER-CREATED USERFCNS --> Adjust with care...
%These userFcns allow developers to customize Ephus to specific applications 

if waitbarUpdate(0.84, wb, 'Setting up default (built-in) userFcns...');return;end

userFcnCBM = getUserFcnCBM;

fprintf(1, 'Default UserFcn mappings:\n');
fprintf(1, '----------------------------\n');

%% USER-CREATED USERFCNS --> Please add!
%Add userFcns here to customize Ephus yourself
%userFcns can also be added via userFcns GUI, and saved to configuration sets

if waitbarUpdate(0.86, wb, 'Setting up user-made userFcns...');return;end
fprintf(1, 'User-created UserFcn mappings:\n');
% add here!
fprintf(1, '----------------------------\n');


%% ENDING BOILERPLATE
%Load a configuration (if requested).
if waitbarUpdate(0.88, wb, 'Loading configuration...');return;end
loadConfigurations(progmanager);
fprintf(1, '\nLoading Completed.\n\n');

delete(wb); %Kill the waitbar.
fprintf(1, '\n\n-----------------------------------\n-----------------------------------\n\n\n\n\n\n\n\n');

