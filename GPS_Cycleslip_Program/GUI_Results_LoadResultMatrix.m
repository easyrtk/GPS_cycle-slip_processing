% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


% load the results processed in advance into memory
Constants;
clear mResultMatrix  mStatusMatrix DualFreqResidualUpperBound IonoValue IonoVariation
clear PhaseDopplerDiffThreshold PhaseCodeDiffThreshold
clear  mStdOld  mStdNew  ratio
selected_method_id=    get(handles.methods,'Value') ; % selected method
method_strings=get(handles.methods,'String') ; 
selected_method_str= method_strings{selected_method_id};

if (strcmp(selected_method_str,all_method_str{method_dualphase_only})) 
    % for dual-freq phase combination
    load Results_DualFreqCombiOnly  
    mResultMatrix=diff_record;
    mStatusMatrix=status_record;
    DualFreqResidualUpperBound=detection_threshold;
end

if (strcmp(selected_method_str,all_method_str{method_dualphase_iono}))
    load Results_DualFreqIono
    IonoVariation=diff_record;
    IonoValue=iono_values;
    mStatusMatrix=status_record;
    %     DualFreqResidualUpperBound=upper_bound;
end


if (strcmp(selected_method_str,all_method_str{method_phasecodeGPSL1})),
    load Results_PhaseCodeCombiL1
    mResultMatrix=diff_record;
    mStatusMatrix=status_record;
    PhaseCodeDiffThreshold=threshold;
end

if (strcmp(selected_method_str,all_method_str{method_phasecodeGPSL2})),
    load Results_PhaseCodeCombiL2
    mResultMatrix=diff_record;
    mStatusMatrix=status_record;
    PhaseCodeDiffThreshold=threshold;
    
end

if (strcmp(selected_method_str,all_method_str{method_DopplerGPSL1})),
    load Results_DopplerL1
    mResultMatrix=diff_record;
    mStatusMatrix=status_record;
    PhaseDopplerDiffThreshold=threshold;
end

if (strcmp(selected_method_str,all_method_str{method_DopplerGPSL2})),
    load Results_DopplerL2
    mResultMatrix=diff_record;
    mStatusMatrix=status_record;
    PhaseDopplerDiffThreshold=threshold;
end

if (strcmp(selected_method_str,all_method_str{method_polynomialGPSL1})),
    load Results_PhaseHighOrdeDiff_L1
    mResultMatrix=diff_phase_record;
    mStatusMatrix=status_record;
    mStdOld=stdold_record;
    mStdNew=stdnew_record;
    ratio=detection_threshold;
end

if (strcmp(selected_method_str,all_method_str{method_polynomialGPSL2})),
    load Results_PhaseHighOrdeDiff_L2
    mResultMatrix=diff_phase_record;
    mStatusMatrix=status_record;
    mStdOld=stdold_record;
    mStdNew=stdnew_record;
    ratio=detection_threshold;
    
end