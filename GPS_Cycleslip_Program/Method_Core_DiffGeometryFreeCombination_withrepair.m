% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% cycle-slip detection by dual-frequency signal combinationby ignoring the
% ionospheric delay. When the cycle-slip is detected, we  try to determine
% its size in order to correct it.
function [diff,status,candidate_cycle_L1,candidate_cycle_L2]=Method_Core_DiffGeometryFreeCombination_withrepair...
    (lambda1,lambda2,phase1_cur,phase2_cur,phase1_last,phase2_last,code1_cur,code2_cur,code1_last,code2_last,time_cur,time_last,interval,std_phase,std_code)
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
%   std_phase --> standard deviation of the carrier phase (related to the
%                               threshold)
%   std_code --> standard deviation of the code data
%output parameters:
%   diff --> residual of geometry-free combination
%   status -- > status of each epoch (cycle-slip free, cycle-slip detected,
%                       incomplete, interrupted)
%   candidate_cycle_L1--> the estimated size of cycle-slip on L1
%   candidate_cycle_L2--> the estimated size of cycle-slip on L2


global const_interrupt  const_incomplete const_detected const_cycleclipfree
% check whether the expected time interval agrees with the time of current
% carrier phase and last carrier phase
if (time_cur-time_last-interval)>0.001,
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
% upper bound for cycle-slip detection
detection_threshold=4*sqrt(lambda1^2*std_phase^2+lambda2^2*std_phase^2);

delta_phase_L1=phase1_cur-phase1_last; % between-epoch phase variation
delta_phase_L2=phase2_cur-phase2_last;% between-epoch phase variation

diff=lambda1* delta_phase_L1-lambda2*delta_phase_L2;

candidate_cycle_L1=0;
candidate_cycle_L2=0;

if abs(diff)>=detection_threshold, % detected
    
    
    status=const_detected;
    % ======= cycle-slip detected, start with repair ============
    % Principle: Fix a search range containing the cycle-slip candidates, the "most likely" cycle-slip candidate
    % should yield the minimal sum of residual of the phase combination
    % when removing them from the origional phase data.
    
    % 1. Using delta-code to determine the center of the search range
    delta_code_L1=code1_cur-code1_last; 
    delta_code_L2=code2_cur-code2_last;    
    float_cycleslip_L1=(delta_code_L1-lambda1* delta_phase_L1)/(-lambda1); % center of search space
    float_cycleslip_L2=(delta_code_L2-lambda2* delta_phase_L2)/(-lambda2); % center of search space
    
    min_residuals=9999;
    % 2. The standard "size" of search range is determined by the code
    % noise in units of cycles
    search_range=ceil(4*(std_code-std_phase)/lambda1);
    % 3. Search starts
    for integer_cycle_L1=round(float_cycleslip_L1-search_range):1:round(float_cycleslip_L1+search_range),
        for integer_cycle_L2=round(float_cycleslip_L2-search_range):1:round(float_cycleslip_L2+search_range),
            phase_L1_corrected=delta_phase_L1-integer_cycle_L1;
            phase_L2_corrected=delta_phase_L2-integer_cycle_L2;
            residual_temp=abs(lambda1* phase_L1_corrected-lambda2*phase_L2_corrected);
            if residual_temp<min_residuals, % the "best" cycle-slip candidate shoule yield the smallest residuals
                min_residuals=residual_temp;
                candidate_cycle_L1=integer_cycle_L1;
                candidate_cycle_L2=integer_cycle_L2;
            end
        end
    end
    % At this step, the cycle-slip must have been detected,
    % because the residual of geometry-free combination exceeds
    % the threshold. However,  if the estimated cycle-slip values are zeros,
    % I assume that there is no cycle-slips. It happends
    % sometimes, we can translate this case in English:
    % "I found a cycle-slip, but I cannot find a better one to fit the raw phase data, therefore I doubt the detection results"
    % I think this action is correct but it is just personal
    % understanding...... I have to say, some insensitive cycle-slips like (9,7) (4,5) might not be repaired in this way.
    % (Note that they can simply escape from the detection, as they are somehow immune to the detection principles)
    % A better solution is this case is to quantify the cycle-slips
    % with Doppler data. If Doppler data says that the
    % cycle-slips on L1 and L2 are close to 9 and 7, whereas
    % the smallest residuals are given by 0 and 0 and the
    % second smallest residuals are given by 9 and 7, I would
    % say the 9 and 7 are cycle-slips rather than 0 and 0.
    % However, I assume that the occurence of "insensitive cycle-slips" is rare, 
    % so that I would trust the data does not have cycle-slips in case that the determined cycle-slips are those insensitive ones. 
    if abs(lambda1*candidate_cycle_L1-lambda2*candidate_cycle_L2)<4*(1.4*sqrt(lambda1^2+lambda2^2)*0.02), % check if these are insensitive cycle-slips
%     if (candidate_cycle_L1==0 ) && (candidate_cycle_L2==0 )
        status=const_cycleclipfree;
    end 
else
    status=const_cycleclipfree;
end

