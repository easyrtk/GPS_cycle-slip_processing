% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% display raw data according to the method selected

function GUI_Results_DisplayPhaseRawData(prn,vTimeStr,selected_method_str)

load RawDataTemp

 Constants;
ax=[]; 
 
method_polynomialGPSL1=1;
method_polynomialGPSL2=2;
method_DopplerGPSL1=3;
method_DopplerGPSL2=4;
method_phasecodeGPSL1=5;
method_phasecodeGPSL2=6;
method_dualphase_only=7;
method_dualphase_iono=8;
% identify the method 
phaseL1=(strcmp(selected_method_str,all_method_str{method_polynomialGPSL1}));
phaseL2=(strcmp(selected_method_str,all_method_str{method_polynomialGPSL2}));
phaseL1L2=(strcmp(selected_method_str,all_method_str{method_dualphase_only}));
phaseL1L2_iono=(strcmp(selected_method_str,all_method_str{method_dualphase_iono}));
dopplerL1=(strcmp(selected_method_str,all_method_str{method_DopplerGPSL1}));
dopplerL2=(strcmp(selected_method_str,all_method_str{method_DopplerGPSL2}));
phasecodeL1=(strcmp(selected_method_str,all_method_str{method_phasecodeGPSL1}));
phasecodeL2=(strcmp(selected_method_str,all_method_str{method_phasecodeGPSL2}));
  
epochs=1:1:length(vTimeStr);

% Depending on the method, different raw data might be shown
if  phaseL1,
    % method: phase high-order differencing L1
    % show only L1 phase measurements
    plot(epochs,mL1(prn,epochs),'b-');
    ylabel('Carrier phase measurements [cycles]')
    titlestr=sprintf('Carrier phase raw data of L1 on GPS PRN %d',prn);
    xlim([1 length(epochs)])
elseif phaseL2,
    % method: phase high-order differencing L2
    % show only L2 phase measurements
    plot(epochs,mL2(prn,epochs),'b-');
    ylabel('Carrier phase measurements [cycles]')
    titlestr=sprintf('Carrier phase raw data of L2 on GPS PRN %d',prn);    
     xlim([1 length(epochs)])
elseif  phaseL1L2 || phaseL1L2_iono,
    % method : dual-freq. phase combination
    % show carrier phase measurements on both signals
    [ax,h1,h2]=plotyy(epochs,mL1(prn,epochs),epochs,mL2(prn,epochs)); hold on
    legend('Phase on L1','Phase on L2')
    set(ax(1),'XLim',[1 length(vTimeStr)])
    set(ax(2),'XLim',[1 length(vTimeStr)])
    set(get(ax(1),'Ylabel'),'String','Carrier phase of L1 [cycles]')
    set(get(ax(2),'Ylabel'),'String','Carrier phase of L2 [cycles]')
    titlestr=sprintf('Carrier phase raw data of L1 and L2 on GPS PRN %d',prn);
    xlim([1 length(epochs)])
elseif  dopplerL1 ,    
    % method: Doppler on L1
    % show between-epoch phase variation and Doppler
    delta_t=vTime(2)-vTime(1);
    phase_diff_temp=mL1(prn,1:length(vTimeStr)-1)-mL1(prn,2:length(vTimeStr));
    phase_diff_temp=[phase_diff_temp(1) phase_diff_temp];
    [ax,h1,h2]=plotyy(epochs,abs(mD1(prn,epochs)),...
                                epochs,  abs(phase_diff_temp/delta_t) ); hold on
    legend('Doppler on L1','Phase on L1')
    set(ax(1),'XLim',[1 length(vTimeStr)])
    set(ax(2),'XLim',[1 length(vTimeStr)])
    set(get(ax(1),'Ylabel'),'String','absolute value of Doppler on L1 [Hz]')
    set(get(ax(2),'Ylabel'),'String','absolute value of phase variation of L1 x delta_t [Hz]')
    titlestr=sprintf('Doppler and carrier phase raw data of L1 on GPS PRN %d',prn);
    xlim([1 length(epochs)])
    clear phase_diff_temp
elseif  dopplerL2 ,
        % method: Doppler on L2
    % show between-epoch phase variation and Doppler
    delta_t=vTime(2)-vTime(1);
    phase_diff_temp=mL2(prn,1:length(vTimeStr)-1)-mL2(prn,2:length(vTimeStr));
    phase_diff_temp=[phase_diff_temp(1) phase_diff_temp];
    [ax,h1,h2]=plotyy(epochs,abs(mD2(prn,epochs)),epochs,abs(phase_diff_temp)); hold on
    legend('Doppler on L2','Phase on L2')
    set(ax(1),'XLim',[1 length(vTimeStr)])
    set(ax(2),'XLim',[1 length(vTimeStr)])
    set(get(ax(1),'Ylabel'),'String','absolute value of Doppler on L2 [Hz]')
    set(get(ax(2),'Ylabel'),'String','absolute value of phase variation of L2 x delta_t [Hz]')
    titlestr=sprintf('Doppler and carrier phase raw data of L2 on GPS PRN %d',prn);
    xlim([1 length(epochs)])
    clear phase_diff_temp
elseif  phasecodeL1 ,
    % phase code combination on L1
    % show code and phase (in units of length)
    [ax,h1,h2]=plotyy(epochs,mC1(prn,epochs),epochs,mL1(prn,epochs)*lambda1); hold on
    legend('Code on L1','Phase on L1')
    set(ax(1),'XLim',[1 length(vTimeStr)])
    set(ax(2),'XLim',[1 length(vTimeStr)])
    set(get(ax(1),'Ylabel'),'String','Code on L1 [m]')
    set(get(ax(2),'Ylabel'),'String','Carrier phase of L1 * wavelength [m]')
    titlestr=sprintf('Code and carrier phase raw data of L1 on GPS PRN %d',prn);
    xlim([1 length(epochs)])
elseif  phasecodeL2 ,
        % phase code combination on L2
    % show code and phase (in units of length)
    [ax,h1,h2]=plotyy(epochs,mP2(prn,epochs),epochs,mL2(prn,epochs)*lambda2); hold on
    legend('Code on L2','Phase on L2')
    set(ax(1),'XLim',[1 length(vTimeStr)])
    set(ax(2),'XLim',[1 length(vTimeStr)])
    set(get(ax(1),'Ylabel'),'String','Code on L2 [m]')
    set(get(ax(2),'Ylabel'),'String','Carrier phase of L2 * wavelength [m]')
    titlestr=sprintf('Code and carrier phase raw data of L2 on GPS PRN %d',prn);    
    xlim([1 length(epochs)])
end

%  Set X and Y axis
aa=get(gca,'XTick')    ;

clear strs
for i=1:1:length(aa),
    if aa(i)==0, aa(i)=1; end
    epoch_str=vTimeStr{aa(i)};
    
    datumstr=epoch_str(1:10);
    timestr=epoch_str(11:20);
    
    strs{i}=timestr;
end
if ~isempty(ax)
set(ax(1),'XTickLabel',strs );
set(ax(2),'XTickLabel',strs )
else
    set(gca,'XTickLabel',strs )
end
xlabel('Time')
signal_id=1;
title(titlestr)

