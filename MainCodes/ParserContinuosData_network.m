clear
clc
close

% Code to parse data from obspyDMT to Matlab.
% This function parse the continuous data. The output is a matrxi with
% stations in lines. The input is from obspyDMT...
%
%
% TO DO ...
% 1) add other components
% 2) add check for zeros
disp('add some checking for zeros!')

% Piero Poli. 5/3/17, MIT, Cambridge
% v 0.0.0


%% MAIN CODE

% paths needed
addpath ~/Seismic_Matlab_Functions/


%% parameter for the parsing
hours_lim = 20; % required hours recorded in a day by a give station
FB = [1 4];
newTau = 0.1;
limtime=1;
type='vel';
inputDirectory= '/Users/pieropoli/Data/netDataSwarm2017/2017-04-21_2017-04-24'; % this is the directory in which you have the data
outDirectory='test';

%% read the catalog
if exist(outDirectory,'dir') ~= 7
    mkdir(outDirectory)
end
te = textread([char(inputDirectory) '/EVENTS-INFO/catalog.txt'],'%[^\n]');
cnt = 1;
for ind = 19 : 11 : size(te,1)
    
    tmp =te{ind+7};
    n = find(isspace(tmp)==1)+1;
    lat(cnt)= str2num(tmp(n:end));
    
    tmp =te{ind+8};
    n = find(isspace(tmp)==1)+1;
    lon(cnt)= str2num(tmp(n:end));
    
    tmp =te{ind+6};
    n = find(isspace(tmp)==1)+1;
    dep(cnt)= str2num(tmp(n:end));
    
    tmp =te{ind+4};
    n = find(isspace(tmp)==1)+1;
    magnitude(cnt)= str2num(tmp(n:end));
    
    tmp = te{ind+3};
    n = find(isspace(tmp)==1, 1, 'last' );
    tmp(1:n) = [];
    year =str2num(tmp(1:4));
    month  = str2num(tmp(6:7));
    day  = str2num(tmp(9:10));
    hour  = str2num(tmp(12:13));
    minut  = str2num(tmp(15:16));
    sec  = str2num(tmp(18:26));
    date(cnt,:) =  [year month day hour minut sec];
    
    
    tmp = te{ind+2};
    n = find(isspace(tmp)==1, 1, 'first' );
    nameEvents{cnt,:} = deblankl(tmp(n:end));
    
    tmp = te{ind+1};
    n = find(isspace(tmp)==1, 1, 'last' );
    catalogtype{cnt,:} = deblankl(tmp(n:end));
    
    
    cnt  =cnt+1;
end


%% loop over days
for i1 = 1 %: size(lon,2)
    
    %accuratetime = date(i1,:);
     accuratetime = [2004 12 26 0 0 0];
    
    cnt = 1; % station counter
    % DIR = ([char(inputDirectory) '/continuous1/processed']);
    
    if strcmp('vel',type)==1
        DIR = ([char(inputDirectory) '/' char(nameEvents{i1,1}) '/BH_VEL']);
    elseif strcmp('dis',type)==1
        DIR = ([char(inputDirectory) '/' char(nameEvents{i1,1}) '/BH']);
    elseif strcmp('raw',type)==1
        DIR = ([char(inputDirectory) '/' char(nameEvents{i1,1}) '/BH_RAW']);
    end
    datadir=dir(DIR);
    datadir(1:2)=[];
    
    for i2 = 1 : size(datadir,1)
        
        % [t,a,p]=RDsac2([char(DIR) '/' char(datadir(i2, 1).name)]);
        % [D,T0,H]=rdsac([char(DIR) '/' char(datadir(i2, 1).name)]);
        s=readsac([char(DIR) '/' char(datadir(i2, 1).name)]);
        nzeros = find(s.trace==0);
        
        
        if length(s.trace)*s.tau > limtime*3600*hours_lim
            
            [dateV] = doy2date(s.jr,s.an);
            dateSeismogram = datevec(dateV);
            dateSeismogram(4) = s.hr;
            dateSeismogram(5) = s.mn;
            dateSeismogram(6) = s.sec;
            
            dt0z= etime(dateSeismogram,accuratetime) ;%- s.pointe; %% careful with this
            dtend = addtodate(datenum(accuratetime),1,'day');
            dtSend = addtodate(datenum(dateSeismogram),round(length(s.trace)*s.tau),'second');
            dt0zEnd= etime(datevec(dtend),datevec(dtSend)) ;
            
            
            
            if abs(dt0z) < s.tau; dt0z=0;end
            
            %% filter
            [a1,b1]=butter(2,FB*2*s.tau);
            tmp  = filtfilt(a1,b1,s.trace).*tukeywin(length(s.trace),.05);
            
            %% cut the end of the seismogram if it is over after 24hr
            if dt0zEnd<0
                Tcut = round(dt0zEnd/s.tau);
                tmp(end+Tcut:end) = [];
            end
            %% cut if it is longer before midnight
            if dt0z < 0
                Tcut = round(dt0z/s.tau);
                tmp(1:Tcut) = [];
            end
            
            %% resample the trace
            t = 0:s.tau:((length(tmp)-1)*s.tau);
            t2 = 0:newTau:((length(tmp)-1)*s.tau);
            
            tmpi = interp1(t,tmp,t2);
            trace = zeros(1,86400/newTau);
            clear tmp
            
            %% align to midnight
            if dt0z > 0
                T1 = round(dt0z/newTau);
                trace(T1:T1+length(tmpi)-1) = tmpi;
                s.t0 = dateSeismogram;
            else
                trace(1:length(tmpi)) = tmpi;
                s.t0=accuratetime;
            end
            
            % check the length is not different form 24 hours
            checklenghth = length(trace) -  (86400/newTau);
            if checklenghth>0 && checklenghth < 2
                trace(checklenghth) = [];
                issue=0;
            elseif checklenghth > 2
                issue = 1;
                disp('problem in aligning seismograms')
            else
                issue = 0;
            end
            if issue == 0
                %% store the seismogram
                out.trace = trace;
                out.hr=0;
                out.mn=0;
                out.sec=0;
                out.npts=length(trace);
                out.FB = FB;
                out.tau=newTau;
                out.day = datevec2doy(s.t0);
                out.hr = s.t0(4);
                out.mn = s.t0(5);
                out.sec=s.t0(6);
                out.year=s.t0(1);
                out.stlat = s.slat;
                out.stlon = s.slon;
                out.staname=deblank(s.staname);
                out.kcomp=deblank(s.kcomp);
                out.b=s.pointe;
                out.date = accuratetime;
                save([outDirectory '/station_' (out.staname) ],'out')
                clear out
                %cnt = cnt+1;
            end
            clear trace s
            
            
        end
    end
        
    
end
