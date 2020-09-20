% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% reaction when clicking the SECOND button "show results"
% depending on different methods selected, the button might have different
% titles, and hence there might be different information to be depicted

load RawDataTemp
load settings
GUI_Results_ClearAllFiguresinGui % clear all figures
Constants;

% check the method selected
selected_method_id=    get(handles.methods,'Value') ;
method_strings=get(handles.methods,'String') ;
selected_method_str= method_strings{selected_method_id};

if  (strcmp(selected_method_str,all_method_str{method_dualphase_iono}))
    % method : dual-freq. combination with iono checks
    GUI_Results_LoadResultMatrix
    axes(handles.fig_rawdata); % load result into memory
    svid  = get(handles.satellites,'Value');
    GUI_Results_DispIonoValues( svid,mStatusMatrix,IonoValue,vTimeStr) % show iono values
    axes(handles.legends) % show legend
    GUI_Results_ShowLegend(0)
elseif (strcmp(selected_method_str,all_method_str{method_polynomialGPSL1})) || ...
    (strcmp(selected_method_str,all_method_str{method_polynomialGPSL2}))
    % method : carrier phase high-order difference
    GUI_Results_LoadResultMatrix % load result into memory
    axes(handles.legends);
    GUI_Results_ShowLegend(0) % show legend
    svid  = get(handles.satellites,'Value');
    axes(handles.upperfigure1) 
    GUI_Results_DispStdDiffPhase1(svid,mStatusMatrix,mStdOld,mStdNew,vTimeStr,length_sequence,order_diff)      % show std of carrier phase
    axes(handles.upperfigure2) 
    GUI_Results_DispStdDiffPhase2(svid,mStatusMatrix,mStdOld,mStdNew,ratio,vTimeStr,length_sequence,order_diff)          % show ratio of standard deviations
end
