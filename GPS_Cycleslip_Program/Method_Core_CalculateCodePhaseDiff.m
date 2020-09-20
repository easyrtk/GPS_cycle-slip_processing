% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% calculate the inconsistence of the delta-code and delta-phase (namely cycle-slip). 
% delta-code can be accurate to several to several tens of cycles. It is
% surely not sensitive to small slips but might be good for large slips.
% the detetion threshold is mainly dependent on the quality of code data 
% this threshold can of course be tuned.

function [status,diff]=Method_Core_CalculateCodePhaseDiff(phase_current,phase_pre,code_current,code_pre,time_current,time_pre,interval,wavelength,std_code,threshold)
% input parameters:
%      phase_current --> carrier phase on current epoch
%      phase_pre --> carrier phase on last epoch
%      code_current --> pseudorange data on current epoch
%      code_pre --> pseudorange data on last epoch
%      time_current --> time  of current epoch
%      time_pre --> time of last epoch
%      wavelength --> wavelength of the signal
%      std_code --> standard deviation of pseudorange 
%      threshold --> threshold for identifying a cycle-slip
%
%output parameters:
%      status -- > status of each epoch (cycle-slip free, cycle-slip detected, incomplete, interrupted)
%      diff --> deviation between carrier phase and code data

global const_interrupt const_incomplete const_detected const_cycleclipfree const_normal

delta_t=time_current-time_pre;
% check whether the expected time interval agrees with the time of current
% carrier phase and last carrier phase
if abs(delta_t-interval)>0.001,
    status=const_interrupt; %% data interrupted
    diff=0;
    return
end
% check if the expected measurements found at the expected epoch
if (phase_current==0) || (phase_pre==0) || (code_current==0) ||  (code_pre==0) ,
    status=const_incomplete; %% data incomplete
    diff=0;
    return
end

% calculate delta-phase and delta-code
phase_diff=phase_pre-phase_current;
code_diff=code_pre-code_current;

% the deviation between delta-phase and delta-code
diff=(phase_diff*wavelength-code_diff);

% check the consistency of the delta-code and delta-phase 
% and assign the corrsponding status
if abs(diff)>threshold,
    status=const_detected;
else
    status=const_cycleclipfree;
end