% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% cycle-slip detection by dual-frequency signal combinationby ignoring the
% ionospheric delay
function [diff,status]=Method_Core_DiffGeometryFreeCombination(lambda1,lambda2,phase1_cur,phase2_cur,phase1_last,phase2_last,time_cur,time_last,interval,std_phase,detection_threshold)
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
%    detection_threshold--> threshold
%   std_phase --> standard deviation of the carrier phase (related to the
%   threshold)
%output parameters:
%   diff --> residual of geometry-free combination
%   status -- > status of each epoch (cycle-slip free, cycle-slip detected,
%   incomplete, interrupted)


global const_interrupt  const_incomplete const_detected const_cycleclipfree
% check whether the expected time interval agrees with the time of current
% carrier phase and last carrier phase
if abs(time_cur-time_last-interval)>0.0001,
    status=const_interrupt; %% data interrupted
    diff=0;
    return
end
% check if the expected measurements found at the expected epoch
if (phase1_cur*phase2_cur==0) || (phase1_last*phase2_last==0) ,
    status=const_incomplete; %% data incomplete
    diff=0;
    return
end

% between-epoch carrier phase 
delta_phase_L1=phase1_cur-phase1_last;
delta_phase_L2=phase2_cur-phase2_last;
% residuals of phase combination
diff=lambda1* delta_phase_L1-lambda2*delta_phase_L2;

if abs(diff)>=detection_threshold, % detected    
    status=const_detected;     
else
    status=const_cycleclipfree;
end
