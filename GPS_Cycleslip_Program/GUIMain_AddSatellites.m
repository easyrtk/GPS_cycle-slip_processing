% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


gnss_type='Gxx';
sv_prn=777;
global sat_selected_str

% The user could identify a specific satellite
% This might save processing time and let the user concentrate on a
% satellite

while(1)

    prompt = {'Enter GNSS types: GPS (Currently only GPS)','Enter PRN code (1~32)'};
    dlg_title = 'Add satellites for cycle-slip detection';
    num_lines = 1;
    def = {'GPS','0'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer),
        return
    end
    gnss_type=answer{1};
    sv_prn=str2num(answer{2});
    if (~strcmp(gnss_type,'GPS') || (sv_prn<1) || (sv_prn>32)),
        msgbox('Note that: currently only GPS satellites are processable and a PRN code ranges from 1 to 32')
    else
        break;
    end
end
svs=get(handles.SatSelected,'String');
if strcmp(svs,sat_selected_str)
    svs='';
end
sv_str=sprintf('G%2d/',sv_prn);
svs=strcat(svs,sv_str);
set(handles.SatSelected,'String',svs);
