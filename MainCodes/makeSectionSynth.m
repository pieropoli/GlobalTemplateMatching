clear
clc
close

% read synthetic sac files
sacdir = 'Synth';
d = dir(sacdir);d(1:2)=[];
load('/Users/pieropoli/Autmoatic_Parsing_Downloading_Events/RepeatingEvents/RepeatingFromMatMatrix/src/travelTime_directPprem_0_700kmdepth_0_90distance.mat');

for i1 = 1: length(d)
    
    load([sacdir '/' d(i1).name]);
    
  %  [tP] =GetTraveltimeFast(dist,0,depth,ddist,ttime);

    
    F = find(staltaout<3);
    F2 = find(staltaout>3);
%      staltaout(F)=0;
%      staltaout(F2)=1;
    
    r(i1,:) = staltaout;
    dd(i1) = dist;
   % TP(i1)=tP;
    
end

[dd,ix] = sort(dd);
r = r(ix,:);

imagesc(r)
