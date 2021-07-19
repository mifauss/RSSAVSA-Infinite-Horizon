%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run experiment for a single value of alpha and s
% Adapted from 'Run_All_Designs.m', see the latter for more details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [V_alpha] = Run_Infinite_Horizon_Design_MPC(scenarioID, alpha, mys_values)

configIDvec = zeros(1,length(mys_values));

for i = 1 : length(mys_values)
    configIDvec(i) = (mys_values(i)+1)*10;
end
    
configIDstart = (mys_values(1)+1)*10;

configIDend = (mys_values(end)+1)*10;
        
for s_index = 1 : length(mys_values)
    
    display(['current s_index = ', num2str(s_index)]);
            
    s = mys_values(s_index);
        
    configID = (s+1)*10; % Configurations, must be integers

    % run inner-optimizations for exact method
    Run_Bellman_Recursion(scenarioID, configID);
            
end

% Bellman recursions are now complete, however we need to perform an outer optimization
staging_area = get_staging_directory('', ''); 
outer_optimization_file = strcat([staging_area,'outer_optimization_', scenarioID, '.mat']); %this saves data for scenario scenarioID

if isfile(outer_optimization_file)
    disp('Skipping outer optimization, file already exists.'); 
    load(outer_optimization_file);
else
     [V_alpha, real_coordinates] = Run_Outer_Optimization_MPC(scenarioID, configIDstart, configIDend, alpha, configIDvec);
     save(outer_optimization_file);
end
    
end
