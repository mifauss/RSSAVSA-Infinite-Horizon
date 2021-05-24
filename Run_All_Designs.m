%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Runs all experiments for required to generate artifacts
% presented in Chapman, et al., “Risk-sensitive safety analysis via 
% state-space augmentation.”
% OUTPUT (one folder for each inner-recursion)
    %   [file] (updated after each recursion step & deleted upon completion) :
    %       /staging/{configurationID}/{scenarioID}/Bellman_checkpoint.mat - 
    %       a file containing results for any completed recursion steps
    %   [file] (after each recursion step) :
    %       /staging/{configurationID}/{scenarioID}/times.txt - 
    %       a file containing the bellman 
    %   [file] (after all recursion steps)
    %       /staging/{configurationID}/{scenarioID}/Bellman_complete.mat : a
    %       file containing results for all recursion steps
% OUTPUT (one for all designs)
    %   [file] (after all recursions complete) 
    %        /staging/coordination_file.mat: a file that contains
    %        coordination information 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[] = Run_All_Designs()

    % CVaR alpha levels of concern
    alphas = [0.99, 0.05, 0.005, 0.0005, 0.00005];

    % this paper explores 1 baseline design and 3 design alternatives
    N_DESIGNS = 4; 

    % Scenario IDs for under approximation method  
    scenarioIDs_UND = { 
        'WRSU0', ... % 0: BASELINE DESIGN
        'WRSU1', ... % 1: AUTOMATED PUMP, MAX PUMP RATE = 10
        'WRSU2', ... % 2: OUTLET TO STORM SEWER, TANK 1
        'WRSU3' };   % 3: INCREASE SURFACE AREA OF TANK 2 BY 20%

    % Scenario IDs for state augmentation method with random cost max( gK(X_t) ) 
    scenarioIDs_AUG = { 
        'WRSA0', ... % 0: BASELINE DESIGN
        'WRSA1', ... % 1: AUTOMATED PUMP, MAX PUMP RATE = 10
        'WRSA2', ... % 2: OUTLET TO STORM SEWER, TANK 1
        'WRSA3' };   % 3: INCREASE SURFACE AREA OF TANK 2 BY 20%

    % verify expected number of designs for both underapproximation
    % and state agumentation methods
    assert(length(scenarioIDs_UND)==N_DESIGNS);
    assert(length(scenarioIDs_AUG)==N_DESIGNS);

    % run underapproximations for soft-max (gamma = 20)
    configID_UND = 20;
    for this_design = 1 : N_DESIGNS
        % The steps in this loop are independent and could be run in
        % parallel. However this recursion is already configured to 
        % run in parallel over the state-space given the default parallel 
        % pool configuration size, so it is not recommended to attempt to
        % run this loop in parallel on the same machine. 
        Run_Bellman_Recursion(scenarioIDs_UND{this_design}, configID_UND);
    end
    
    % run inner-optimizations for exact method
    %  We want to compute value functions and control policies for each 
    %  value of svar in [0, 0.1, ..., 2], where 2 is the 
    %  grid_upper_buffer in ft.
    %   
    %  This is the desired range because: 
    %       J_0^s(x,0) = V^s(x) = \inf_{\pi \in \Pi} E_x^\pi( \max( Y - s,0 ) )
    %       x = [x1, x2], 0 = x3.
    %       Y = max_{t = 0,1,...,N} gK(X_t)
    %       gK(x) = \max( x1 - k1, x2 - k2, 0 ) for all x
    %       x1 \in { 0, 0.1, ..., k1, k1 + 0.1, ..., k1 + grid_upper_buffer }, 
    %       x2 \in { 0, 0.1, ..., k2, k2 + 0.1, ..., k2 + grid_upper_buffer }
    %  Thus, gK(x) \in [0, grid_upper_buffer] for all x.
    %
    %  So, one bellman recursion per config in 10, ..., 30 according to: 
    %   [0,0.1,...,config.grid_upper_buffer]=[0,0.1,...,2] 
    %   configID = 10   --> svar = configId/10 - 1 = 1   - 1 = 0
    %   configID = 11   --> svar = configId/10 - 1 = 1.1 - 1 = 0.1
    %   ...
    %   configID = 30   --> svar = configId/10 - 1 = 3 - 1 = 2 
    start_configID = 10; 
    end_configID = 30;
    for this_design = 1 : N_DESIGNS
        for configID = 10:30
            % The steps in this loop are independent and could be run in
            % parallel. However this recursion is already configured to 
            % run in parallel over the state-space given the default parallel 
            % pool configuration size, so it is not recommended to attempt to
            % run this loop in parallel on the same machine. 
            Run_Bellman_Recursion(scenarioIDs_AUG{this_design}, configID);
        end
    end
    
    % Bellman recursions are now complete, however we need to perform an
    % outer optimization for the exact method to solve
    % V_alpha(x) = min_s  s + 1\alpha * V^s(x)
    %   for all real x in the state space at all alpha levels of concern
    staging_area = get_staging_directory('', ''); 
    outer_optimization_file = strcat([staging_area,'outer_optimization.mat']);
   
    if isfile(outer_optimization_file)
        disp('Skipping outer optimization, file already exists.'); 
    else
        V_alphas = cell(N_DESIGNS,1);
        for this_design = 1 : N_DESIGNS
            [V_alphas{this_design}, real_coordinates] = Run_Outer_Optimization(scenarioIDs_AUG{this_design}, start_configID, end_configID, alphas);
        end
        save(outer_optimization_file); 
    end
end