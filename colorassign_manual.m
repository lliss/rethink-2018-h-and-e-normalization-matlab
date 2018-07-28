function [idx,lumen,nuclei,stroma,cytoplasm] = colorassign_manual(rgb)
% Color assignment


%% Program options and constants

% Cluster parameters
NCLUST = 10;                % number of clusters
CLUSTERITER = 1e5;          % maximum k-means iterations

%% Manual color assignment
   
% deconstruct RGB into constituent HSV parts
[ysize,xsize,~] = size(rgb);
hsv = rgb2hsv(rgb);
clear rgb;

% transform HSV from cylindrical to cartesian coordinates
[hsvc(:,:,1),hsvc(:,:,2),hsvc(:,:,3)] = pol2cart(2*pi*hsv(:,:,1),hsv(:,:,2),hsv(:,:,3));
clear hsv;

% change order
hsvc = permute(hsvc,[3 1 2]);
hsvc = hsvc([1 2 3],:);

% Perform k-means clustering
% For purposes of reproducing output set the random number
% generator to a fixed integer by enabling the following line.
% rng(1); 
idx = kmeans(hsvc',NCLUST,'MaxIter',CLUSTERITER);

% create index image
idx = reshape(idx,[ysize, xsize]);

% identify centroids in HSV-C space
centroidc = NaN(NCLUST,3);
for i = 1:NCLUST
    centroidc(i,:) = mean(hsvc(:,idx==i),2);
end
clear hsvc;

% transform centroids to HSV space
centroid = NaN(size(centroidc));
for i = 1:NCLUST
    [centroid(i,1),centroid(i,2),centroid(i,3)] = cart2pol(centroidc(i,1),centroidc(i,2),centroidc(i,3));
    centroid(i,1) = mod(centroid(i,1),2*pi)/2/pi;
end

% define colormap
cmap = hsv2rgb(centroid);

% user defined classes (GUI)
classidx = HEselector5(idx,cmap);

% parse classidx into classes
lumen = find(classidx==1);
nuclei = find(classidx==2);
stroma = find(classidx==3);
cytoplasm = find(classidx==4);
