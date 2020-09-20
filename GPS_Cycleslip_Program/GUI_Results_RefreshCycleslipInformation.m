% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


% Display cycle-slips information, either detected or determined (by dual-freq. combination)
 
global ToolboxSetting
load settings
Constants
GUI_Results_LoadResultMatrix


selected_method_id=    get(handles.methods,'Value') ;
method_strings=get(handles.methods,'String') ;
selected_method_str= method_strings{selected_method_id};
% in case of dual-freq. there might be cycle-slips determined, then show
% the estimated sizes
if  (strcmp(selected_method_str,all_method_str{method_dualphase_iono})) ||...
    (strcmp(selected_method_str,all_method_str{method_dualphase_only})),
    if ~isempty(cycle_repair)        
        for i=1:1:length(cycle_repair)
            % in this case, both of the detected cycle-slip and their
            % estimated sizes will be shown
            datatable(i,1:4)=[cycle_repair(i).svid cycle_repair(i).epoch cycle_repair(i).L1cycle cycle_repair(i).L2cycle];
        end
    else
        datatable=[];
    end
 
    ttstr={'Satellite PRN','Epoch','Est. Slip L1','Est. Slip L2'};
    set(handles.info_cycleslip, 'ColumnName', ttstr);
    set(handles.info_cycleslip, 'Data', datatable);
    set(handles.info_cycleslip, 'ColumnWidth','auto')
else   
    % for other methods, only detected cycle-slips
    cycleslips=[];
    num_cycleslip=0;
    for id=1:1:length(ToolboxSetting.svids),
        for epoch=1:1:ToolboxSetting.totalepoch, 
            if status_record(id,epoch)==const_detected,
                num_cycleslip=num_cycleslip+1;
                cycleslips(num_cycleslip,1:2)=[ToolboxSetting.svids(id) epoch];
            end
        end
    end     
    ttstr={'Satellite PRN','Epoch'};
    set(handles.info_cycleslip, 'ColumnName', ttstr);
    set(handles.info_cycleslip, 'Data', cycleslips);
    set(handles.info_cycleslip, 'ColumnWidth','auto')
end
