% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


% calculate the between-epoch variation of ionospheric delay
% as well as the ionosperic correction 
function [iono_diff,iono_value,status]=Method_Core_calculate_iono_residuals(lambda1,lambda2,phase1_cur,phase2_cur,phase1_last,phase2_last,time_cur,time_last,interval)
% input parameters:
%    lambda1  -->wavelength of L1
%    lambda 2 --> wavelength of L2
%    phase1_cur --> carrier phase on current epoch L1
%    phase2_cur --> carrier phase on current epoch L2
%    phase1_last --> carrier phase on last epoch L1
%    phase2_last --> carrier phase on last epoch L2
%    time_cur --> current time 
%    time_last -->last time epoch
%    interval --> expected sampling interval
%output parameters:
%   iono_diff --> estimated between-epoch ionosphere variation
%   iono_value --> estimated ionosphere delay
%   status -- > status of each epoch (cycle-slip free, cycle-slip detected,
%   incomplete, interrupted)

global const_interrupt  const_incomplete  const_normal

% check whether the expected time interval agrees with the time of current
% carrier phase and last carrier phase
if abs(time_cur-time_last-interval)>0.001,
    status=const_interrupt; %% data interrupted
    iono_diff=0;    
    iono_value=0;
    return
end

% check if the expected measurements found at the expected epoch
if (phase1_cur*phase2_cur==0) || (phase1_last*phase2_last==0) ,  
    status=const_incomplete; %% data incomplete
    iono_diff=0;    
    iono_value=0;
    return
end

delta_L1=phase1_cur-phase1_last;
delta_L2=phase2_cur-phase2_last;
% between epoch ionospheric variation
iono_diff=-(lambda1* delta_L1-lambda2*delta_L2)*lambda1^2/(lambda1^2-lambda2^2);  
% ionospheric correction calculated by signal combination
iono_value=-(lambda1* phase1_cur-lambda2*phase2_cur)*lambda1^2/(lambda1^2-lambda2^2);
status=const_normal;
