% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% Add cycle-slip to carrier phase raw data
% the manually added cycle-slips will not affect the RINEX
% It will be added to the internal data base

global ToolboxSetting

while(1)
    prompt = {'Enter GNSS types: GPS (Currenly only GPS)','Enter PRN code (1~32)','Enter signal frequency (L1 or L2)','Enter the starting epoch','Enter cycles to be added (must be a non-zero integer)'};
    dlg_title = 'Add satellites for cycle-slip detection';
    num_lines = 1;
    def = {'GPS','0','L1','0','0'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer),
        return
    end
    gnss_type=answer{1};
    sv_prn=str2num(answer{2});
    freq_selected=answer{3};
    starting_epoch= (str2num(answer{4}));
    add_cycles=str2num(answer{5});
    if (~strcmp(gnss_type,'GPS') || (sv_prn<1) || (sv_prn>32)) ,
        uiwait(msgbox('Note that: currently only GPS satellites are processable and a PRN code ranges from 1 to 32'));
    elseif (~strcmp(freq_selected,'L1')) && (~strcmp(freq_selected,'L2')),
        uiwait(msgbox('Frequency must be either L1 or L2'));
    elseif (add_cycles==0) || (add_cycles~=round(add_cycles))
        uiwait(msgbox('Add cycle must be a non-zero integer value'));
    elseif starting_epoch~=round(starting_epoch) || starting_epoch<=0,
        uiwait(msgbox('The starting epoch for a cycle-slip should be a positive integer value'));
    else
        break;
    end
end
if isempty(ToolboxSetting.num_added_cycleslips),
    ToolboxSetting.num_added_cycleslips=1;
else
    ToolboxSetting.num_added_cycleslips=ToolboxSetting.num_added_cycleslips+1;
end
ToolboxSetting.added_cycles(ToolboxSetting.num_added_cycleslips).gnsstype=gnss_type;
ToolboxSetting.added_cycles(ToolboxSetting.num_added_cycleslips).svid=sv_prn;
ToolboxSetting.added_cycles(ToolboxSetting.num_added_cycleslips).frequency=freq_selected;
ToolboxSetting.added_cycles(ToolboxSetting.num_added_cycleslips).value=add_cycles;
ToolboxSetting.added_cycles(ToolboxSetting.num_added_cycleslips).start_epoch=starting_epoch;
clear text_disp
text_disp={};

% Display all "synthetic" cycyle-slips in order to remind the user
text_disp{1}=sprintf('============ you have added the following cycle-slips ==============\n');
for j=1:ToolboxSetting.num_added_cycleslips,
    text_disp{1+j}=sprintf('On Sat PRN=%d, a slip of %d cycle(s) is added starting from no.%d epoch and remains at the following epochs\n',...
       ToolboxSetting.added_cycles(j).svid,...
       ToolboxSetting.added_cycles(j).value,...
       ToolboxSetting.added_cycles(j).start_epoch);
end
msgbox(text_disp)
