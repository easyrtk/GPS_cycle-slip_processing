 

% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% reaction when clicking the first button "show results"
% depending on different methods selected, the button might have different
% titles, and hence there might be different information to be depicted
load RawDataTemp
load settings
GUI_Results_ClearAllFiguresinGui
Constants;

% check the method selected
selected_method_id=    get(handles.methods,'Value') ;
method_strings=get(handles.methods,'String') ;
selected_method_str= method_strings{selected_method_id};
% according to the method, the buttons will be given different
% identifications
if  (strcmp(selected_method_str,all_method_str{method_dualphase_only})) 
    % method : dual-freq. combination
    GUI_Results_LoadResultMatrix % load result into memory
    axes(handles.fig_rawdata);
    svid  = get(handles.satellites,'Value');
    GUI_Results_DispDualFreqResidual(svid,mStatusMatrix,mResultMatrix,DualFreqResidualUpperBound,vTimeStr) % show dual-freq. residuals
    axes(handles.legends)
    GUI_Results_ShowLegend(1,DualFreqResidualUpperBound) % show legend
elseif (strcmp(selected_method_str,all_method_str{method_dualphase_iono}))
    % method : dual-freq. combination with iono checks
    GUI_Results_LoadResultMatrix
    axes(handles.fig_rawdata);
    svid  = get(handles.satellites,'Value');
    GUI_Results_DispIonoVariation( svid,mStatusMatrix,IonoVariation,vTimeStr) % show iono variation between epochs
    axes(handles.legends)
    GUI_Results_ShowLegend(1) % show legend
elseif (strcmp(selected_method_str,all_method_str{method_phasecodeGPSL1})) || ...
        (strcmp(selected_method_str,all_method_str{method_phasecodeGPSL2}))
    % method : phase*code combination
    GUI_Results_LoadResultMatrix
    axes(handles.fig_rawdata);
    svid  = get(handles.satellites,'Value');
    GUI_Results_DispPhaseCodeDiff( svid,mStatusMatrix,mResultMatrix,PhaseCodeDiffThreshold,mdc,vTimeStr) % show phase/code deviation
    axes(handles.legends)
    GUI_Results_ShowLegend(1,PhaseCodeDiffThreshold)    % show legend
elseif (strcmp(selected_method_str,all_method_str{method_DopplerGPSL1})) || ...
        (strcmp(selected_method_str,all_method_str{method_DopplerGPSL2}))
    % method : Doppler
    GUI_Results_LoadResultMatrix
    axes(handles.fig_rawdata);
    svid  = get(handles.satellites,'Value');
    GUI_Results_DispDopplerPhaseDiff( svid,mStatusMatrix,mResultMatrix,PhaseDopplerDiffThreshold,vTimeStr) % show doppler/phase variation
    axes(handles.legends)
    GUI_Results_ShowLegend(1,PhaseDopplerDiffThreshold)    % show legend
elseif (strcmp(selected_method_str,all_method_str{method_polynomialGPSL1})) || ...
        (strcmp(selected_method_str,all_method_str{method_polynomialGPSL2}))
    % method : phase high-order differencing
    GUI_Results_LoadResultMatrix
    axes(handles.fig_rawdata);
    svid  = get(handles.satellites,'Value');
    GUI_Results_DispDiffPhaseData(svid,mStatusMatrix,mResultMatrix,vTimeStr,length_sequence,order_diff) % show differend phase data
    axes(handles.legends)
    GUI_Results_ShowLegend(1) % show legend
end