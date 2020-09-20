% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================


 
% show methods available
load settings
Constants

total_method=0;
 
if ToolboxSetting.method_polyfit_GPSL1
    total_method=total_method+1;      method_list_str{total_method}=all_method_str{method_polynomialGPSL1}; end
if ToolboxSetting.method_polyfit_GPSL2
    total_method=total_method+1;      method_list_str{total_method}=all_method_str{method_polynomialGPSL2}; end
if ToolboxSetting.method_doppler_GPSL1
    total_method=total_method+1;      method_list_str{total_method}=all_method_str{method_DopplerGPSL1}; end
if ToolboxSetting.method_doppler_GPSL2
    total_method=total_method+1;      method_list_str{total_method}=all_method_str{method_DopplerGPSL2}; end
if ToolboxSetting.method_codephase_GPSL1
    total_method=total_method+1;       method_list_str{total_method}=all_method_str{method_phasecodeGPSL1}; end
if ToolboxSetting.method_codephase_GPSL2
    total_method=total_method+1;      method_list_str{total_method}=all_method_str{method_phasecodeGPSL2}; end
if ToolboxSetting.method_phasecombi
    total_method=total_method+1;      method_list_str{total_method}=all_method_str{method_dualphase_only}; end
if  ToolboxSetting.method_phasecombi_iono
    total_method=total_method+1;      method_list_str{total_method}=all_method_str{method_dualphase_iono};    end

if total_method==0,
    error('There is no method availabel for your data')
end

set(handles.methods,'String',method_list_str)
 set(handles.methods,'Value',1)