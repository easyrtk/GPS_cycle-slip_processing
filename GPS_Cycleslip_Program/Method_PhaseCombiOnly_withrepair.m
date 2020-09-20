% ======================================
% Cycle-slip detection
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% cycle-slip using geometry-free combination with the determination of the
% cycle-slip size

function Method_PhaseCombiOnly_withrepair()

% cycle-slip detection by signal combination
% between-epoch ionospheric delay ignored
% making it suitable only for high sampling frequency
% if the sampling interval is lager than 30s, this method is then not
% recommended

load RawDataTemp
load settings
Constants
% Read input parameters from GUI
totalepoch=ToolboxSetting.totalepoch;
std_phase1=ToolboxSetting.std_phase;
std_phase2=std_phase1;
vSatInView=ToolboxSetting.svids;
satnum=length(vSatInView);
totalsatview=length(vSatInView);
interval=ToolboxSetting.interval;

% Initialize the matrices to record the results
diff_record=zeros(totalsatview,totalepoch);
status_record=zeros(totalsatview,totalepoch);
cycle_repair=[];
total_repaired=0;

% detection threshold, which is dependent on the signal standard deviation
% where 4 means the confidence level, can also be 3
detection_threshold=4*sqrt(lambda1^2*std_phase1^2+lambda2^2*std_phase2^2);


for ps=1:1:satnum, % only process the satellites in view of the entire observation session
    satid= vSatInView (ps); % get the sat id
    if totalepoch>2000,
        dispstr=sprintf('Cycle-slip detection by phase combination for SV: %d',vSatInView(ps));
        wb = waitbar(0,dispstr);
    end
    
    vL1=mL1(satid,:);
    vL2=mL2(satid,:);
    vC1=mC1(satid,:);
    vP1=mP1(satid,:);
    vP2=mP2(satid,:);
    
    status_record(ps,1)=const_incomplete; % Detection starts from the second epoch
    
    for epoch=2:1:totalepoch,
        % relevant function for cycle-slip detection
        % it returns (1) residuals of phase combination and (2) the status
        [residuals,status]=Method_Core_DiffGeometryFreeCombination(lambda1,lambda2,vL1(epoch),vL2(epoch),vL1(epoch-1),vL2(epoch-1),vTime(epoch),vTime(epoch-1),sampling_interval,ToolboxSetting.std_phase,detection_threshold);
        
        if (status==const_detected)
            % Cycle-slip detected, since we have two signals, we might be
            % abel to repair it
            % If P code on L1 is available, it might be the first chioce
            % Of course if the Doppler is also there, it is much better,
            % but it is not supported by many receivers, we therefore use
            % code. There exsists already C2 code, but I do not consider it so far.
            repair_made=0;
            if (vP1(epoch)*vP1(epoch-1)~=0) && (vP2(epoch)*vP2(epoch-1)~=0),
                [residuals,status,valueL1,valueL2]=Method_Core_DiffGeometryFreeCombination_withrepair...
                    (lambda1,lambda2,vL1(epoch),vL2(epoch),vL1(epoch-1),vL2(epoch-1),vP1(epoch),vP2(epoch),vP1(epoch-1),vP2(epoch-1),vTime(epoch),vTime(epoch-1),sampling_interval,ToolboxSetting.std_phase,ToolboxSetting.std_code);
                repair_made=1;
                % if P1 not available, we use C1
            elseif (vC1(epoch)*vC1(epoch-1)~=0) && (vP2(epoch)*vP2(epoch-1)~=0),
                [residuals,status,valueL1,valueL2]=Method_Core_DiffGeometryFreeCombination_withrepair...
                    (lambda1,lambda2,vL1(epoch),vL2(epoch),vL1(epoch-1),vL2(epoch-1),vP1(epoch),vP2(epoch),vP1(epoch-1),vP2(epoch-1),vTime(epoch),vTime(epoch-1),sampling_interval,ToolboxSetting.std_phase,ToolboxSetting.std_code);
                repair_made=1;
                
            else
                % It seems that we do not have enough code data to repair
                % cycle-slips.
                %
            end
            
            if repair_made && (status==const_detected)% cycle-slip repair is executed and it still judges an occurance of cycle-slips.
                % record the "estimated" or "determined" cycle-slips
                total_repaired=total_repaired+1;
                cycle_repair(total_repaired).svid=vSatInView(ps);
                cycle_repair(total_repaired).epoch=epoch;
                cycle_repair(total_repaired).L1cycle=valueL1;
                cycle_repair(total_repaired).L2cycle=valueL2;
            end
        end
        status_record(ps,epoch)=status;
        diff_record(ps,epoch)=residuals;
        if totalepoch>2000, waitbar(epoch/totalepoch); end
    end
    if totalepoch>2000, close(wb); end
end
save('Results_DualFreqCombiOnly','status_record','diff_record','detection_threshold','cycle_repair','-v6')