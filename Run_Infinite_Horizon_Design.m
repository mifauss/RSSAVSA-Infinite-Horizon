%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run experiment for a single value of alpha and s
% Adapted from 'Run_All_Designs.m', see the latter for more details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[] = Run_Infinite_Horizon_Design()

    % CVaR alpha levels of concern
    alpha = 0.5;
    
    % s value of concern
    s = 1;

    % Scenario IDs for state augmentation method with random cost max( gK(X_t) ) 
    scenarioID = 'WRSA0';
    
    % All scenarios:
    % 'WRSA0' 0: BASELINE DESIGN
    % 'WRSA1' 1: AUTOMATED PUMP, MAX PUMP RATE = 10
    % 'WRSA2' 2: OUTLET TO STORM SEWER, TANK 1
    % 'WRSA3' 3: INCREASE SURFACE AREA OF TANK 2 BY 20%
    
    % Configuration
    configID = (s+1)*10;
    
    % run inner-optimizations for exact method
    Run_Bellman_Recursion(scenarioID, configID);
    
    % Bellman recursions are now complete, however we need to perform an
    % outer optimization
    staging_area = get_staging_directory('', ''); 
    outer_optimization_file = strcat([staging_area,'outer_optimization.mat']);
    
    if isfile(outer_optimization_file)
        disp('Skipping outer optimization, file already exists.'); 
    else
        [V_alpha, real_coordinates] = Run_Outer_Optimization(scenarioID, configID, configID, alpha);
        save(outer_optimization_file); 
    end
 
end