%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: 
%   Create a structure containing scenario-agnostic simulation information
% INPUT:
%   configId = the numeric id of the configuration to use
% OUTPUT:
%   config = a structure containing scenario-agnostic simulation information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function config = get_config(configId)

    config = []; 
    config.id = mat2str(configId);

    % configure for water system
    config.grid_spacing = 1/10;         % [ft] state discretization interval (default = 1/10)
    config.dt = 300;                   % Duration of [k, k+1) [sec], 5min = 300sec, 3min = 180sec
                                       % Design storm length [sec], 1h = 1h*3600sec/h, set in get_scenario
    config.grid_upper_buffer = 2;      % [ft]
    config.grid_lower_buffer = 0;      % [ft]
    config.m = configId;               % this is gamma in softmax
    config.svar = configId/10 - 1;     % want to allow for [0,0.1,...,config.grid_upper_buffer]
    
    %configurationID = 10 : 1 : 30
    %allows for svar to be [0,0.1,...,config.grid_upper_buffer]=[0,0.1,...,2]
    %configID = 10   --> svar = configId/10 - 1 = 1   - 1 = 0
    %configID = 11   --> svar = configId/10 - 1 = 1.1 - 1 = 0.1
    %...
    %configID = 30   --> svar = configId/10 - 1 = 3 - 1 = 2

end
