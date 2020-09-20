% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% calculate the between-epoch variation of carrier phase from
% (1) the measured carrier phase
% (2) the doppler
function [status,diff]=Method_Core_CalculateDopplerPhaseDiff(phase_current,phase_pre,doppler_current,doppler_pre,time_current,time_pre,interval,threshold)
% input parameters:
%      phase_current --> carrier phase on current epoch
%      phase_pre --> carrier phase on last epoch
%      doppler_current --> Doppler data on current epoch
%      doppler_pre --> Doppler data on last epoch
%      time_current --> time  of current epoch
%      time_pre --> time of last epoch
%      interval -->  expected sampling interval
%      threshold --> threshold for identifying a cycle-slip
%
%output parameters:
%      status -- > status of each epoch (cycle-slip free, cycle-slip detected, incomplete, interrupted)
%      diff --> deviation between between-epoch carrier phase and Doppler

Constants;

%  sampling interval
delta_t=time_current-time_pre;
% check whether the expected time interval agrees with the time of current
% carrier phase and last carrier phase
if abs(delta_t-interval)>0.001,
    status=const_interrupt; %% data interrupted
    diff=0;
    return
end
% check if the expected measurements found at the expected epoch
if (phase_current==0) || (phase_pre==0) || (doppler_current==0) ||  (doppler_pre==0) ,
    status=const_incomplete; %% data incomplete
    diff=0;
    return
end

phase_diff=phase_pre-phase_current; % between epoch phase variation
doppler_prediction=(doppler_pre+doppler_current)/2*delta_t; % predicted phase variation from doppler
 
 
diff=abs(phase_diff) - abs(doppler_prediction); 
% =======================
% following threshold is used to check the deviation
% I assume if the sampling rate is 1 Hz, phase data estimated by Doppler
% can be accurate to 1 cycle.
% if sampling interval is large, it is difficult to reflect the phase
% variation using Doppler.
% Please tune it according to the application scenarios
 
if abs(diff)>threshold,
    status=const_detected;
else    
    status=const_cycleclipfree;    
end