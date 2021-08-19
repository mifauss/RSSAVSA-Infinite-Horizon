%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: 
%   Create a structure containing scenario-specifc details
% INPUT:
%   scenarioID = the string id of the scenario to use
% OUTPUT:
%   scenario = a structure containing scenario-specific details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\

function scenario = get_scenario(scenarioID)

    % initialize scenario, two tank stormwater example
    scenario = fill_scenario_fields_watersys_baseline(scenarioID);

    switch scenarioID
                  
        % augmented state with random cost sup( gK(X_t) ), BASELINE DESIGN,
        case 'WRSA0'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 200;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_majorrs('major right skew');
            scenario.ws = scenario.ws/2; % so mean is about 2 cfs
        
        case 'WRSA1'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 250;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_majorrs('major right skew');
            scenario.ws = scenario.ws/2; % so mean is about 2 cfs
            
        case 'WRSA2'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 280;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_majorrs('major right skew');
            scenario.ws = scenario.ws/2; % so mean is about 2 cfs
            
        case 'WRSA3'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 300;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_majorrs('major right skew');
            scenario.ws = scenario.ws/2; % so mean is about 2 cfs
            
       case 'WRSA4'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 400;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_majorrs('major right skew');
            scenario.ws = scenario.ws/2; % so mean is about 2 cfs
            
        otherwise
            error('no matching scenario found'); 
            
    end
    
    % setup common properties
    scenario.title = ['Scenario ', scenarioID];
    
    %scenario.risk_functional = 'RNE';
    %scenario.bellman_backup_method = str2func('Expectation_with_expmgK_stage_cost_backup');
    
    if scenario.AUG_STATE
        scenario.risk_functional = 'CVAR_risk_func';
        scenario.bellman_backup_method = str2func('State_aug_for_cvar_max_backup');
    end

    scenario.cost_function_aggregation = str2func('max'); 

end



