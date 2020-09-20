% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% Check the cycle-slips by differencing phase measurements with a higher
% order. The order can be determined automatically or identified by the
% user himself.
function [status,phase_differenced,std1,std2]=Method_Core_PhaseHighOrderDiff(phase_sq,time_sq,interval,order_diff,threshold)


Constants;
len=length(phase_sq)-order_diff; % length of the differenced phase series
phase_differenced=zeros(len,1); % it is used to record the differenced phase series
std1=0;
std2=0;
% check the phase data sequence and the time tags
if length(phase_sq)~=length(time_sq), 
    error('phase data and time tags do not match')
end

num_data=length(phase_sq);
% check if the phase data is complete
for i=1:1:num_data,
    if phase_sq(i)==0 ,
        status=const_incomplete;       
        return
    end
end
% check if the time tags fulfill the expected interval
for i=2:1:num_data,
    if abs(time_sq(i)-time_sq(i-1)-interval)>0.001 ,
        status=const_interrupt;
        return
    end
end

% obtain the differenced phase sequence
 if len<2,
    error('Please give a longer data queue');
end
phase_differenced=Method_Core_CalculateDifference(order_diff, phase_sq);
 
% check the a posteriori standard deviation of the differenced phase series
% std= sum of squared residuals / (dof-1)
std1=norm(phase_differenced(1:len-1))/sqrt(len-1); % without the new phase data
mean1=mean(phase_differenced(1:len-1));
std2=norm(phase_differenced(1:len))/sqrt(len); % with the new phase data
deviation=(phase_differenced(len)-mean1);

% To judge a cycle-slip
% 1. detection threshold must be exceed. This value can be tuned. A smaller value means higher sensitivity for small slips,
% however, it increase the possibility for wrong detection.
% 2. the current value should override the range bounded by the mean value
% and standard deviation of previous data
% 3. the deviation between the current data with respect to the the
% previous data should be larger than 1 

if (std2/std1>threshold ) && (deviation>3*std1) && (deviation>1),
    status=const_detected;  
else
    status=const_cycleclipfree;
end
 