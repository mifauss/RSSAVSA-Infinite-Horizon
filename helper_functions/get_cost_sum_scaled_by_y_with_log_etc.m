% performs scaling of value-function for underapproximation method
function[J0_cost_sum_scaled_by_y_with_log_etc] = get_cost_sum_scaled_by_y_with_log_etc(scenarioID, configurationID, alphas)
    
    staging_area = get_staging_directory(scenarioID, configurationID);
    bellman_file = strcat([staging_area,'Bellman_complete.mat']);

    % if file is available, load it, otherwise prompt to Run_Bellman_Recursion.
    if isfile(bellman_file)
        load(bellman_file);
    else
        error(strcat('No results available for this scenario (',scenarioID, ') and configuration (', mat2str(configurationID),'). Please Run_Bellman_Recursion first.'));  
    end

    global scenario;
    global config;
    global ambient;

    J0_cost_sum_scaled_by_y_with_log_etc = zeros(length(alphas), ambient.x2n, ambient.x1n);
    
    J0_Bellman = Js{1}; % comes from running bellman recursion for underapproximation case
    J0_Bellman_grid = reshape(J0_Bellman, [ambient.x2n, ambient.x1n]);
    
    for l_index = 1 : length(alphas)
        y = alphas(l_index);
        J0_cost_sum_scaled_by_y_with_log_etc(l_index,:,:) = log( J0_Bellman_grid / y ) / config.m;
    end

end
