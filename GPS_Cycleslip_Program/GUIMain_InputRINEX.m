% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

%GUIMain_InputRINEX

% check RINEX files
filename=get(handles.filename,'String');
if strcmp(filename,rinex_filename_default_str),
%     msgbox('Please identify a RINEX observation file');
filename=strcat(pwd,'\TestData\TestData.06O');
set(handles.filename,'String',filename);
[rawdatafile,totalepoch]=GUIMain_LoadRinexOBS(filename,tbx_interval,tbx_totalepoch);
%     return
else
    [rawdatafile,totalepoch]=GUIMain_LoadRinexOBS(filename,tbx_interval,tbx_totalepoch);
end
