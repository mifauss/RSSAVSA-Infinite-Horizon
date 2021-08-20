close all; clearvars; clc;

% CVaR alpha level of concern
alpha = 0.05;
    
% s values of concern on the cluster, we want this to be 0 : 0.1 : 2
mys_values = 0: 0.1: 2;

% scenarioID is defined in Configuration Options/get_scenario
% Scenario ID for state augmentation method with random cost max( gK(X_t) ) 
% We define different scenarios by changing N.
% N is changed in set_up_reachability.m
scenarioID(1) = "WRSA0";   
scenarioID(2) = "WRSA1";   
scenarioID(3) = "WRSA2";   
scenarioID(4) = "WRSA3";   
scenarioID(5) = "WRSA4";   
% V_alpha{1} is numerical estimate of inf CVaR( sup_{t = 0,1,...} g_K( X_t ) ) for
% particular alpha value and a particular initial state
parfor i = 1:5
[V_alpha] = Run_Infinite_Horizon_Design_MPC(scenarioID(i), alpha, mys_values);
end

% This generates outer optimization files for all
generate_out_optimization_files();

%This generates separate figure files
generate_separate_figures();

%This generates the whole figure and save as Final_Figure.eps under
%staging/figures
generate_whole_figure([0.99 0.05 0.0005],[200 300 400]);

