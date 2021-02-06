clc
clear
close all
%% initial
% C = [0 0;5 1; 2 8];
% data = data_gen(C, 100, 1);
% save('data.mat','data');
load('data.mat','data');
K = 3; % number of clusters
maxitr = 50; % maximum iteration
centroids = data(randi(size(data,1),[K,1]),:); % Forgy method
%% main loop
for itr = 1 : maxitr
    disp(['iteration : ' num2str(itr)])
% update clusters
cluster = update_clusters(data, centroids); % cluster corresponding to each data

% update centroids
centroids = update_centroids(data, cluster, K);
end

% plot results
plot_results(data, centroids, cluster, K)

%% functions
function y = data_gen(C, n_data, sigma)
    y = [];
    for idx = 1 : size (C, 1)
        y = [y; mvnrnd(C(idx,:), sigma * ones(1,size(C,2)), n_data)];
    end
end

function y = update_clusters(data, centroids)

% returns nearest centroid to each data
    dist = pdist2(data, centroids);
    [min_val, min_idx] = min(dist,[],2);
    y = min_idx;
% latest cost
    disp(['cost : ' num2str(sum(dist(:)))])
end

function y = update_centroids(data, cluster, K)
    for idx = 1 : K
        y(idx, :) = mean(data(cluster == idx, :));
    end
end

function plot_results(data, centroids, cluster, K)
    colors = hsv(K);
    for idx = 1 : K
        plot(data(cluster == idx,1),data(cluster == idx,2),'x', 'Color',colors(idx,:));
        hold on
    end
    plot(centroids(:,1),centroids(:,2),'ko', 'MarkerSize',5,'MarkerFaceColor','k');
end