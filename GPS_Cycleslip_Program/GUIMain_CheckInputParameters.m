% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% Check the given total epoch
[tbx_totalepoch,status]=GUIMain_Check_Input(handles.totalepoch,totalepoch_default_str,totalepoch_default);

if  (tbx_totalepoch~=round(tbx_totalepoch)) ||  (tbx_totalepoch<0) || (status==0),
    msgbox('The number of epochs should be a positive integer number')
    return    
end
    
% Check intervals
% set(handles.sampling_intervals,'String',std_code_default);
[tbx_interval,status]=GUIMain_Check_Input(handles.sampling_intervals,sampling_interval_default_str,sampling_interval_default);

if  (tbx_interval<0) || (status==0),
    msgbox('Please input a reasonable sampling interval')
    return    
end 

% check std of phase
[tbx_std_phase,status]=GUIMain_Check_Input(handles.std_phase,std_phase_default_str,std_phase_default);

if  (tbx_std_phase<0) || (status==0),
    msgbox('Standard deviation of carrier phase noise should be a positive value in units of mm')
    return    
end 

% check std of code
[tbx_std_code,status]=GUIMain_Check_Input(handles.std_code,std_code_default_str,std_code_default);

if  (tbx_std_code<0) || (status==0),
    msgbox('Standard deviation of pseudorange (code) noise should be a positive value in units of mm')
    return    
end 

% check   polyfit epochs
[tbx_polyfit_epochs,status]=GUIMain_Check_Input(handles.polyfit_epochs,numepoch_for_polyfit_default_str,numepoch_for_polyfit_default);

if  (tbx_polyfit_epochs<0) || (status==0) || (tbx_polyfit_epochs~=round(tbx_polyfit_epochs)),
    msgbox('Number of epochs used for polynomial fitting should be a positive integer value')
    return    
end 

% check deviation of measured and estimated carrier phase using doppler
[tbx_doppler_deviation,status]=GUIMain_Check_Input(handles.doppler_deviation,doppler_deviation_str,doppler_deviation);

if  (tbx_doppler_deviation<0) || (status==0 ) 
    msgbox('The deviation of measured carrier phase and estimated carrier phase using doppler should be a positive value in units of cycles')
    return    
end 


% check   polyfit orders
[tbx_polyfit_orders,status]=GUIMain_Check_Input(handles.polyfit_numorder,order_for_polyfit_default_str,order_for_polyfit_default);

if  (tbx_polyfit_orders<0) || (status==0) || (tbx_polyfit_orders~=round(tbx_polyfit_orders)),
    msgbox('Number of orders used for polynomial fitting should be a positive integer value')
    return    
end 

% check  num of epochs for ionosperic residuals
[tbx_ionopolyfit_epochs,status]=GUIMain_Check_Input(handles.ionopoly_epochs,numepoch_for_phasecombi_default_str,numepoch_for_phasecombi_default);

if  (tbx_ionopolyfit_epochs<0) || (status==0) || (tbx_ionopolyfit_epochs~=round(tbx_ionopolyfit_epochs)),
    msgbox('Number of epochs used for polynomial fitting of dual-freq. ionosphere residuals should be a positive integer value')
    return    
end 

% check  num of orders for ionosperic residuals
[tbx_ionopolyfit_orders,status]=GUIMain_Check_Input(handles.ionopoly_order,order_for_phasecombi_default_str,order_for_phasecombi_default);

if  (tbx_ionopolyfit_orders<0) || (status==0) || (tbx_ionopolyfit_orders~=round(tbx_ionopolyfit_orders)),
    msgbox('Number of orders used for polynomial fitting of dual-freq. ionosphere residuals should be a positive integer value')
    return    
end 
 
