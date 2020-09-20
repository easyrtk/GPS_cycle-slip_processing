 % ======================================
% Cycle-slip detection  
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% cycle-slip detection using Doppler

function Method_Doppler(freq) % freq=1 or 2 to identify L1 or L2

% cycle-slip detection by comparing the doppler data with the carrier phase
% variation
% For a sampling interval less than 1 or 2 seconds, it might be OK
% for a larger interval, the Doppler data do not really reflect the "carrier phase rate"
% Therefore some modifications must be implemented, however, it is not
% considerd here

 

Constants;
load RawDataTemp
load settings

% read GUI information
totalepoch=ToolboxSetting.totalepoch;
interval=ToolboxSetting.interval;
vSatInView=ToolboxSetting.svids;
totalsatview=length(vSatInView);
 
% initialization of the result matrix
diff_record=zeros(totalsatview,totalepoch);
status_record=zeros(totalsatview,totalepoch);

% threshold
% as long as the observation interval (interval between two adjecent
% epochs) is getting larger, the Doppler are more difficult to reflect the
% real-time carrier phase rate.
threshold=ToolboxSetting.doppler_deviation;
threshold_rec=zeros(totalsatview,1);
% check whether the user identified the deviation by himself
if threshold==9999,    
    %================================
    % automatic determination of threshould
    % between
    % (a) the between-epoch variation of measured carrier phase
    % (b) the between-epoch carrier phase variation estimated by Doppler
    %
    % simply by getting the mean value
    %====================================
    
    for ps=1:1:totalsatview, % only process the satellites in view of the entire observation session
        satid= vSatInView (ps); 
        if freq==1,
            phasedata=mL1(satid,:);
            dopplerdata=mD1(satid,:);
            wavelength=lambda1;
        elseif freq==2,
            phasedata=mL2(satid,:);
            dopplerdata=mD2(satid,:);
            wavelength=lambda2;
        end
        nn=0;
        diffs=zeros(totalepoch,1);
        for epoch=2:1:totalepoch,
            % call the function. It returns
            % (1) the  difference between the Doppler data and the derived phase rate
            % (2) the status
            [status,diff]=Method_Core_CalculateDopplerPhaseDiff(phasedata(epoch),phasedata(epoch-1),dopplerdata(epoch),dopplerdata(epoch-1),vTime(epoch),vTime(epoch-1),sampling_interval,threshold);
            if diff~=0,
                nn=nn+1;
                diffs(nn)=abs(diff);
            end
            % mean value of the deviation between "meased "phase variation and
            % "estimated" phase variation
            mv=std(diffs(1:nn));
            threshold_rec(ps)=4*mv; % 4 x std=99.9% probability
            if threshold_rec(ps)<1,
                threshold_rec(ps)=1;
            end
        end
    end
end


%================== Cycleslip detection ============================
for ps=1:1:totalsatview, % only process the satellites in view of the entire observation session
    satid= vSatInView (ps); % get the sat id
    if totalepoch>2000,
        dispstr=sprintf('Cycle-slip detection using Doppler for SV: %d',vSatInView(ps));
        wb = waitbar(0,dispstr);
    end
    
    if freq==1,
        phasedata=mL1(satid,:);
        dopplerdata=mD1(satid,:);
        wavelength=lambda1;
    elseif freq==2,
        phasedata=mL2(satid,:);
        dopplerdata=mD2(satid,:);
        wavelength=lambda2;
    end
    % check whether the automatic detemined threshold is to be used
    if threshold_rec(ps)~=0,
        threshold=threshold_rec(ps);
    end
    % go through the epochs
    for epoch=2:1:totalepoch,
        % call the function. It returns
        % (1) the  difference between the Doppler data and the derived phase rate
        % (2) the status
        [status,diff]=Method_Core_CalculateDopplerPhaseDiff(phasedata(epoch),phasedata(epoch-1),dopplerdata(epoch),dopplerdata(epoch-1),vTime(epoch),vTime(epoch-1),sampling_interval,threshold);
        status_record(ps,epoch)=status;
        diff_record(ps,epoch)=diff;
        if totalepoch>2000, waitbar(epoch/totalepoch); end
    end
    if totalepoch>2000, close(wb); end
end
if freq==1,
    save('Results_DopplerL1','status_record','threshold','diff_record');
elseif freq==2,
    save('Results_DopplerL2','status_record','threshold','diff_record');
end