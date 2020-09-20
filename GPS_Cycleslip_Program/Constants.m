% ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% constants used in the GUI

global const_interrupt  const_incomplete const_detected const_cycleclipfree  const_normal
global sol Fre2 Fre1 lambda1 lambda2 totalGPSsatellite
global list_method_str
global method_polynomialGPSL1 method_polynomialGPSL2  method_DopplerGPSL1  method_DopplerGPSL2  method_phasecodeGPSL1 
global method_phasecodeGPSL2  method_dualphase_only  method_dualphase_iono 

% measurement interrupted (like loss of tracking, missing data of an expected epoch)
const_interrupt=-1; 
% data incomplete. for example, for a polynomial fitting of 5 epochs, the
% first 4 epochs are not sufficient to apply the cycle-slip detection, and
% they are identified as "incomplete"
const_incomplete=-2; 
% cycle-slip detected at this epoch
const_detected=2;
% cycle-slip free at this epoch
const_cycleclipfree=1;

const_normal=0;

sol=299792458; %% Speed of light
Fre2=1227.60e6;%%frequency of L2
Fre1=1575.42e6; %%frequency of L1
lambda1=sol/(Fre1);%% lambda on L1
lambda2=sol/(Fre2);%% lambda on L2
totalGPSsatellite=32; %% Assuming that there are maximal 32 GPS satellites

method_polynomialGPSL1=1;
method_polynomialGPSL2=2;
method_DopplerGPSL1=3;
method_DopplerGPSL2=4;
method_phasecodeGPSL1=5;
method_phasecodeGPSL2=6;
method_dualphase_only=7;
method_dualphase_iono=8;

all_method_str={'Phase differencing on L1','Phase differencing  on L2','Doppler method on L1','Doppler method on L2',...
                             'Phase code combination on L1','Phase code combination on L2','Dual-Freq. phases with ionosphere ignored',...
                             'Dual-Freq. phases with ionosphere fitting'};
