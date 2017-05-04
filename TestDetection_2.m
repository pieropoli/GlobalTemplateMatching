clear
clc
close

load template
load datatest

for ix = 1 : size(AGCbin,1)
    for iy = 1 : size(AGCbin,2)
        
        if isnan(AGC(ix,iy)) == 1 || AGC(ix,iy) <4 
        AGC(ix,iy)=0;
            
        end
        
        if  AGCbin(ix,iy)<3
            
            
            AGCbin(ix,iy)=0;
       
            
        end
    end
end 

%AGC = AGC+rand(size(AGC));

%% reshuffle data
I = randperm(size(AGC,1));
fakeAGC = AGC(I,:);



%% create fake dataset

data = zeros(size(AGC,1),size(AGC,2)*10).*2;
datafake = data;

data(:,size(AGC,2)*3:size(AGC,2)*3+size(AGC,2)-1) = AGC;
datafake(:,size(AGC,2)*3:size(AGC,2)*3+size(AGC,2)-1) = fakeAGC;

data = data + rand(size(data));
datafake = datafake + rand(size(datafake));
%% make detection
T = 1 : 1 : size(data,2) - size(AGCbin,2)-1;

tic
for id = 1 : length(T) - 1
    
    
   tmp = dot(AGCbin,data(:,T(id):T(id)+size(AGCbin,2)-1)); 
    
   detection(id) = max(tmp); 
    
      tmp = dot(AGCbin,datafake(:,T(id):T(id)+size(AGCbin,2)-1)); 
    
   fakedetection(id) = max(tmp); 
     
    
    
    
end
toc
plot(size(AGC,2)*3,max(detection-mean(detection)),'sk','MarkerSize',20)
hold on

plot(detection-mean(detection))
hold on
plot(fakedetection-mean(detection),'r')

hold on
