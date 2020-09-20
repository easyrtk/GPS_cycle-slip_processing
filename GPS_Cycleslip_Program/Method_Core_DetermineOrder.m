% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

function order_selected=Method_Core_DetermineOrder(data,length_sequence)

% automatic determination of order of differencing
% principle: a proper order should yield the difference between sampling
% epochs as small as possible, smaller than that obtained from an order
% higher and an order lower

% Example:
% we have
% [-22907380.2514900,-22915010.4984900,-22922630.6704900,-22930240.6714900,-22937840.3694900,-22945430.0374900,-22953009.4474900,-22960578.7984900,-22968137.8924900,-22975686.7474900;]
% first order differencing yields:
% [-7630.24699999765,-7620.17200000212,-7610.00099999830,-7599.69800000265,-7589.66799999774,-7579.41000000015,-7569.35099999979,-7559.09400000051,-7548.85500000045;]
% second order differencing yields:
% [10.0749999955297,10.1710000038147,10.3029999956489,10.0300000049174,10.2579999975860,10.0590000003576,10.2569999992847,10.2390000000596;]
% third order differencing yields:
% [0.0960000082850456,0.131999991834164,-0.272999990731478,0.227999992668629,-0.198999997228384,0.197999998927116,-0.0179999992251396;]
% fourth order differencing yields:
% [0.0359999835491180,-0.404999982565641,0.500999983400106,-0.426999989897013,0.396999996155500,-0.215999998152256;]
% It can be see that the 4-th order differencing gives even larger results
% than the 3rd order, so I assume that 3rd order is the best choise


 totalepoch=length(data);
 
data_sequence=[]; % the phase data
for epoch=1:1:totalepoch,
    data_sequence=[data_sequence data(epoch)]; % update the phase series
    % check if the queue is full,
    seq_full=(length(data_sequence)> length_sequence );

    if seq_full, % queue isover-full (means that the phase data of current epoch is already in queue)

          std_selected=9e12;
        order_selected=9e12;
        for order_diff=1:1:length(data_sequence)-2,
            phase_differenced=Method_Core_CalculateDifference(order_diff, data_sequence);
            stdval=norm(phase_differenced)/length(phase_differenced);
            % make sure that the order yields the smallest residual
            if stdval<std_selected,
                std_selected=stdval;
                order_selected=order_diff;
            end
        end
break;
    end

end

if order_selected>8e12, % seems that no results??
    error('The order of differencing cannot be determined automatically')
end