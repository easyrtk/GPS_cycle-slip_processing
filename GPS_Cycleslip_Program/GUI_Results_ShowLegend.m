% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% display the legend in a seperate figure
% NOT INSIDE the origional figure
function GUI_Results_ShowLegend(figtype,threshold)


plot(1,99999,'co', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize',12);  hold on %% just for the display of legend
plot(1,99999,'r+'); hold on %% just for the display of legend
plot(1,99999,'k.'); hold on %% just for the display of legend
plot(1,99999,'rp', 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',12); hold on %% just for the display of legend


if nargin ==2, % also show threshold
    plot(1:10,ones(10,1)*222,'g','LineWidth',2); hold on
    legend('Data interruption','Incomplete data for detection','Cycle-slip free','Cycle-slip detected','Threshold');
else
    legend('Data interruption','Incomplete data for detection','Cycle-slip free','Cycle-slip detected');
end

axis off
xlim([0 1])
ylim([0 1])