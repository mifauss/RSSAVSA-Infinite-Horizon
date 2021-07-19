%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run experiment for a single value of alpha and s
% Adapted from 'Run_All_Designs.m', see the latter for more details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [V_alpha] = Run_Infinite_Horizon_Design_MPC()

    % CVaR alpha levels of concern
    alpha = 0.05;
    
    % s values of concern
    % on the cluster, we want this to be 0 : 0.1 : 2
    mys_values = 0 : 0.2: 2;
    
    for i = 1 : length(mys_values)
        configIDvec(i) = (mys_values(i)+1)*10;
    end
    
    configIDstart = (mys_values(1)+1)*10;
        
    configIDend = (mys_values(end)+1)*10;

    % Scenario IDs for state augmentation method with random cost max( gK(X_t) ) 
    % We define different scenarios by changing N.
    % N is changed in set_up_reachability.m
    % To facilitate faster experiments, right now, we use
    % get_runoff_disturbance_profile_almostdet() (very few values of ws, average ws is about 2), and
    % few allowable controls (0:0.3:1) in fill_scenario_fields_baseline.
    
    %myscenarioIDs = {'WRSA0', 'WRSA1', 'WRSA2', 'WRSA3','WRSA4', 'WRSA5', 'WRSA6' };
    %num_scenario_IDs = length(myscenarioIDs);
    %V_alphas_to_compare = cell(num_scenario_IDs,1);
     
    %for j = 1 : num_scenario_IDs
    % just running the last one for simplicity
    %for j = num_scenario_IDs  : num_scenario_IDs 
        
    scenarioID = 'WRSA7'; 

    for s_index = 1 : length(mys_values)
            
        s = mys_values(s_index);
        
        configID = (s+1)*10; % Configurations, must be integers

        % run inner-optimizations for exact method
        Run_Bellman_Recursion(scenarioID, configID);
            
    end

        % Bellman recursions are now complete, however we need to perform an
        % outer optimization
        staging_area = get_staging_directory('', ''); 
        outer_optimization_file = strcat([staging_area,'outer_optimization_', scenarioID, '.mat']); %this saves data for scenario associated with indexj

    if isfile(outer_optimization_file)
        disp('Skipping outer optimization, file already exists.'); 
        load(outer_optimization_file);
    else
        [V_alpha, real_coordinates] = Run_Outer_Optimization_MPC(scenarioID, configIDstart, configIDend, alpha, configIDvec);
        save(outer_optimization_file);
    end
        
        %V_alphas_to_compare{j} = V_alpha{1}; % we are only considering 1 value of alpha for now.
 
   % end
    
    % what I wrote when I was trying to compare quantitatively. It's easier
    % I think just to plot (see commands outside of loop)
    %if num_scenario_IDs ~= 2
    %    warning('max diff calculation only for first and second scenarios');
    %end
    % assumes that we only comparing two scenarios
    % maxdiff = max(abs(V_alphas_to_compare{3}-V_alphas_to_compare{2}));
    
end

% this is what I've been running
% close all; clearvars; clc; [V_alpha] = Run_Infinite_Horizon_Design_MPC();
% Need to change Plot_Infinte_Horizon_Figure2(j,N)
% Plot_Infinte_Horizon_Figure2(j,N), where j is associated with the
% outer_optimization_file in line 54

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
