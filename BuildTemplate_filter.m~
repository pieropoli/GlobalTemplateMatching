clear
clc
close

%% this code build templates from synthetic seismograms, using the methods of Shearer 1991

win = 5; % time window for averaging seismograms in seconds.


% read synthetic sac files
sacdir = '/Users/pieropoli/Research/GlobalTemplateMatching/Synthetics/sac';
d = dir(sacdir);d(1:2)=[];


for i1 = 1 : length(d)
    s = readsac([sacdir '/' d(i1).name]);
    dist = (str2double(s.staname)-1)*0.5;
    [a1,b1]=butter(2,[0.1 1]*2*s.tau);
    s.trace = filtfilt(a1,b1,s.trace);
    
    
    % make average trace
    T = 1 : win/s.tau : length(s.trace)-1;
    if i1 == 1
        smean = zeros(length(d),length(T));
    end
    
    
    s.trace = abs(s.trace);
    
    for it = 1 : length(T)-1
        smean(str2double(s.staname),it) = mean(abs(s.trace(round(T(it)):round(T(it+1)))));
    end
end

% do AGC
Nbefore = 9;
Tagc = Nbefore:1:size(smean,2)-Nbefore;

for iagc = 1 : length(Tagc)

    tmp =  smean(:,Tagc(iagc):Tagc(iagc)+Nbefore-1);
    meanagc = mean(tmp,2);
    AGC(:,Tagc(iagc)) = smean(:,Tagc(iagc))./meanagc;

end

save datatest_filt AGC

AGCbin = AGC;
%% remove NaN

for ix = 1 : size(AGC,1)
    for iy = 1 : size(AGC,2)
        
        
        if isnan(AGC(ix,iy)) ==1 %|| AGC(ix,iy)<3
            
            
            AGCbin(ix,iy)=0;
       
            
        end
    end
end 


save template_filt AGCbin