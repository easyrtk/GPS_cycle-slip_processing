% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% calculate high-order difference for a queue of data
function diffs=Method_Core_CalculateDifference(num_order, sequence)
numdata=length(sequence);

if length(sequence)<num_order+1,     error('check the sequence!!!') ; end
seq_backup=sequence;
for i=1:1:num_order,
    clear seq_temp 
    for j=1:1:numdata-i,
        seq_temp(j)=sequence(j+1)-sequence(j);
    end
    clear sequence
    sequence=seq_temp;
end

diffs=sequence;