%========================================
%     Cycle-slip
%     Zhen Dai
%========================================
% Functions:
%      Read  the RINEX observation file and save the measurement
% Input parameters:
%      filename --> RINEX observation file name
%      sampling_interval --> Sampling interval in Seconds (0.1 s == 10 Hz ......)
%      totalepoch -> total epochs to be processed. -999 implies processing
%               all the data in this file
% Output:
%      mSatID -> Satellite visibility of each epoch
%      vTime-> Time of each epoch scaled to "second of week"
%      vTimeStr -> Time expressed in STRING
%      interval -> Sampling interval of the data
%      mCode -> C/A code on  L1 signal
%      mPhase -> Carrier phase data on L1 signal
%  Remarks:
%      1. Only read the data from the GPS satellites
%      2. Only consider the L1 C/A and L1 phase data
%      3. Outputs are saved in a data file
%      4. It may provide some unexpected result when processing some
%      specially formatted RINEX observation file.

function [datafilename,totalepoch_real]=GUIMain_LoadRinexOBS(filename,sampling_interval,totalepoch)
% function [datafilename,totalepoch_real]=GUIMain_LoadRinexOBS()
%% GUI Initialization
f1=figure;
close(f1);
figure;
title=sprintf('Reading RINEX observation file');
set(gcf,'MenuBar','none','NumberTitle','off','Name',title,...
    'Position',[400 500 450 150],'Visible','off');
movegui(gcf,'center');
hlistbox = uicontrol(gcf,'Style', 'listbox', 'String', 'Clear',...
    'Position', [0 0 450 150],'String','','Foregroundcolor','k','Backgroundcolor','w');
set(gcf,'Visible','on');

datafilename=sprintf('RawDataTemp');
 

%% Start reading the RINEX file
totalGNSSsatellite=32;
vSatID=zeros(totalGNSSsatellite,1);
interval=0;
%% Initialize the data matrix.
if totalepoch==-999, %% When the total number of epochs are unknown
    vTime=[];  mCode=[]; mPhase=[]; vTimeStr=[];mDoppler1=[];mDoppler2=[];
elseif   totalepoch>0,%% With the known number of epochs
    vTime=zeros(totalepoch,1);
    vTimeStr=cell(totalepoch,1);
    mP1=zeros(totalGNSSsatellite,totalepoch);
    mC1=zeros(totalGNSSsatellite,totalepoch);
    mL1=zeros(totalGNSSsatellite,totalepoch);
    mP2=zeros(totalGNSSsatellite,totalepoch);
    mL2=zeros(totalGNSSsatellite,totalepoch);
    mD1=zeros(totalGNSSsatellite,totalepoch);
    mD2=zeros(totalGNSSsatellite,totalepoch);
else
    errordlg('Invalid total number of epochs')
end

%% Open the file
fid = fopen(filename);
if fid==-1,
    errmsg=sprintf('Can not open this file%s',filename);
    errordlg(errmsg);
    return;
end

line80num=0;

