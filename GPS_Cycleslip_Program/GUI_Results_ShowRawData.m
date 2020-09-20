% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% show raw data of carrier phase
load RawDataTemp
load settings
GUI_Results_ClearAllFiguresinGui;

Constants;
GUI_Results_LoadResultMatrix
 
svid  = ToolboxSetting.svids(get(handles.satellites,'Value'));
selected_method_str= method_strings{selected_method_id};
axes(handles.fig_rawdata);
% the display of raw data depends on the method selected
GUI_Results_DisplayPhaseRawData(svid,vTimeStr,selected_method_str)
