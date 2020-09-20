
% Main program
% call the methods available to check cycle-slips


clc

load settings


load RawDataTemp
textstr='';
title=sprintf('Cycle-slip detection is in processing....');
set(gcf,'MenuBar','none','NumberTitle','off','Name',title,...
    'Position',[400 500 450 150],'Visible','off');
movegui(gcf,'center');
hlistbox = uicontrol(gcf,'Style', 'listbox', 'String', 'Clear',...
    'Position', [0 0 450 150],'String','','Foregroundcolor','k','Backgroundcolor','w');

set(gcf,'Visible','on');
movegui(gcf,'center');

if ToolboxSetting.method_polyfit_GPSL1,
    GUIMain_WriteListbox('Method : Polynomial fitting of phase data L1 ......',hlistbox);
    Method_PhaseHighOrderDifference(1);
    GUIMain_WriteListbox('Done!',hlistbox);
end

if ToolboxSetting.method_polyfit_GPSL2,
    GUIMain_WriteListbox('Method : Polynomial fitting of phase data L2 ......',hlistbox);
    Method_PhaseHighOrderDifference(2);
    GUIMain_WriteListbox('Done!',hlistbox);
end

if ToolboxSetting.method_codephase_GPSL1,
    GUIMain_WriteListbox('Method : phase/code combination L1 ......',hlistbox);
    Method_PhaseCode(1);
    GUIMain_WriteListbox('Done!',hlistbox);
end

if ToolboxSetting.method_codephase_GPSL2,
    GUIMain_WriteListbox('Method : phase/code combination L2 ......',hlistbox);
    Method_PhaseCode(2);
    GUIMain_WriteListbox('Done!',hlistbox);
end

if ToolboxSetting.method_phasecombi_iono
    GUIMain_WriteListbox('Method : phase combination with the check of ionospheric residuals ......',hlistbox);
    Method_PhaseCombination_Iono;
    GUIMain_WriteListbox('Done!',hlistbox);
end

if ToolboxSetting.method_phasecombi
    GUIMain_WriteListbox('Method : phase combination with the ionospheric residuals ignored......',hlistbox);
    Method_PhaseCombiOnly_withrepair;
    GUIMain_WriteListbox('Done!',hlistbox);
end
if ToolboxSetting.method_doppler_GPSL1,
    GUIMain_WriteListbox('Method : Doppler check on L1......',hlistbox);
    Method_Doppler(1);
    GUIMain_WriteListbox('Done!',hlistbox);
end
if ToolboxSetting.method_doppler_GPSL2,
    GUIMain_WriteListbox('Method : Doppler check on L2......',hlistbox);
    Method_Doppler(2);
    GUIMain_WriteListbox('Done!',hlistbox);
end
close (gcf)
 
msgbox('Processing complete')


pause(0.01)