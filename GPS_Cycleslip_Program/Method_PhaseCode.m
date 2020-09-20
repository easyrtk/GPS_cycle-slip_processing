% ======================================
% Cycle-slip detection
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% cycle-slip by constructing phase code combination

function Method_PhaseCode(freq)
% check the cycle-slip by phase/code combination.
% the difference of code data between epochs cannot be "significantly"
% incompatibile with phase difference.

Constants;
load RawDataTemp
load settings

% Read parameters from GUI
totalepoch=ToolboxSetting.totalepoch;
std_code=ToolboxSetting.std_code;
interval=ToolboxSetting.interval;
vSatInView=ToolboxSetting.svids;
totalsatview=length(vSatInView);


% init detection results
diff_record=zeros(totalsatview,totalepoch);
status_record=zeros(totalsatview,totalepoch);

% ----------------------------------------------------------
% threshold is determined by the code noise
% this can be tuned
threshold=4*sqrt(2)*std_code;
% ----------------------------------------------------------

for ps=1:1:totalsatview, % only process the satellites in view of the entire observation session
    satid= vSatInView (ps); % get the sat id
    if totalepoch>2000,
        dispstr=sprintf('Cycle-slip detection by phase/code combination for SV: %d',vSatInView(ps));
        wb = waitbar(0,dispstr);
    end
    if freq==1,
        phasedata=mL1(satid,:);
        codedata=mC1(satid,:);
        wavelength=lambda1;
    elseif freq==2,
        phasedata=mL2(satid,:);
        codedata=mP2(satid,:);
        wavelength=lambda2;
    end
    for epoch=2:1:totalepoch,
        % check the cycle-slips
        [status,diff]=Method_Core_CalculateCodePhaseDiff(phasedata(epoch),phasedata(epoch-1),codedata(epoch),codedata(epoch-1),...
            vTime(epoch),vTime(epoch-1),interval,wavelength,std_code,threshold);
        % record the results
        status_record(ps,epoch)=status; % record the status
        diff_record(ps,epoch)=diff; % record the code/phase difference
        if totalepoch>2000, waitbar(epoch/totalepoch); end
    end

    if totalepoch>2000, close(wb); end
end
mdc=(threshold/ wavelength); % minimal detectable cycles
% save the results
if freq==1,
    save('Results_PhaseCodeCombiL1','status_record','threshold','diff_record','mdc');
elseif freq==2,
    save('Results_PhaseCodeCombiL2','status_record','threshold','diff_record','mdc');
end
