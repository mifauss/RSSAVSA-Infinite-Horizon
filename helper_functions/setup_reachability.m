%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Initializes variables prior to running Bellman recursion
% INPUTs:
%  scenarioID: the string id of the scenario to use
%  configurationID: the numeric id of the configuration to use
%  globals: 
%   ambient struct 
%   scenario struct 
%   config struct 
% OUTPUTS: 
%   Js: a cell array for storing the values associated with optimal control policies
%   mus: a cell array for storing optimal control policies
%   N: the number of discrete time points in the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[Js, mus, N] = setup_reachability(scenarioID, configurationID)

    global ambient; 
    global scenario;
    global config;
    
    % load scenario and configuration
    scenario = get_scenario(scenarioID); 
    config = get_config(configurationID); 

    display(strcat('Running scenario: (', scenarioID, ') under simulator configuration (',num2str(configurationID) ,').'))

    %N = config.T/config.dt;         % Time horizon: {0, 1, 2, ..., N} = {0, 5min, 10min, ..., 240min} = {0, 300sec, 600sec, ..., 14400sec}

    N = scenario.exptNiter;
    
    Js = cell( N+1, 1 );            % Contains optimal value functions to be solved via dynamic programming
                                    % Js{1} is J0, Js{2} is J1, ..., Js{N+1} is JN

    mus{N} = cell( N, 1 );          % Optimal policy, mus{N} is \mu_N-1, ..., mus{1} is \mu_0
                                    % mu_k(x,y) provides optimal control action at time k, state x, confidence level y
                                    
    calculate_ambient_variables(); 
    
    %Recall: 
    %ambient.nx = ambient.x1n * ambient.x2n * ambient.x3n;   
    %xcoord = zeros(ambient.nx,3); 
    %xcoord(z,1) = ambient.x1s(i); 
    %xcoord(z,2) = ambient.x2s(j);
    %xcoord(z,3) = ambient.x3s(k);
    %ambient.xcoord = xcoord;
    
    % get_config.m: 
    % config.svar = configId - 1;        %want to allow for [0,0.1,...,config.grid_upper_buffer]
    
    ambient.c = initialize_stage_cost_matrix(scenarioID);
    
    Js{N+1} = ambient.c;  
    
end