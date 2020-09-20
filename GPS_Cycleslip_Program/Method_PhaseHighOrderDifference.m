% ======================================
% Cycle-slip detection
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% Check the cycle-slips by differencing phase measurements with a higher
% order. The order can be determined automatically or identified by the
% user himself.


function Method_PhaseHighOrderDifference(freq)
 % input : 
  % freq: 1 or 2 for L1 L2

Constants;
 

load RawDataTemp
load settings 

% Read from GUI
detection_threshold=3;
length_sequence=ToolboxSetting.polyfit_epochs;
order_diff=ToolboxSetting.polyfit_order;
totalepoch=ToolboxSetting.totalepoch;
std_phase1=ToolboxSetting.std_phase;
std_phase2=ToolboxSetting.std_phase;
vSatInView=ToolboxSetting.svids; 
satnum=length(vSatInView);

% For recording the results
status_record=zeros(satnum,totalepoch);
diff_phase_record=zeros(satnum,totalepoch);
stdold_record=zeros(satnum,totalepoch);
stdnew_record=zeros(satnum,totalepoch);

if order_diff==9999, % automatic determination of the order
    if freq==1, 
        phasedata=mL1( vSatInView (1),:);
         order_diff=Method_Core_DetermineOrder(phasedata,length_sequence);
    elseif freq==2,
        phasedata=mL2( vSatInView (1),:);
        order_diff=Method_Core_DetermineOrder(phasedata,length_sequence);
    end
 
end

if order_diff>length_sequence-1,
    msgbox('The order of difference should be at most the length of data queue minus one. Processing terminated.')
    error('The order of difference should be at most the length of data queue minus one. Processing terminated.')
end
for ps=1:1:satnum,% satellite    
    if totalepoch>2000,
        dispstr=sprintf('Cycle-slip detection by high-order phase difference for SV: %d',vSatInView(ps));
        wb = waitbar(0,dispstr);
    end
    satid= vSatInView (ps);
    if freq==1, 
        phasedata=mL1(satid,:);
    elseif freq==2,
        phasedata=mL2(satid,:);
    end
    data_sequence=[]; % the phase data 
    time_sequence=[]; % the time series of phase data
    for epoch=1:1:totalepoch,
        data_sequence=[data_sequence phasedata(epoch)]; % update the phase series
        time_sequence=[time_sequence vTime(epoch)];% update thetime series
        % check if the queue is full,
        seq_full=(length(data_sequence)> length_sequence );
 
        if seq_full, % queue is over-full (means that the phase data of current epoch is already in queue)
            % now we can check the cycle-slips
            % take the first data out, making the queue always at the
            % specified length
            data_sequence(1)=[];
            time_sequence(1)=[];
            % Now, call cycle-slip detection
 
            [status,phase_differenced,std1,std2]=Method_Core_PhaseHighOrderDiff(data_sequence,time_sequence,ToolboxSetting.interval,order_diff,detection_threshold);     
             % record the difference phase data for further display
            diff_phase_record(ps,epoch-length_sequence+order_diff+1:epoch)=phase_differenced;
            stdold_record(ps,epoch)=std1; % record the standard deviation of high-order differenced phase data without the current phase data
            stdnew_record(ps,epoch)=std2;% record the standard deviation of high-order differenced phase data WITH the current phase data
        else
            % data series is now full
            status=const_incomplete; % to identify the status
        end
        % record the status
        status_record(ps,epoch)=status;
        % if detected, clear the data queue
        if  status==const_detected || status==const_interrupt;
            data_sequence=[];
            time_sequence=[];
        end
            if totalepoch>2000, waitbar(epoch/totalepoch); end
    end
if totalepoch>2000, close(wb); end
    
end

if freq==1,
    save('Results_PhaseHighOrdeDiff_L1','status_record','diff_phase_record','stdold_record','stdnew_record','detection_threshold','length_sequence','order_diff','-v6')
elseif freq==2,
    save('Results_PhaseHighOrdeDiff_L2','status_record','diff_phase_record','stdold_record','stdnew_record','detection_threshold','length_sequence','order_diff','-v6')
end
