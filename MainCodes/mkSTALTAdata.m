clear
clc
close
%% codes to make the STA LTA for Real cont. data
% paremters are
% STA in minutes
% LTA in minutes
% FB ferquecy band for filtering
% the output data are resmpled at 1hz to save computation time
% this code read matlab files of cont. data created from: ParserContinuosData_network.m 


FB = [0.03 0.05];
STA = 2; %in mimutes
LTA = 15;

% create output directory
outdir = ['Data_STA' num2str(STA) 'LTA' num2str(LTA) 'FB' num2str(min(FB)) '-' num2str(max(FB))];
mkdir(outdir)

sacdir = '/Users/pieropoli/Research/GlobalTemplateMatching/cont_data_Sumatra';


% read  mat files
d = dir(sacdir);d(1:2)=[];



for i1 = 1: length(d)

    load([sacdir '/' d(i1).name]); 
    s = out; 
    Tlta = LTA*60/s.tau+1 : 1 : length(s.trace); 
    for it = 1 : length(Tlta) - 1
    
       t1 = round(Tlta(it)-LTA*60/s.tau); 
       lta(it) = mean(abs(s.trace(t1:round(Tlta(it)))));
       
       t1 = round(Tlta(it)-STA*60/s.tau); 

       sta(it) = mean(abs(s.trace(t1:round(Tlta(it)))));

    end

    staltaout = (resample(sta./lta,1,10));
    lat = s.stlat;
    lon = s.stlon;
    Fs=1;
    %% save 
    save([outdir '/stalta_' char(s.staname)],'staltaout','lat','lon','Fs')
    
    
end