obsC1pos=0; %% Indicates which observation is C/A code
obsL1pos=0; %% Indicates which observation is phase on L1
obsP1pos=0; %% Indicates which observation is P1 code
obsL2pos=0; %% Indicates which observation is phase on L2
obsP2pos=0; %% Indicates which observation is P2 code
obsD1pos=0; %% Indicates which observation is Doppler on L1
obsD2pos=0; %% Indicates which observation is Doppler on L1
fl=0;
while (1)
    line80num = line80num + 1;
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %              Read the header section
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    line80 = GetLine80(fid);
    if findstr(line80,'END OF HEADER'),
        break;
    end
    if findstr(line80,'APPROX POSITION'),
        AppX=str2num(line80(1:16));
        AppY=str2num(line80(17:30));
        AppZ=str2num(line80(31:45));
    end
    %% Antenna Height
    if findstr(line80,'ANTENNA: DELTA H/E/N'),
        vAntennaDelta(1) = str2num(line80(1:14));
        vAntennaDelta(2) = str2num(line80(15:28));
        vAntennaDelta(3) = str2num(line80(29:42));
    end
    %% Sampling rate
    if findstr(line80,'INTERVAL'),
        interval_default = str2num(line80(1:10));
        if sampling_interval==-999,             sampling_interval=interval_default;  end
        if (sampling_interval<interval_default) || mod(sampling_interval*100,interval_default*100)~=0
            show_str=sprintf('%s %d %s %d %s','The sampling interval of your RINEX data seems to be',interval_default,...
                ' [s], whereas you set it as ',sampling_interval, ' [s] in the GUI. Please check your data set again. Program has to stop here.');
            msgbox(show_str);
            error('Error! Please check the pop-up message')
            return;
        end
    end

    %% Check the order of the observation
    if findstr(line80,'TYPES OF OBSERV'),

        if fl==0 , fl=1; else fl=0;  end
        pos=0;
        if fl==1, totalobs=str2num(line80(4:8)); end
        obsread=0;
        posnum=1;
        for obsread=1:1:totalobs,
            if posnum>9,
                line80 = GetLine80(fid); %% might continue on the next line
                posnum=1;
            end            
            j=11+(posnum-1)*6;            
            posnum=posnum+1;
            if (line80(j:j+1)=='P1')  , obsP1pos=obsread;             end
            if (line80(j:j+1)=='L1'),   obsL1pos=obsread;             end
            if (line80(j:j+1)=='P2'),   obsP2pos=obsread;            end
            if (line80(j:j+1)=='L2'),    obsL2pos=obsread;             end
            if (line80(j:j+1)=='D2'),   obsD2pos=obsread;            end
            if (line80(j:j+1)=='D1'),   obsD1pos=obsread;            end
            if (line80(j:j+1)=='C1'),   obsC1pos=obsread;            end
        end
    end
end %% End of reading header

last_epoch=-999;

