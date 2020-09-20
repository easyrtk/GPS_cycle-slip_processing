% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% check the satellites selected by the user

svstr=get(handles.SatSelected,'String');
if strcmp(svstr,sat_selected_str),
    svstr_id=1:1:32;
else
    svstr_id=[]; 
        for j=1:4:length(svstr), 
            svstr_id=[svstr_id str2num(svstr(j+1:j+2))];
        end
        if isempty(svstr_id), % no sat selected
            uiwait(msgbox('Please choose at least one satellite'));
            return
        end
end

% At this time, the RINEX should be read in
% The satellites to be tested should be requested by the user and
% contained by the RINEX file
% So, we try to find the common satellites from both sides
load RawDataTemp
SatToCheck=[];
for svid=1:1:100,  % check the satellites
    inobs=find(vSatInView==svid);
    userselected=find(svstr_id==svid);
    if (~isempty(inobs)) && (~isempty(userselected)),
        SatToCheck=[SatToCheck svid];
    end
end