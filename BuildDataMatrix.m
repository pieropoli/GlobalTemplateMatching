clear
clc
close


%% load data
load('/Users/pieropoli/Research/GlobalTemplateMatching/RealDataSumatra/data_20041226_1.mat')

win=5;

for id = 1 : size(data.data,1)
    
    
    
       % make average trace
    T = 1 : win/data.tau : length(data.data)-1;
    
    if id == 1
        smean = zeros(size(data.data,1),length(T));
    end
    
    
    trace = abs(data.data(id,:));
    
    for it = 1 : length(T)-1
        smean(id,it) = mean(abs(trace(round(T(it)):round(T(it+1)))));
    end 

end


% do AGC
Nbefore = 9;
Tagc = Nbefore:1:size(smean,2)-Nbefore;

for iagc = 1 : length(Tagc)

    tmp =  smean(:,Tagc(iagc)-Nbefore+1:Tagc(iagc));
    meanagc = mean(tmp,2);
    AGC(:,Tagc(iagc)) = smean(:,Tagc(iagc))./meanagc;

end
