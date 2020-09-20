% ======================================
% Cycle-slip detection in measurement domain
%
% zhen.dai@dlr.de
%
% last modified: 2011.Oct
% ======================================

% the user could added some integer cycle-slips into phase raw data
% this allows the user (also I personally) to test the algorithms

function GUIMain_AddCycleSlipIntoRawData(ToolboxSetting,datafilename)
 
load (datafilename)
totalepoch=ToolboxSetting.totalepoch;   
total_cycleslips=ToolboxSetting.num_added_cycleslips; 

for cycleid=1:1:total_cycleslips,
    startepoch=ToolboxSetting.added_cycles(cycleid).start_epoch;
    cyclevalue=ToolboxSetting.added_cycles(cycleid).value;
    svid=ToolboxSetting.added_cycles(cycleid).svid;
    isL1=strcmp(ToolboxSetting.added_cycles(cycleid).frequency,'L1');
    isL2=strcmp(ToolboxSetting.added_cycles(cycleid).frequency,'L2');
    
    
    if startepoch>totalepoch,
        msgbox('the starting epoch is invalid');
        return
    end
    
    if cyclevalue~=floor(cyclevalue),
        msgbox('number of added cycles must be integer')
        return
    end
    
    if (isL1+isL2~=1),
        error('L1 or L2  ???????')
    end
    
    if isL1
        oridata=mL1(svid,startepoch);
        newvalue=mL1(svid,startepoch)+cyclevalue;
        % cycle-slips occur on a specific epoch and remain in the following
        % epochs
        for i=startepoch:1:totalepoch,
            mL1(svid,i)=mL1(svid,i)+cyclevalue;
        end
        
    elseif isL2
        oridata=mL2(svid,startepoch);
        newvalue=mL2(svid,startepoch)+cyclevalue;
                % cycle-slips occur on a specific epoch and remain in the following
        % epochs
        for i=startepoch:1:totalepoch,
            mL2(svid,i)=mL2(svid,i)+cyclevalue;
        end
    end
    if oridata==0,
        msgbox('You added a cycle-slip to a raw data whose old value is ZERO. Please check again!')
        error('You added a cycle-slip to a raw data whose old value is ZERO. Please check again!')
    end
    fprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
    fprintf('On Sat PRN=%d, a slip of %d cycle(s) is added starting from %d epoch and remain at the following epochs\n',svid,cyclevalue,startepoch)
    fprintf('Origional phase value  =%15.8f\n',oridata);
    fprintf('New phase value          =%15.8f\n',newvalue);
end



save(datafilename,'vTime','ObsAvailable','sampling_interval','mP1','mL1','mD1','mD2','vTimeStr','mP2','mL2','mC1','method','totalepoch','vSatInView');


