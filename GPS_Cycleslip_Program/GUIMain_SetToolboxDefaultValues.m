% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


% Set the default values in the GUI

GUIMain_Constant

% Default values
rinex_filename_default_str='Please choose a RINEX observation file';
sat_selected_str='Default: all available satellites are to be checked';
sampling_interval_default=1;
totalepoch_default=300;
std_phase_default=0.01;
std_code_default=500/1000;
sat_used_default='Default: all available satellites are to be checked';
numepoch_for_polyfit_default=6;
order_for_polyfit_default=9999;
numepoch_for_phasecombi_default=5;
order_for_phasecombi_default=9999;
doppler_deviation=9999;
 

% default values in string
sampling_interval_default_str=sprintf('%d',sampling_interval_default);
totalepoch_default_str=sprintf('%d',totalepoch_default);
std_phase_default_str=sprintf('%3.2f ',std_phase_default);
std_code_default_str=sprintf('%d',std_code_default*1000);
numepoch_for_polyfit_default_str=sprintf('%d',numepoch_for_polyfit_default);
order_for_polyfit_default_str=sprintf('automatic');
numepoch_for_phasecombi_default_str=sprintf('%d',numepoch_for_phasecombi_default);
order_for_phasecombi_default_str=sprintf('automatic');
doppler_deviation_str=sprintf('automatic');
 

% display 
set(handles.filename,'String',rinex_filename_default_str);
set(handles.sampling_intervals,'String',sampling_interval_default_str);
set(handles.std_phase,'String',std_phase_default_str);
set(handles.totalepoch,'String',totalepoch_default_str); 
set(handles.std_code,'String',std_code_default_str);
set(handles.polyfit_epochs,'String',numepoch_for_polyfit_default_str);
set(handles.polyfit_numorder,'String',order_for_polyfit_default_str);
set(handles.ionopoly_epochs,'String',numepoch_for_phasecombi_default_str);
set(handles.ionopoly_order,'String',order_for_phasecombi_default_str);
set(handles.SatSelected,'String',sat_selected_str); 
set(handles.doppler_deviation,'String',doppler_deviation_str);  

set(handles.polyfit_checkbox,'Value',1); 
set(handles.doppler_checkbox,'Value',1); 
set(handles.phasecode_checkbox,'Value',1); 
set(handles.phasecombi_checkbox,'Value',1); 
set(handles.phasecombipolyfot_checkbox,'Value',1);  
set(handles.GPSL1,'Value',1);  
set(handles.GPSL2,'Value',1);  


ToolboxSetting.num_added_cycleslips=0;
ToolboxSetting.added_cycleslips=[]; 