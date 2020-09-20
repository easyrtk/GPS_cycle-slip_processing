% ======================================
% Cycle-slip detection
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% display the between-epoch variation of ionospheric delay
function GUI_Results_DispIonoVariation( ps,status_record,diff_record,vTimeStr )

%inputs:
% ps                            --> sat id
% status_record         -->status generated by the associated method (cycle-slip free, cycle-slip detected, incomplete, interrupted)
% diff_record              -->  estimated between-epoch ionospheric increment
% vTimeStr                  --> string regarding the UTC datum and time

Constants;
load settings
totalepoch=size(status_record,2);
satid= ToolboxSetting.svids (ps); % get the sat id

% show the result of each epoch using different symbols
for j=1:1:totalepoch,
    % check the status of each epoch in order to determine the symbols to
    % be shown
    switch status_record(ps,j)
        case const_detected
            plot(j,diff_record(ps,j),'rp', 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',12); hold on
        case const_interrupt
            val=find_next_nonzero(diff_record(ps,:),j);
            plot(j,val,'co', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize',12); hold on
        case const_incomplete
            val=find_next_nonzero(diff_record(ps,:),j);
            plot(j,val,'r+'); hold on
        case const_cycleclipfree
            plot(j,diff_record(ps,j),'b.');
    end
end
xlabel('epochs');
ylabel('Estimated between-epoch ionospheric delay [meters]')

xlim([1 totalepoch])
% xlabel with time display
aa=get(gca,'XTick')    ;
clear strs
for i=1:1:length(aa),
    if aa(i)==0, aa(i)=1; end
    epoch_str=vTimeStr{aa(i)};
    datumstr=epoch_str(1:10);
    timestr=epoch_str(11:20);
    strs{i}=timestr;
end
set(gca,'XTickLabel',strs )


if satid  <50,     title_str=sprintf('Between-epoch ionosphere delay estimated by phase combination for GPS Sat PRN %d',satid);
else                                    title_str=sprintf('Ionosphere residuals GLONASS Sat PRN %d',satid-50); end
title(title_str)
 
 
%============================================
% sub-function
% search for the next non-zero value
function val=find_next_nonzero(data,epoch)

totalepoch=length(data);

if epoch>=length(data), % backwards find non-zero value
    for i=epoch:-1:1,
        if data(i)~=0,
            val=data(i);
            return
        end
    end
else    
    for i=epoch+1:1:length(data) %forwards find non-zero value
        if data(i)~=0,
            val=data(i);
            return
        end
    end
end