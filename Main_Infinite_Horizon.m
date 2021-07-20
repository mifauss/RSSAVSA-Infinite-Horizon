close all; clearvars; clc;

% CVaR alpha level of concern
alpha = 0.05;
    
% s values of concern on the cluster, we want this to be 0 : 0.1 : 2
mys_values = 0: 0.2: 2;

% scenarioID is defined in Configuration Options/get_scenario
% Scenario ID for state augmentation method with random cost max( gK(X_t) ) 
% We define different scenarios by changing N.
% N is changed in set_up_reachability.m
scenarioID = 'WRSA0';   

% V_alpha{1} is numerical estimate of inf CVaR( sup_{t = 0,1,...} g_K( X_t ) ) for
% particular alpha value and a particular initial state
[V_alpha] = Run_Infinite_Horizon_Design_MPC(scenarioID, alpha, mys_values);

% This provides contours of safe sets
Plot_Infinte_Horizon_Figure3(scenarioID);

%% Run similar to what's below if code breaks at a particular s_index

for s_index = 4 : length(mys_values)
            
        s = mys_values(s_index);
        
        configID = (s+1)*10; % Configurations, must be integers

        % run inner-optimizations for exact method
        Run_Bellman_Recursion(scenarioID, configID);
            
end

%% Notes from old experiments

% Older version: Plot_Infinte_Horizon_Figure2(j,N)

% results from previous experiments (playing around):
% when s = 1; N = 10 vs. N = 30, maxdiff = 0.0350 (grid 1/3)
% when s = 1; N = 10 vs. N = 40, maxdiff = 0.0381
% when s = 1; N = 30 vs. N = 60, maxdiff = 0.0070
% with s = [0.5, 1, 1.5]; N = 10 vs. N = 30, maxdiff = 0.495 (grid 1/3)
% max(V_alphas_to_compare{2}) = 11 way too big (want to be close to 2)
% mys_values = 0 : 0.25: 2; N = 10 vs. N = 30, maxdiff = 0.5104 (grid 1/3)
% max(V_alphas_to_compare{2}) = 2 Good!!!
% mys_values = 0 : 0.25: 2; N = 30 vs. N = 60, maxdiff = .6061 (grid 1/3)
% mys_values = 0 : 0.25: 2; N = 60 vs. N = 90, 