%  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%            Read the data epoch by epoch
%  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
epoch=0;
[ line80,eofs]=GetNextRINEXParagraph(fid);
while(1)
    vSatID=zeros(totalGNSSsatellite,1);
    vGPSSatID=zeros(20,1);
    % check whether the pointer of the file reaches the end
    if eofs==-1,
        break;
    end

    % Get the time
    year = str2double(line80(1:3));
    month = str2double(line80(4:6));
    day = str2double(line80(7:9));
    hour = str2double(line80(10:12));
    minute = str2double(line80(13:15));
    second = str2double(line80(16:26));
    %% Get GPS week and seconds of week
 
    secondsofday=hour*3600+minute*60+second;
    if epoch==0,    last_epoch=secondsofday-sampling_interval; end
    
    record_symbol=-999; % record the data or not (-999 not record, 1 record)
     if mod(round((secondsofday-last_epoch)*100),round(sampling_interval*100))==0, % pick up the epochs fulfilling the intervals
        epoch=epoch+1;
        record_symbol=1;
        last_epoch=secondsofday;
        if (totalepoch~=-999), %%  -999= no limit
            if epoch>totalepoch, break; end
        end
    end

    
    if   record_symbol==-999,
        [ line80,eofs]=GetNextRINEXParagraph(fid); 
        if eofs==1, break; end
        continue;
    end
    
 
        % Now format the receipt epoch expressed in STRING
        vTime(epoch)=secondsofday;
        if year<80 ,
            vTimeStr{epoch}=sprintf('%4d.%02d.%02d  %02d:%02d:%05.2f',2000+year,month,day,hour,minute,second);
        else
            vTimeStr{epoch}=sprintf('%4d.%02d %02d  %02d:%02d:%05.2f',1900+year,month,day,hour,minute,second);
        end
 
    %% Read the satellite id
    sat_num = str2double(line80(30:32));
    %% Start checking the satellite types and PRN
    pos=33;
    j=1; 
    gps_sat_num=0;
    while (j<=sat_num),
        switch line80(pos)
            case 'G' %% GPS , PRN 1~50
                satid=str2num(line80(pos+1:pos+2)); 
                vSatID(j)=satid;  %% GNSS PRN 
                gps_sat_num=gps_sat_num+1;
                vGPSSatID(gps_sat_num)=satid;
            case 'R' %% GLONASS 50~100
                satid=50+str2num(line80(pos+1:pos+2)); 
                vSatID(j)=satid;
            case 'S' %% SBAS,100~150;
                satid=100+str2num(line80(pos+1:pos+2)); 
                vSatID(j)=satid;
            case 'E' %% GALILEO, not to be considered
                ;
            otherwise %% satellite information might be in the next line
                pos=30; %% for next line, make a offset because it will be added with 3
                line80 = GetLine80(fid);
                j=j-1;
        end
        %% for next satellite
        pos=pos+3;
        j=j+1;
    end
    %% Now read the observation data
    %% Note that the loop is implemented for GPS satellites
    %% so we use sat_gnss as the final value of the loop
    %% Cannot use sat_num which represents the total number of all GNSS satellites
    %% But sat_num is still useful to filter out the observation data of
    %% the other GNSS satellite.
    line80 = GetLine80(fid);
 
    for j=1:1:sat_num, 
        pos=1;
        for k=1:1:totalobs,
            if vSatID(j)<50,    % we only consider GPS satellites, filtering GLONASS and others
                %% Get the numerical value
                obs=str2num(line80(pos:pos+16-1));
                if length(obs)>1, obs=obs(1); end
                %% Record P1 data
                if k==obsP1pos,
                    if isempty(obs),   mP1(vSatID(j),epoch)=0;  else  mP1(vSatID(j),epoch)=obs;  end
                end
                %% Record C/A data
                if k==obsC1pos,
                    if isempty(obs),  mC1(vSatID(j),epoch)=0;  else  mC1(vSatID(j),epoch)=obs; end
                end
                %% Record P2
                if k==obsP2pos,
                    if isempty(obs),   mP2(vSatID(j),epoch)=0; else  mP2(vSatID(j),epoch)=obs;     end
                end
                %% Record L1 phase observation
                if k==obsL1pos,
                    if isempty(obs),   mL1(vSatID(j),epoch)=0; else  mL1(vSatID(j),epoch)=obs;
                    end
                end
                %% Record L2 phase observation
                if k==obsL2pos,
                    if isempty(obs),  mL2(vSatID(j),epoch)=0; else  mL2(vSatID(j),epoch)=obs;
                    end
                end
                %% Record D1 phase observation
                if k==obsD1pos,
                    if isempty(obs),  mD1(vSatID(j),epoch)=0; else  mD1(vSatID(j),epoch)=obs;
                    end
                end
                %% Record D2 phase observation
                if k==obsD2pos,
                    if isempty(obs),  mD2(vSatID(j),epoch)=0; else  mD2(vSatID(j),epoch)=obs;
                    end
                end
            end
            %% Next observation
            pos=pos+16;
            %% Next line80 may includ also the observation of this satellite
            if (pos>80) && (k<totalobs),
                line80 = GetLine80(fid);
                pos=1;
            end
        end %% finished reading all the observation of this GPS satellite

        line80 = GetLine80(fid);
    end %% all GPS satellites of this epoch

%     %% Now there might be two cases. In one case, the RINEX file
%     %% contains only GPS data, then the next paragraph indicates the
%     %% observation data of the next epoch. In the other case, some non-GPS
%     %% satellite data are still presented, we then filter them out by
%     %% keep searching for 'G' in each line. Finding it implies that
%     %% a paragraph for the next satellite starts.
%     [ line80,eofs]=GetNextRINEXParagraph(fid);
 
    %% Show progress
    if rem(epoch,100)==0,
        str=sprintf('%d epochs processed. \n', epoch);
        WriteListbox(str,hlistbox);
    end
