% ======================================
% Cycle-slip for stand-alone GPS
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

function varargout = GUIMain(varargin)

% Main GUI
 

clc

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIMain_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIMain_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end



%=====================================================
function varargout = GUIMain_OutputFcn(hObject, eventdata, handles) 
movegui(gcf,'center');
varargout{1} = handles.output;
% Now the results are generated. I have somethig to say something before leading to
% the display of results
GUIMain_ShowAnnouncement
% Set default values
GUIMain_SetToolboxDefaultValues

%=====================================================
function GUIMain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function defines the default values shown in the GUI interface

handles.output = hObject;
guidata(hObject, handles);



%=====================================================
function run_button_Callback(hObject, eventdata, handles)
% This function reacts when user clicks the "Run"
% It summaries the input parameters and generate the output file
clc
% saveas(hObject,'main_menu.emf')

GUIMain_Constant

% check the some basic parameters given by the user
GUIMain_CheckInputParameters
% check the RINEX file
GUIMain_InputRINEX
% check the satellites selected by the user
GUIMain_CheckSatellites

% record the parameters set by the user
ToolboxSetting.totalepoch=totalepoch; % either specified by the user or the maximal number of epochs available
ToolboxSetting.interval=tbx_interval;
ToolboxSetting.std_phase=tbx_std_phase;
ToolboxSetting.std_code=tbx_std_code;
ToolboxSetting.polyfit_epochs=tbx_polyfit_epochs;
ToolboxSetting.polyfit_order=tbx_polyfit_orders;
ToolboxSetting.ionopolyfit_epochs=tbx_ionopolyfit_epochs;
ToolboxSetting.ionopolyfit_order=tbx_ionopolyfit_orders; 
ToolboxSetting.svids=SatToCheck; 
ToolboxSetting.doppler_deviation=tbx_doppler_deviation; 

% check the observations and methods selected by the user
GUIMain_CheckObservationsMethods
% add the "manually added" cycle-slips to the GPS raw data
GUIMain_AddCycleSlipIntoRawData(ToolboxSetting,rawdatafile);
save('settings','ToolboxSetting')

close all force
% Call the main program, it will impelment all methods available
mainpro;

% call another GUI to show results
close all force
% call next GUI and display the results
DispResult;
 



%**************************************************************************
% Some functions related to the button-click in the GUI
%**************************************************************************

function load_obs_button_Callback(hObject, eventdata, handles) 
% ask for the file name of RINEX
[fn, path] = uigetfile({'*.*'},'Select a RINEX obervation file');
if fn~=0,
    filename=strcat(path,fn);
    set(handles.filename,'String',filename)
end

function clear_sat_Callback(hObject, eventdata, handles)
% clear the identified satellites
set(handles.SatSelected,'String','');

function [gnss_type,sv_prn]=add_sat_Callback(hObject, eventdata, handles)
% add satellites to be checked
GUIMain_AddSatellites; 

function addcycles_Callback(hObject, eventdata, handles)
% add cycle slips
GUIMain_AddCycleslips

function all_sat_Callback(hObject, eventdata, handles)
% add satellites to be tested
GUIMain_CheckAllSatellites

 
function pushbutton8_Callback(hObject, eventdata, handles)
% show README
open('user-manual.pdf');


%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************


% following are not important 

% 
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
 


 


% --- Executes during object creation, after setting all properties.

function SatSelected_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 function filename_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
function sampling_intervals_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sampling_intervals_Callback(hObject, eventdata, handles)
%   msgbox('Hallo')
 
% function sampling_intervals_KeyPressFcn(hObject, eventdata, handles)
% set(handles.sampling_intervals,'String','');
 

%--------------------------------------------------------------------------
function totalepoch_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function totalepoch_Callback(hObject, eventdata, handles)
 
function totalepoch_KeyPressFcn(hObject, eventdata, handles)
% set(handles. totalepoch,'String','');

%--------------------------------------------------------------------------
function std_phase_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function std_phase_Callback(hObject, eventdata, handles)
 
function std_phase_KeyPressFcn(hObject, eventdata, handles)
% set(handles.std_phase,'String','');
%--------------------------------------------------------------------------
function std_code_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function std_code_Callback(hObject, eventdata, handles)
 
function std_code_KeyPressFcn(hObject, eventdata, handles)
% set(handles.std_code,'String','');
 %--------------------------------------------------------------------------
function polyfit_epochs_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function polyfit_epochs_Callback(hObject, eventdata, handles)
 
function polyfit_epochs_KeyPressFcn(hObject, eventdata, handles)
% set(handles.polyfit_epochs,'String','');

 %--------------------------------------------------------------------------
function polyfit_numorder_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function polyfit_numorder_Callback(hObject, eventdata, handles)
 
function polyfit_numorder_KeyPressFcn(hObject, eventdata, handles)
% set(handles.polyfit_numorder,'String','');

%--------------------------------------------------------------------------
function std_ratio_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function std_ratio_Callback(hObject, eventdata, handles)
 
function std_ratio_KeyPressFcn(hObject, eventdata, handles)
% set(handles.std_ratio,'String','');

%--------------------------------------------------------------------------
function ionopoly_epochs_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ionopoly_epochs_Callback(hObject, eventdata, handles)
 
function ionopoly_epochs_KeyPressFcn(hObject, eventdata, handles)
% set(handles.ionopoly_epochs,'String','');

%--------------------------------------------------------------------------
function ionopoly_order_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ionopoly_order_Callback(hObject, eventdata, handles)
 
    function ionopoly_order_KeyPressFcn(hObject, eventdata, handles)
% set(handles.ionopoly_order,'String','');

%-------------------------------------------------------------------------


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over sampling_intervals.
function sampling_intervals_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to sampling_intervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%   msgbox('Hallo')


% --- Executes on key press with focus on sampling_intervals and none of its controls.
function sampling_intervals_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to sampling_intervals (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function doppler_deviation_Callback(hObject, eventdata, handles)
% hObject    handle to doppler_deviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of doppler_deviation as text
%        str2double(get(hObject,'String')) returns contents of doppler_deviation as a double


% --- Executes during object creation, after setting all properties.
function doppler_deviation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to doppler_deviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GPSL1.
function GPSL1_Callback(hObject, eventdata, handles)
% hObject    handle to GPSL1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GPSL1


% --- Executes on button press in GPSL2.
function GPSL2_Callback(hObject, eventdata, handles)
% hObject    handle to GPSL2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GPSL2


% --- Executes on button press in polyfit_checkbox.
function polyfit_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to polyfit_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of polyfit_checkbox


% --- Executes on button press in phasecombi_checkbox.
function phasecombi_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to phasecombi_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of phasecombi_checkbox


% --- Executes on button press in doppler_checkbox.
function doppler_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to doppler_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of doppler_checkbox


% --- Executes on button press in phasecombipolyfot_checkbox.
function phasecombipolyfot_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to phasecombipolyfot_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of phasecombipolyfot_checkbox



function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




