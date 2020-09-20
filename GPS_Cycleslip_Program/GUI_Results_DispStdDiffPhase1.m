% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% display the standard deviation of differenced carrier phase data
% with/without the current carrier phase measuremen
function GUI_Results_DispStdDiffPhase1(ps,status_record,mStdOld,mStdNew,vTimeStr,length_sequence,order_diff )
%inputs:
% ps                            --> sat id
% status_record         -->status generated by the associated method (cycle-slip free, cycle-slip detected, incomplete, interrupted)
% mStdOld                 --> std of phase data without the one on current epoch
% mStdNew              -->  std of phase data with the one on current epoch
% vTimeStr                  --> string regarding the UTC datum and time
% length_sequence    ---> length of the queue containing the differenced
%                                       phase  data (only for figure title)
% order_diff              --->  order of difference (only for figure title)
                      

Constants;
totalepoch=size(status_record,2);

plot(1:totalepoch,mStdOld(ps,:),'b'); hold on
plot(1:totalepoch,mStdNew(ps,:),'r'); hold on
% show the result of each epoch using different symbols
for j=1:1:totalepoch,
    switch status_record(ps,j)
        case const_interrupt
            plot(j,0,'co', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize',12); hold on
        case const_incomplete
            plot(j,0,'r+'); hold on
    end
end
legend('Std without current data','Std with current data')
xlim([1 totalepoch-1])
aa=get(gca,'XTick')    ;
clear strs

% xlabel with time display
for i=1:1:length(aa),
    if aa(i)==0, aa(i)=1; end
    epoch_str=vTimeStr{aa(i)};
    datumstr=epoch_str(1:10);
    timestr=epoch_str(11:20);
    strs{i}=timestr;
end
set(gca,'XTickLabel',strs )
xlabel('Time')
ylabel('Standard deviation [cycle]')
titlestr=sprintf('A posteriori standard deviation of differenced carrier phase (order =%d and length of data series=%d)',order_diff,length_sequence);
title(titlestr)
