% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% apply the high-order difference to the ionosphere delay
function [deviation,status]=Method_Core_IonoHighOrderDiff(data_history,current_value,interval,order_difference,threshold)
% input parameters:
%   data_history --> the previous data queue
%   current_value --> the current data
%   interval --> expected sampling interval
%   order_difference --> oder of differencing to be applied
%   threshold --> detection threshold
Constants

len=length(data_history)-order_difference; % length of the differenced phase series
% calculate the high-order differenced "between-epoch" ionospheric residuals
iono_residual_differenced=Method_Core_CalculateDifference(order_difference, data_history);
% calculate the mean value of previous iono residualsmeanval=mean(iono_residual_differenced);
meanval=mean(iono_residual_differenced);
stdval=std(iono_residual_differenced); % standard deviation, not used however.
% check the deviation between the current data and the mean value of
% previous data
deviation=current_value-meanval;

% if the deviation larger than threshold, it could be a cycle-slip 
% the threshold can be derived from the stanard deviation of the carrier
% phase thermal noise. 
%detection_threshold=4*sqrt(lambda1^2*std_phase1^2+lambda2^2*std_phase2^2);"
% Another solution is to check the deviation with respect to the standard
% deviation derived from the previous ionospheric residuals. This sounds
% more reasoable, but I found lots of problems to play with this algorithm
if deviation>threshold,
    status=const_detected;
else
    status=const_cycleclipfree;
end
                
                
                