% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% check the parameters identified by the user
% validity will be checked, however, raw data are needed to check whether
% they are in deed reasonably assigned
function [val,status]=GUIMain_Check_Input(objs,default_str,default_val)

% check if the parameters are manuelly identified

status=0; %% assume it is an input error, 1-- ok    0 -- err
val=-999; 

input_str = (get(objs,'String'));
if strcmp(input_str,default_str), % use default value
    val=default_val;
    status=1; 
else
    [val,status]=str2num(input_str); 
    if status~=0,
        if (val<0),   status=0;    end % value should be positive
    else
        status=0;
        val=-999; 
    end
    
end