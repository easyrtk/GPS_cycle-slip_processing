% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% announcement

anno_text{1}='This software package was developed by the author using time off work and only reflects his personal understanding.';
anno_text{2}='The author hopes that this software package can serve as a platform to help the GPS-beginners interested in cycle-slip processing. The programs cover only the most classic methods without any state-of-the-art improvement.';
anno_text{3}='A hint from the author: cycle-slip detection depends on the type and quality of measurements, as well as the application. A robust cycle-slip detection approach should be oriented to a specific application and could be a fusion of different methods.';
anno_text{4}='The author would like to hear any comments, suggestions, and critiques from users. However, the author accepts no responsibility for failures, damages, wrong results, and unexpected consequences due to the use of this free software.';
 
OK =  (questdlg(anno_text, 'Annocement', 'It is OK','It is NOT OK','It is NOT OK'));

switch OK
    case 'It is NOT OK'
        close all force
        clear all
        clc
        msgbox('Thank you for your time and bye bye')
        error('Program Stops')
end