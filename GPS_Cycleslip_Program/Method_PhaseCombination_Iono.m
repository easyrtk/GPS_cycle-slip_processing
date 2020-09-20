% ======================================
% Cycle-slip detection
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% Cycle-slip detection using geometry-free combination with the check on
% the estimated ionosphere delay
function Method_PhaseCombination_Iono()

Constants;


load RawDataTemp
load settings

% Read input parameters from GUI
totalepoch=ToolboxSetting.totalepoch;
std_phase1=ToolboxSetting.std_phase;
std_phase2=std_phase1;
vSatInView=ToolboxSetting.svids;
totalsatview=length(vSatInView);
interval=ToolboxSetting.interval;
length_sequence=ToolboxSetting.ionopolyfit_epochs;
order_poly=ToolboxSetting.ionopolyfit_order;

% Initialize the matrices to record the results
diff_record=zeros(totalsatview,totalepoch);
status_record=zeros(totalsatview,totalepoch);
iono_values=zeros(totalsatview,totalepoch);
cycle_repair=[];
total_repaired=0;

% detection threshold, which is dependent on the signal standard deviation
% where 4 means the confidence level, can also be 3
detection_threshold=4*sqrt(lambda1^2*std_phase1^2+lambda2^2*std_phase2^2);

% automatic determination of order of differencing
if order_poly==9999,
    % Firstly, choose a satellite whose carrier phase data are complete at
    % the first several epochs
    for ps=1:1:totalsatview,
        satid= vSatInView (ps); % get the sat id
        useit=1;
        for j=1:1:length_sequence*2,
            if (mL1(satid,j)==0) || (mL2(satid,j)==0),   useit=0; end
        end
        if useit, break; end
    end
    iono_queue=[];
    % Determine the order of differencing
    for epoch=2:1:length_sequence*2,
        phase1_cur=mL1(satid,epoch);
        phase2_cur=mL2(satid,epoch);
        phase1_last=mL1(satid,epoch-1);
        phase2_last=mL2(satid,epoch-1);
        time_cur=vTime(epoch);
        time_last=vTime(epoch-1);
        % call the core function
        [iono_variation,iono_value,status]=Method_Core_calculate_iono_residuals(lambda1,lambda2,phase1_cur,phase2_cur,phase1_last,phase2_last,time_cur,time_last,interval);
        % we collect the ionospheric variation first
        iono_queue=[iono_queue iono_variation];
    end
    % determine the order of differencing
    order_poly=Method_Core_DetermineOrder(iono_queue,length_sequence)
end

% Cycle-slip detection
for ps=1:1:totalsatview, % only process the satellites in view of the entire observation session
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
    
    sequence=[];
    status_record(ps,1)=const_incomplete;
    
    for epoch=2:1:totalepoch,
        phase1_cur=mL1(satid,epoch);
        phase2_cur=mL2(satid,epoch);
        phase1_last=mL1(satid,epoch-1);
        phase2_last=mL2(satid,epoch-1);
        time_cur=vTime(epoch);
        time_last=vTime(epoch-1);
        % calculate the between-epoch variation of ionospheric delay
        [iono_variation,iono_value,status]=Method_Core_calculate_iono_residuals(lambda1,lambda2,phase1_cur,phase2_cur,phase1_last,phase2_last,time_cur,time_last,interval);
        iono_values(ps,epoch)=iono_value;
        
        % The sequence is composed of continuous data.
        % An interrupt will lead to a reset of the sequence
        if (status==const_interrupt) || (status==const_incomplete),
            sequence=[];
            status_record(ps,epoch)=status;
            continue
        end
        % indicator of the completeness of the data sequence
        seq_full=(length(sequence)==(length_sequence));
        % construct the sequence
        if seq_full,
            % Data sequence is complete, and cycle-slip detection starts
            % Step 1: check the inconsistance of the current iono.
            % variation with respect to the history
            % Step 2: if detected, run "Repair" to quantify the sizes of
            % cycle-slips
            % Step 3: if repair procedure agrees with the detection
            % results, we record the estimatedcycle-slip; otherwise we say
            % there is no cycle-slip
            data_to_fit=iono_variation; % iono variation of current epoch is to be tested
            [diff,status]=Method_Core_IonoHighOrderDiff(sequence,data_to_fit,interval,order_poly,detection_threshold);
            diff_record(ps,epoch)=diff;
            
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
                    sequence=[];
                    total_repaired=total_repaired+1;
                    cycle_repair(total_repaired).svid=ps;
                    cycle_repair(total_repaired).epoch=epoch;
                    cycle_repair(total_repaired).L1cycle=valueL1;
                    cycle_repair(total_repaired).L2cycle=valueL2;
                else
                    % no cycle-slip, update the sequence
                    sequence=[sequence(1:length_sequence-1) data_to_fit];
                end
            end
            status_record(ps,epoch)=status;
        else
            % sequence is still not complete, it should growth......
            sequence=[sequence iono_variation];
        end
        if totalepoch>2000, waitbar(epoch/totalepoch); end
    end
    if totalepoch>2000, close(wb); end
end

save('Results_DualFreqIono','status_record','diff_record','iono_values','cycle_repair')