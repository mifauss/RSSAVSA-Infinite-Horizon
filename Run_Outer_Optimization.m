%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Runs the outer optimization over multiple configurations for the
%          same exact method scenario at the specified alpha levels. 
% INPUT:
    % scenarioID = the string id of the scenario to optimize    
    % start_configID = the numeric ID starting the range of configurations to 
    %   optimize over
    % end_configID = the numeric ID ending the range of configurations to
    %   to optimize over
    % alphas = an array of alphas values that correspond to the entries in
    %          the output cell array V_alphas, each cell contains 
    %          the solution V_alpha(x) = min_s  s + 1\alpha * V^s(x)
    %          for all real x in the state space
    %          
% OUTPUT: 
    %   [V_alphas] = a cell array with where each cell contains 
    %          the solution V_alpha(x) = min_s  s + 1\alpha * V^s(x)
    %          for all real x in the state space
    %   [real_coordinates] = a vector containing the real coordinates 
    %          corresponding to the real x in the state space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[V_alphas, real_coordinates] = Run_Outer_Optimization(scenarioID, start_configID, end_configID, alphas)

    % Check grid consistency across all configurations.
    % this will return error if ambient.xcoord, ambient.x1s, ambient.x2s, 
    %   ambient.x3s, etc. are not consistent for 
    %   all configurationID = start_configID : end_configID
    % otherwise, returns ambient struct that contains verified grid
    verifiedAmbient = check_grid_consistency(scenarioID, start_configID, end_configID);
    
    % Extract real states from the augmented grid.
    % verifiedAmbient.xcoord should be a 3-D vector of length x1n*x2n*x3n 
    % with one entry per coordinate in the augmented state space
    % It is constructed such that the first value in the array corresponds 
    %  to (x1 = 0, x2 = 0, x3 = 0) and
    %  the next x3n-1 entries correspond to the same real state 
    %  (x1 = 0, x2 = 0) for increasing values of x3 up to its maximum
    % value. The x3n+1 entry is 
    %   (x1 = 0, x2 = config.grid_spacing, x3 = 0)
    % and the pattern continues:
    %   s.t. the (x3n*2)+1 entry is
    %   (x1 = 0, x2 = 2*config.grid_spacing, x3 = 0). 
    % and so on.

    % There are at least two ways to do this extraction. Let's try both
    % as a sanity check on our indexing strategy. 

    % Method 1: Select columns 1 & 2 for every x3n-th row, ... 
    real_coordinates_method1 = verifiedAmbient.xcoord(1:verifiedAmbient.x3n:end, 1:2);

    % Method 2: Explicitly real state grid based on expected algorithm
    z = 0; 
    real_coordinates_method2 = zeros(verifiedAmbient.x1n*verifiedAmbient.x2n,2); 
    for i = 1:verifiedAmbient.x1n
        for j = 1:verifiedAmbient.x2n
            z = z + 1; 
            real_coordinates_method2(z,1) = verifiedAmbient.x1s(i); 
            real_coordinates_method2(z,2) = verifiedAmbient.x2s(j); 
        end
    end
    
    % Perform sanity check on the real coordiantes
    if ~isequal(real_coordinates_method1, real_coordinates_method2)
        error('xcoord for real states is not consistent.');
    end
    real_coordinates = real_coordinates_method1; 

    % Verify files exist and extract all Vs for outer optimization
    for configurationID = start_configID : end_configID
        staging_area = get_staging_directory(scenarioID, configurationID);
    
        complete_file = strcat([staging_area,'Bellman_complete.mat']);
        
        if isfile(complete_file)
            load(complete_file); 
        else
            error(['No results available for this scenario (',scenarioID, ') and configuration (', mat2str(configurationID),'). Please Run_Bellman_Recursion first or Run_All_Designs if attempting to recreate results for the original paper.']);
        end
        
        if scenario.AUG_STATE ~= 1
           error('Outer optimization only valid for scenarios with augmented state.');  
        end
        
        if scenario.dim ~= 2
           error('Only developed for scenarios with state-space dimensionality of 2.'); 
        end
        
        % This is J^s_0 for the case where where s = config.svar.
        % Js{1} is the value function for time 0; we need to extract 
        % Jk{1}(x1,x2,x3) associated with x3 = 0, where x3
        % is the augmented state. 
        J0_s = Js{1};
        
        % J0_s is a 1-D vector of length x1n*x2n*x3n with one entry per coordinate in the
        % augmented-state space. It is constructed such that the first
        % value in the array corresponds to (x1 = 0, x2 = 0, x3 = 0) and
        % the next x3n-1 entries correspond to the same real state 
        %(x1 = 0, x2 = 0) for increasing values of x3 up to its maximum
        % value. The x3n+1 entry is 
        %   (x1 = 0, x2 = config.grid_spacing, x3 = 0)
        % and the pattern continues:
        %   s.t. the (x3n*2)+1 entry is
        %   (x1 = 0, x2 = 2*config.grid_spacing, x3 = 0). 
        % and so on.
        
        % There are at least two ways to do this extraction. Let's try both
        % as a sanity check on our indexing strategy. 
     
        %  Method 1: Extract every x3n-th value starting from 1. 
        Vs_method1 = J0_s(1:verifiedAmbient.x3n:end); 
        
        %  Method 2: Explicitly check coordinate. 
        Vs_method2 = zeros(verifiedAmbient.x1n * verifiedAmbient.x2n,1);
        z = 1; j = 1;
        while z <= verifiedAmbient.nx
            if verifiedAmbient.xcoord(z,3) == 0 %x3 from calculate_ambient_variables
                Vs_method2(j) = J0_s(z);
                j = j + 1;
            end
            z = z + 1;
        end

        % Perform sanity check that Vs for both approaches are consistent
        if ~isequal(Vs_method1, Vs_method2)
            error('Vs not consistent.');
        end

        % this is: J_0^s(x,0) = V^s(x) = \inf_{\pi \in \Pi} E_x^\pi( \max( Y - s,0 ) )
        V_s{configurationID} = Vs_method1;
    end
    
    % Finally, perform outer optimization over Vs for each alpha. 
    %   i.e., Compute V_alpha(x) = min_s  s + 1\alpha * V^s(x)
    %   V_s{configurationID}(z) is J_0^s(x,0) = V^s(x) = \inf_{\pi \in \Pi} E_x^\pi( \max( Y - s,0 ) ),
    %   where s = config.svar, config = get_config(configurationID) and
    %   x = [x1 x2] = xcoord_x1x2_only(z,:)
    %
    % RS safe set using alpha(i) is \{ x : W_alphas{i} \leq r \}
    % W_alphas{i} = V_alphas{i} since lower bound of gK is 0.
    
    V_alphas = cell(length(alphas),1);
    
    for i = 1 : length(alphas)
    
        % create a container for the solution V_alpha(x) = min_s  s + 1\alpha * V^s(x)
        % for all x in the real state space
        V_for_alpha = zeros(verifiedAmbient.x1n * verifiedAmbient.x2n, 1);

        % for each state in the real state space
        for z = 1 : verifiedAmbient.x1n * verifiedAmbient.x2n

            vMin = realmax; %largest possible number that matlab can handle

            % find V_alpha(x) = min_s  s + 1\alpha * V^s(x)
            % for the candidate s values
            for configurationID = start_configID : end_configID
                config = get_config(configurationID);
                vMin = min( (config.svar + 1/alphas(i)*V_s{configurationID}(z)), vMin );
            end
            V_for_alpha(z) = vMin;

        end
        V_alphas{i} = V_for_alpha;

    end
end



    
    