clear
clc
close

%% codes to make the STA LTA for Synthetic data
% paremters are
% STA in minutes
% LTA in minutes
% FB ferquecy band for filtering
% the output data are resmpled at 1hz to save computation time

FB = [0.03 0.05];
STA = 2; %in mimutes
LTA = 15;
sacdir = '/Users/pieropoli/Research/GlobalTemplateMatching/Synthetics/sac';

% create output directory
outdir = ['Synth_STA' num2str(STA) 'LTA' num2str(LTA) 'FB' num2str(min(FB)) '-' num2str(max(FB))];
mkdir(outdir)

% read synthetic sac files
d = dir(sacdir);d(1:2)=[];

for i1 = 1: length(d)

    s=readsac([sacdir '/' d(i1).name]);
    if (str2double(s.staname)-1)*0.5 > 3
    
    [a1,b1]=butter(2,FB*2*s.tau);
    s.trace = filtfilt(a1,b1,s.trace);
    
    T0 = length(s.trace)*2*s.tau-LTA*60;
    % pad trace with zeros
    trace = zeros(1,length(s.trace)*3);
    trace(length(s.trace)*2:end-1)=s.trace;
    s.trace = trace;
    s.trace = s.trace./max(abs(s.trace)) + rand(size(s.trace))/1000;
    
    
    Tlta = LTA*60/s.tau+1 : 1 : length(s.trace); 

    lta = zeros(1,length(Tlta)-1);
    sta=lta;
    for it = 1 : length(Tlta) - 1
    
       t1 = round(Tlta(it)-LTA*60/s.tau); 
       lta(it) = mean(abs(s.trace(t1:round(Tlta(it)))));
       t1 = round(Tlta(it)-STA*60/s.tau); 
       sta(it) = mean(abs(s.trace(t1:round(Tlta(it)))));

    end

    
    %% resample and store
    staltaout = (resample(sta./lta,1,10));
    staltaout(1:round(T0))=[];
    dist =(str2double(s.staname)-1)*0.5;
    Fs=1;
    %% save 
    save([outdir '/stalta_' char(s.staname)],'staltaout','dist','Fs')
    
    end
end