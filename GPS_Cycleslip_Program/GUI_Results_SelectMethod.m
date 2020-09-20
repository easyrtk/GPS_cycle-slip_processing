% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% Regarding to different method, there might be different results to be
% presented. The user will see these when clicking a specific method

Constants;

selected_method_id=    get(handles.methods,'Value') ;
method_strings=get(handles.methods,'String') ;
selected_method_str= method_strings{selected_method_id};
set(handles.showrawdata,'Visible','on');
set(handles.showrawdata,'String','Show raw data');
if  (strcmp(selected_method_str,all_method_str{method_dualphase_only}))
    % method using signal combination
    % allowed operation :
    % (1) show residuals after signal combination
    set(handles.showanalysis1,'Visible','on');
    set(handles.showanalysis1,'String','Show Dual Freq. Residuals');
    set(handles.showanalysis2,'Visible','off');
    set(handles.showanalysis2,'String','Not available');

elseif (strcmp(selected_method_str,all_method_str{method_dualphase_iono}))
    % method using ionospheric estimation
    % allowed operation :
    % (1) show estimated ionospheric delay
    % (2) show the variation of ionospheric delay between epochs
    set(handles.showanalysis1,'Visible','on');
    set(handles.showanalysis1,'String','Show estimated iono. variation');
    set(handles.showanalysis2,'Visible','on');
    set(handles.showanalysis2,'String','Show ionosphere estimates');

elseif (strcmp(selected_method_str,all_method_str{method_phasecodeGPSL1})) ,
    % method using phase/code combination L1
    % allowed operation :
    % (1) show phase/code raw data
    % (2) show the deviation between both for cycle-slip detection
    set(handles.showanalysis1,'Visible','on');
    set(handles.showanalysis1,'String','Show code/phase diff.');
    set(handles.showanalysis2,'Visible','off');

elseif (strcmp(selected_method_str,all_method_str{method_phasecodeGPSL2})) ,
    % method using phase/code combination L2
    % allowed operation :
    % (1) show phase/code raw data
    % (2) show the deviation between both for cycle-slip detection
    set(handles.showanalysis1,'Visible','on');
    set(handles.showanalysis1,'String','Show code/phase diff.');
    set(handles.showanalysis2,'Visible','off');

elseif (strcmp(selected_method_str,all_method_str{method_DopplerGPSL1})) ,
    % method using Doppler L1
    % allowed operation :
    % (1) show Doppler and between-epoch phase variation
    % (2) show deviation of both
    set(handles.showanalysis1,'Visible','on');
    set(handles.showanalysis1,'String','Show deviation');
    set(handles.showanalysis2,'Visible','off');

elseif (strcmp(selected_method_str,all_method_str{method_DopplerGPSL2})) ,
    % method using Doppler L2
    % allowed operation :
    % (1) show Doppler and between-epoch phase variation
    % (2) show deviation of both
    set(handles.showanalysis1,'Visible','on');
    set(handles.showanalysis1,'String','Show deviation');
    set(handles.showanalysis2,'Visible','off');

elseif (strcmp(selected_method_str,all_method_str{method_polynomialGPSL1})) ,
    % method using high order differencing on carrier phase L1
    % allowed operation :
    % (1) show differenced carrier phase
    % (2) show standarde deviations of the queue containing the differenced
    % phase data
    set(handles.showanalysis1,'Visible','on');
    set(handles.showanalysis1,'String','Show differenced phase data');
    set(handles.showanalysis2,'Visible','on');
    set(handles.showanalysis2,'String','Show standard deviations');

elseif (strcmp(selected_method_str,all_method_str{method_polynomialGPSL2})) ,
    % method using high order differencing on carrier phase L2
    % allowed operation :
    % (1) show differenced carrier phase
    % (2) show standarde deviations of the queue containing the differenced
    % phase data
    set(handles.showanalysis1,'Visible','on');
    set(handles.showanalysis1,'String','Show phase variation');
    set(handles.showanalysis2,'Visible','on');
    set(handles.showanalysis2,'String','Show standard deviations');
end