clear
clc
close

load template_filt
load datatest_filt

for ix = 1 : size(AGCbin,1)
    for iy = 1 : size(AGCbin,2)
        
        if isnan(AGC(ix,iy)) == 1
        AGC(ix,iy)=0;
            
        end
        
        if  AGCbin(ix,iy)<3
            
            
            AGCbin(ix,iy)=0;
       
            
        end
    end
end 

AGC = AGC+rand(size(AGC));


%% reshuffle data
I = randperm(size(AGC,1));
fakeAGC = AGC(I,:);

%% detection
detreal = AGC.*AGCbin;
detfake = fakeAGC.*AGCbin;

%% cross dot
Cdotreal = dot(AGC,AGCbin);

Cdotfake = dot(fakeAGC,AGCbin);


%% plot
subplot(321)
imagesc(AGC);colorbar

subplot(322)
imagesc(fakeAGC);colorbar


subplot(323)
imagesc(detreal);colorbar

subplot(324)
imagesc(detfake);colorbar


subplot(325)
plot(Cdotreal)
ylim([0 1000])
subplot(326)
plot(Cdotfake)
ylim([0 1000])
