% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


% Display "manually" added cycle-slips

DataAddedCycleSlips=[];
load settings
global ToolboxSetting

for i=1:1:ToolboxSetting.num_added_cycleslips
    svid=(ToolboxSetting.added_cycles(i).svid); % prn
    signal=str2num(ToolboxSetting.added_cycles(i).frequency(2)); % L1 or L2
    cycle=(ToolboxSetting.added_cycles(i).value); % size of cycle-slip
    epoch=(ToolboxSetting.added_cycles(i).start_epoch); % starting epoch
    DataAddedCycleSlips(i,1:4)=[svid epoch signal cycle ]; 
end

set(handles.add_cycleslips_list,'Visible','on'); % show added cycles-slips
set(handles.add_cycleslips_list, 'ColumnName', { 'SV PRN','Starting Epoch', 'Signal (L1/L2)', 'Cycles'});
set(handles.add_cycleslips_list, 'Data', DataAddedCycleSlips);