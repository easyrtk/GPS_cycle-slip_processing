% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

 %GUI_Results_RefreshGeneralInformation 
 
 
% Display general information
 
global vTimeStr vTime
load settings
% GUI_Results_ClearAllFiguresinGui
if ~isempty(status_record)
    datatable=GUI_Results_GenerateDataTable(status_record,ToolboxSetting.svids);
else
    datatable=[];
end
set(handles.info_general, 'Data', datatable);
ttstr={'Satellite PRN','Cycle-slips','Undetected Epochs','Interrupted Epochs'};
set(handles.info_general, 'ColumnName', {'SV PRN', 'Cycle-slips', 'Undetected|Epochs', 'Interrupted|Epochs'},'RearrangeableColumns','on');
ps= ToolboxSetting.svids(get(handles.satellites,'Value'));

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% If the number of detected cycle-slips is more than 3%, I assume that this
% method is not suitable for that set of raw data
% A warning will be shown!
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for i=1:1:length(ToolboxSetting.svids)
    if datatable(i,2)/ToolboxSetting.totalepoch>0.03,
        disstr=sprintf('For Sat PRN=%d, there are %d cycle-slips detected, which is larger than 3%% of total number of data. It is recommended to check again whether this algorithm fits the data!!!',ToolboxSetting.svids(i),datatable(i,2));
        uiwait(msgbox(disstr))
    end
end