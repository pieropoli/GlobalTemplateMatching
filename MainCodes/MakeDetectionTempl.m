clear
clc
close

% This code make the detection and it is pretty slow need to be improved

%%  make synth template matrix
sacdir = 'Synth';
d = dir(sacdir);d(1:2)=[];
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/RepeatingEvents/RepeatingFromMatMatrix/src/travelTime_directPprem_0_700kmdepth_0_90distance.mat');

for i1 = 1: length(d)
    
    load([sacdir '/' d(i1).name]);
    
    %  [tP] =GetTraveltimeFast(dist,0,depth,ddist,ttime);
    
    
    F = find(staltaout<2);
    F2 = find(staltaout>2);
    staltaout(F)=0;
    staltaout(F2)=1;
    
    temp(i1,:) = staltaout;
    dd(i1) = dist;
    % TP(i1)=tP;
    
end

[dd,ix] = sort(dd);
temp = temp(ix,:);


%%  make real data template matrix
sacdir = 'RealData';
d = dir(sacdir);d(1:2)=[];

for i1 = 1: length(d)
    
    load([sacdir '/' d(i1).name]);
    F = find(staltaout<2);
    F2 = find(staltaout>2);
    
    data(i1,:) = staltaout;
    la(i1) = lat;
    lo(i1) = lon;
    
    
end


%% make detection
% load points on the Earth surface
load('points.mat')
det = zeros(length(lon),size(data,2));

X = lon;
Y = lat;



% from here the code need to go much faster
for iy = 1 : length(Y) % loop over points
    
    
    D = distance(Y(iy),X(iy),la,lo);
    [D,IX] = sort(D);
    rtmp = data(IX,:);
    
    
    % buid synth matrix
    temp1=zeros(length(D),size(temp,2));
    
    for is = 1 : length(D)
        [~,F] = min(abs(D(is)-dd));
        temp1(is,:) = temp(F,:);
    end
    
    for i1 = 1: size(rtmp,2) - size(temp,2) - 1 % loop over time
        
        tmp = rtmp(:,i1:i1+size(temp1,2)-1) ;
        for id = 1 : size(tmp,1) % this can be done in matrix form!!!
        cctmp(id) =  corrc_norm(tmp(id,:),temp1(id,:));
        end
        % plot
%          subplot(221)
% imagesc(tmp)
% subplot(222)
% imagesc(temp1)
% subplot(223)
% imagesc(temp1.*tmp)
% subplot(224)
% plot(sum(temp1.*tmp,1))
%         
        
       % ctmp = dot(tmp,temp1,1);
        
        det(iy,i1) = mean(cctmp);
        clear tmp ctmp
        
    end
end