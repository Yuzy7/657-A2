%% Load data

load('DataF');

%% Normalization

[r,c] = size(fea);

for i=1:c
    meanval = mean(fea(:,i));
    
    for j=1:r
        fea(j,i) = fea(j,i) - meanval;
    end
end

%% Apply PCA to reduce the dimension to be 4

% %one way
% covMatrix = cov(fea);
% [eigenVector, eigenValues] = eig(covMatrix);
% feaD4 = fea*eigenVector(:, end:-1:end-3);

%another way
[~,score,latent,~,~,~] = pca(fea);
feaD4 = score(:,1:4);

% Cluster the data using agglomerative algorithms in hierarchical clustering 
%% Single Link
% %one way
% tree_singlelink = linkage(feaD4, 'single');
% cluster_singlelink = cluster(tree_singlelink, 'maxclust', 10);

%another way
cluster_singlelink = clusterdata(feaD4, 'linkage', 'single', 'maxclust', 10);

% evaluate the clustering result of Single Link
%% Separation Index of Single Link:                                        need to be added

[r,c] = size(fea);

%% Rand index of Single Link:

[r,c] = size(fea);
M = (r*(r-1))/2; %total number of pairs of samples

a = 0; %number of samples in the same class and the same cluster
b = 0; %number of samples in different classes and different clusters

for i = 1:r
    for j = i+1:r
        if (gnd(i) == gnd(j)) && (cluster_singlelink(i) == cluster_singlelink(j))
            a = a + 1;
        elseif (gnd(i) ~= gnd(j)) && (cluster_singlelink(i) ~= cluster_singlelink(j))
            b = b + 1;
        end
    end
end

Randindex_singlelink = (a + b) / M;

%% F-measure of Single Link:

mij = zeros(10,10);
ni = zeros(10,1);
mj = zeros(10,1);
precision_singlelink = zeros(10,10);
recall_singlelink = zeros(10,10);
f_singlelink = zeros(10,10);
Fmeasure_singlelink = 0;

for i = 1:r
    mij(cluster_singlelink(i), gnd(i)+1) = mij(cluster_singlelink(i), gnd(i)+1) + 1;
    ni(cluster_singlelink(i)) = ni(cluster_singlelink(i)) + 1;
    mj(gnd(i)+1) = mj(gnd(i)+1) + 1;
end

for i=1:10
    for j=1:10
        precision_singlelink(i,j) = mij(i,j) / ni(i);
        recall_singlelink(i,j) = mij(i,j) / mj(j);
        f_singlelink(i,j) = 1 / (1/precision_singlelink(i,j) + 1/recall_singlelink(i,j));
    end
end

for j=1:10
    Fmeasure_singlelink = Fmeasure_singlelink + mj(j,1) / r * max(f_singlelink(:,j));
end

%% Complete Link

cluster_completelink = clusterdata(feaD4, 'linkage', 'complete', 'maxclust', 10);

% evaluate the clustering result of Complete Link
%% Rand index of Complete Link:
[r,c] = size(fea);
M = (r*(r-1))/2; %total number of pairs of samples

a = 0; %number of samples in the same class and the same cluster
b = 0; %number of samples in different classes and different clusters

for i = 1:r
    for j = i+1:r
        if (gnd(i) == gnd(j)) && (cluster_completelink(i) == cluster_completelink(j))
            a = a + 1;
        elseif (gnd(i) ~= gnd(j)) && (cluster_completelink(i) ~= cluster_completelink(j))
            b = b + 1;
        end
    end
end

Randindex_completelink = (a + b) / M;

%% F-measure of Complete Link:
mij = zeros(10,10);
ni = zeros(10,1);
mj = zeros(10,1);
precision_completelink = zeros(10,10);
recall_completelink = zeros(10,10);
f_completelink = zeros(10,10);
Fmeasure_completelink = 0;

for i = 1:r
    mij(cluster_completelink(i), gnd(i)+1) = mij(cluster_completelink(i), gnd(i)+1) + 1;
    ni(cluster_completelink(i)) = ni(cluster_completelink(i)) + 1;
    mj(gnd(i)+1) = mj(gnd(i)+1) + 1;
end

for i=1:10
    for j=1:10
        precision_completelink(i,j) = mij(i,j) / ni(i);
        recall_completelink(i,j) = mij(i,j) / mj(j);
        f_completelink(i,j) = 1 / (1/precision_completelink(i,j) + 1/recall_completelink(i,j));
    end
end

for j=1:10
    Fmeasure_completelink = Fmeasure_completelink + mj(j,1) / r * max(f_completelink(:,j));
end

%% Ward's Algorithm(minimum variance algorithm)

cluster_ward = clusterdata(feaD4, 'linkage', 'ward', 'maxclust', 10);
% evaluate the clustering result of Ward's
%% Rand index of Ward's:
[r,c] = size(fea);
M = (r*(r-1))/2; %total number of pairs of samples

a = 0; %number of samples in the same class and the same cluster
b = 0; %number of samples in different classes and different clusters

for i = 1:r
    for j = i+1:r
        if (gnd(i) == gnd(j)) && (cluster_ward(i) == cluster_ward(j))
            a = a + 1;
        elseif (gnd(i) ~= gnd(j)) && (cluster_ward(i) ~= cluster_ward(j))
            b = b + 1;
        end
    end
end

Randindex_ward = (a + b) / M;

%% F-measure of Ward's:
mij = zeros(10,10);
ni = zeros(10,1);
mj = zeros(10,1);
precision_ward = zeros(10,10);
recall_ward = zeros(10,10);
f_ward = zeros(10,10);
Fmeasure_ward = 0;

for i = 1:r
    mij(cluster_ward(i), gnd(i)+1) = mij(cluster_ward(i), gnd(i)+1) + 1;
    ni(cluster_ward(i)) = ni(cluster_ward(i)) + 1;
    mj(gnd(i)+1) = mj(gnd(i)+1) + 1;
end

for i=1:10
    for j=1:10
        precision_ward(i,j) = mij(i,j) / ni(i);
        recall_ward(i,j) = mij(i,j) / mj(j);
        f_ward(i,j) = 1 / (1/precision_ward(i,j) + 1/recall_ward(i,j));
    end
end

for j=1:10
    Fmeasure_ward = Fmeasure_ward + mj(j,1) / r * max(f_ward(:,j));
end

%% the number of clusters in Ward's from 2 to 15
for i = 2:15
    cluster_ward = clusterdata(feaD4, 'linkage', 'ward', 'maxclust', i);
    %optimal number of clusters suggested by Separation- Index             need to be added
end

%% Cluster the data using K-means algorithm

%the number of clusters from 2 to 15
for i = 2:15
    [cluster_kmeans,centroid] = kmeans(feaD4, i);
end

%% Cluster the data using Fuzzy C-means algorithm

%set the exponent for partition matrix to 2
options = [2; nan; nan ; nan];
[center, cluster_fcmeans, obj_fcn] = fcm(feaD4, 10, options);


%%
clusters = max( cluster_fcmeans);
% classes(i) = cluster_fcmeans(:,i) = clusters(i);
%class1 = cluster_fcmeans(:,1) 
