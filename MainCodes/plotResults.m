clear
clc
close
load results.mat


for i1 = 1 : size(det,2);M(i1)=max(det(:,i1));end
evlon=105.854;
evlat=3.316;
  D = distance(evlat,evlon,la,lo);
    [D,IX] = sort(D);
    rtmp = data(IX,:);

for i1 = 1 : 4000;
    
    subplot(221)
    scatter(X,Y,50,det(:,i1),'filled');caxis([16000 18000]);
    caxis([max(M)./2 max(M)])
    subplot(222)
    plot(M)
    hold on
    plot(i1,M(i1),'or')
    xlim([0 4000])
    ylim([max(M)./2 max(M)])
    subplot(224)
    plot(rtmp(10,:))
    xlim([0 4000])
    pause(0.01);clf;

end