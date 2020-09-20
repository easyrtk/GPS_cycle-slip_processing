% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%           GUI for result display
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function varargout = DispResult(varargin)
 
% GUI for the result display
 clc
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DispResult_OpeningFcn, ...
    'gui_OutputFcn',  @DispResult_OutputFcn, ...
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

  
function DispResult_OpeningFcn(hObject, eventdata, handles, varargin)
% Initialize the GUI for result display
global vTimeStr vTime
load settings
clc
Constants
GUI_Results_ShowMethods;% List all methods selected 
GUI_Results_ShowSatellites% List all satellites available
GUI_Results_RefreshAddedCycleslips % List all cycle-slips added by the user to play with the algorithms
set(hObject,'toolbar','figure'); 
handles.output = hObject; 
guidata(hObject, handles);
 
 

function varargout = DispResult_OutputFcn(hObject, eventdata, handles)
movegui(gcf,'center');
GUI_Results_ClearAllFiguresinGui 
GUI_Results_ClearButtons
varargout{1} = handles.output;



%==============================================
function showrawdata_Callback(hObject, eventdata, handles)
 % Display raw data according to the method selected
 % This depends on the method and satellite selected
GUI_Results_ShowRawData

%============================================== 
function satellites_Callback(hObject, eventdata, handles)
% if user clicks the satellites, clear all figures, because results are
% changed for different satellites
GUI_Results_ClearAllFiguresinGui
  
%============================================== 
function methods_Callback(hObject, eventdata, handles)
% check which method is selected by the user
% different method allows different further operations, and hence there
% will be different Pushbuttons shown below
GUI_Results_ClearAllFiguresinGui % clear all figure
GUI_Results_ClearButtons % clear all button
GUI_Results_RefreshCycleslipInformation % refresh the detected and determined cycle-slips
GUI_Results_SelectMethod % show the methods available
GUI_Results_LoadResultMatrix % load results into memory to be demonstrated
GUI_Results_RefreshGeneralInformation %refresh the general information

%============================================== 
function showanalysis1_Callback(hObject, eventdata, handles)
% When user clicks the first button of "result analysis"
GUI_Results_ShowAnalysis1

%============================================== 
function showanalysis2_Callback(hObject, eventdata, handles)
% When user clicks the second button of "result analysis"
% not for all methods!
GUI_Results_ShowAnalysis2

%**********************************************************************
% Follwings are not important
%**********************************************************************

 
function satellites_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function methods_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
