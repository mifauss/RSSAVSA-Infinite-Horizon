%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Checks the consistency of grids across multiple configurations 
%          for the same simulation ID. This is useful for the exact method
%          to verify the grids used for the inner optimizations are all the
%          before proceeding with the outer optimization. 
% LIMITATIONS: Currently written for a system with two real dimensions and a
%              an augmented state space. Does not verify the integrity of
%              grids in results files; assumes these results correspond to
%              the corresponding to the values currently specified in
%              get_scenario.m and get_config.m. 
% INPUT:
    % scenarioID = the string id of the scenario to optimize    
    % start_configID = the numeric ID starting the range of configurations to 
    %   check
    % end_configID = the numeric ID ending the range of configurations to
    %   to check
% OUTPUT: 
    %   [verified_ambient] = an ambient struct 
    %      (see calculate_ambient_variables) that should contain a grid
    %      consistent across all configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function verified_ambient = check_grid_consistency(scenarioID, start_configID, end_configID)

global scenario; 
global config; 
global ambient; 

ambient_xcoords = cell(end_configID,1);
ambient_x3s = cell(end_configID,1);
ambient_x1s = cell(end_configID,1);
ambient_x2s = cell(end_configID,1);
ambient_x1n = cell(end_configID,1);
ambient_x2n = cell(end_configID,1);
ambient_x3n = cell(end_configID,1);
ambient_nx = cell(end_configID,1);

scenario = get_scenario(scenarioID);

for configurationID = start_configID : end_configID
    
    if scenario.dim ~= 2 || ~scenario.AUG_STATE
        error('Only written for real dim = 2 and aug state scenario');
    end
    
    config = get_config(configurationID); 
    
    calculate_ambient_variables(); % this requires global config and scenario
    
    ambient_xcoords{configurationID} = ambient.xcoord;
    
    ambient_x1s{configurationID} = ambient.x1s;
    
    ambient_x2s{configurationID} = ambient.x2s;
    
    ambient_x3s{configurationID} = ambient.x3s;
    
    ambient_x1n{configurationID} = ambient.x1n;
    
    ambient_x2n{configurationID} = ambient.x2n;
    
    ambient_x3n{configurationID} = ambient.x3n;
    
    ambient_nx{configurationID} = ambient.nx;
    
    if configurationID > start_configID
        if ~isequal(ambient_x1s{configurationID}, ambient_x1s{configurationID-1})
            error('issue with x1s');
        end
        if ~isequal(ambient_x2s{configurationID}, ambient_x2s{configurationID-1})
            error('issue with x2s');
        end
        if ~isequal(ambient_x3s{configurationID}, ambient_x3s{configurationID-1})
            error('issue with x3s');
        end
        if ~isequal( ambient_xcoords{configurationID}, ambient_xcoords{configurationID-1})
            error('issue with xcoords');
        end
        if ~isequal(ambient_x1n{configurationID}, ambient_x1n{configurationID-1})
            error('issue with x1n');
        end
        if ~isequal(ambient_x2n{configurationID}, ambient_x2n{configurationID-1})
            error('issue with x2n');
        end
        if ~isequal(ambient_x3n{configurationID}, ambient_x3n{configurationID-1})
            error('issue with x3n');
        end
        if ~isequal(ambient_nx{configurationID}, ambient_nx{configurationID-1})
            error('issue with nx');
        end
    end
 
end

verified_ambient = ambient; % return copy that has been verified


