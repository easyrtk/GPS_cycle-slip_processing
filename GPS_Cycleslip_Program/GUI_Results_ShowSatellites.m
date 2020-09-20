% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% List all satellites selected by the user
for i=1:1:length(ToolboxSetting.svids),
    sv_list_str{i}=sprintf('GPS %2d',ToolboxSetting.svids(i));
end
set(handles.satellites,'String',sv_list_str,	'Value',1); 