end
%% If the actual total number of epochs is less than the expected number
if epoch<totalepoch,
    vTime(epoch+1:totalepoch)=[];
    vTimeStr(epoch+1:totalepoch)=[];
    mP1(:,epoch+1:totalepoch)=[];
    mP2(:,epoch+1:totalepoch)=[];
    mC1(:,epoch+1:totalepoch)=[];
    mD1(:,epoch+1:totalepoch)=[];
    mD2(:,epoch+1:totalepoch)=[];
    mL1(:,epoch+1:totalepoch)=[];
    mL2(:,epoch+1:totalepoch)=[];
end
 
 


method.doppler_L1=1;
method.doppler_L2=1;
method.phase_poly_L1=1;
method.phase_poly_L2=1;
method.phase_code_L1_C1=1;
method.phase_code_L1_P1=1;
method.phase_code_L2_C1=1;
method.phase_code_L2_P2=1;
method.L1_L2_combination=1;
method.correction=1;


 

if obsL2pos==0,
     method.doppler_L2=0;
     method.phase_poly_L2=0;
     method.phase_code_L2_C1=0;
     method.phase_code_L2_P2=0;
     method.L1_L2_combination=0;
     method.correction=0; 
end

if obsD1pos==0,     method.doppler_L1=0; end
if obsD2pos==0,     method.doppler_L2=0; end
if obsP1pos==0,     method.phase_code_L1_P1=0; end
if obsP2pos==0,     method.phase_code_L2_P2=0; end
 
vSatInView=[];
for satid=1:1:totalGNSSsatellite,
    if sum(mC1(satid,:))~=0, vSatInView=[vSatInView satid] ; end        
end

ObsAvailable='';

if obsC1pos~=0,  ObsAvailable=strcat(ObsAvailable,'C1'); end
if obsL1pos~=0, ObsAvailable=strcat(ObsAvailable,'L1'); end
if obsP1pos~=0, ObsAvailable=strcat(ObsAvailable,'P1'); end
if obsL2pos~=0, ObsAvailable=strcat(ObsAvailable,'L2'); end
if obsP2pos~=0, ObsAvailable=strcat(ObsAvailable,'P2'); end
if obsD1pos~=0, ObsAvailable=strcat(ObsAvailable,'D1'); end
if obsD2pos~=0, ObsAvailable=strcat(ObsAvailable,'D2'); end


    totalepoch_real=epoch-1;
save(datafilename,'vTime','ObsAvailable','sampling_interval','mP1','mL1','mD1','mD2','vTimeStr','mP2','mL2','mC1','method','totalepoch','vSatInView');

 
% WriteListbox('Processing finished.',hlistbox)
pause(.1)
close (gcf)


%% Function for writting information on the ListBox
function WriteListbox(str,hlistbox)

mStrs=get(hlistbox,'String');
len=length(mStrs);
mStrs{len+1}=str;
set(hlistbox,'String',mStrs);
set(hlistbox,'Value',len+1);
pause(0.01)

% Get a line from a file
% If less than 80 chars, append it 
function line=GetLine80(fid)
line = fgetl(fid); 
if line==-1,  %% End of file
    return; 
end 
len = length(line);    
if len < 80, line(len+1:80) = '0'; end
 
% Get next paragraph of a RINEX
function [ line_str,eofs]=GetNextRINEXParagraph(fid)
eofs=0;
line_str=[];
while(1)
    line80 = GetLine80(fid);
    if line80==-1,         eofs=1; return;     end
    findgps=(length(findstr(line80,'G'))>1);
    findglonass=(length(findstr(line80,'R'))>1);
    if  findgps  || findglonass %% next epoch starts
        year = str2double(line80(1:3)); 
        if ~isempty(year), %% if it starts with time, it is a new paragraph
            line_str=line80;
            return
        end 
    else % the reading of this epoch is not finished
        line80 = GetLine80(fid);
        if line80==-1,                 eofs=1; return;             end % end of file
    end
end


