% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


%  check the observations and methods selected by the user


% check the observations available
C1=~isempty(findstr(ObsAvailable,'C1'));
D1=~isempty(findstr(ObsAvailable,'D1'));
P1=~isempty(findstr(ObsAvailable,'P1'));
P2=~isempty(findstr(ObsAvailable,'P2'));
D2=~isempty(findstr(ObsAvailable,'D2'));
L1=~isempty(findstr(ObsAvailable,'L1'));
L2=~isempty(findstr(ObsAvailable,'L2'));
if get(handles.GPSL1,'Value')==0,  % L1
    C1=0;     L1=0; D1=0; P1=0;
end
if get(handles.GPSL2,'Value')==0, % L2
    L2=0; D2=0; P2=0;
end

% Check the methods,
if get(handles.polyfit_checkbox,'Value') ,         ToolboxSetting.method_polyfit_GPSL1=L1;         ToolboxSetting.method_polyfit_GPSL2=L2; end
if get(handles.doppler_checkbox,'Value'),         ToolboxSetting.method_doppler_GPSL1= D1*L1;         ToolboxSetting.method_doppler_GPSL2= D2*L2;    end
if get(handles.phasecode_checkbox,'Value'),     ToolboxSetting.method_codephase_GPSL1=((C1*L1) || (P1*L1));     ToolboxSetting.method_codephase_GPSL2=(P2*L2); end
if get(handles.phasecombi_checkbox,'Value'),     ToolboxSetting.method_phasecombi=(L1*L2); end
ToolboxSetting.method_phasecombi_iono=ToolboxSetting.method_phasecombi;

% Doppler only for 1 hz or higher
if ToolboxSetting.interval>1,
    doppler_warn='You are trying to use Doppler data for cycle-slip detection and the sampling interval is larger than 1 second. According to where you get the Doppler data, the cycle-slips might not be properly detected with this method, especially when you extract the Doppler data from a high-rate RINEX data. Do you want to continue with your selection?'
    doppler_goon =  (questdlg(doppler_warn, 'Doppler data to be used?', 'No, do not consider Doppler data','Yes, continue with the use of Doppler data','No, do not consider Doppler data'));
    switch doppler_goon
        case 'No, do not consider Doppler data'
            ToolboxSetting.method_doppler_GPSL1=0;
            ToolboxSetting.method_doppler_GPSL2=0; 
    end    
end

