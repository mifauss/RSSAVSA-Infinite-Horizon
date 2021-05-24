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
        
        % risk-neutral with random cost sum_{t=0}^T e^(m*gK(X_t)), BASELINE
        case 'WRSU0'       
            scenario.AUG_STATE = 0;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso');
                  
        % augmented state with random cost max( gK(X_t) ), BASELINE
        case 'WRSA0'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso');     
        
        % risk-neutral with random cost sum_{t=0}^T e^(m*gK(X_t)), PUMP
        % pump (max pump rate = 20) with appropriate range of controls  
        case 'WRSU1'  
            scenario.AUG_STATE = 0;
            scenario.dynamics = str2func('cso_pump_sys');
            scenario.allowable_controls = -1: 0.2: 1;
            
        % augmented state with random cost max( gK(X_t) ), PUMP
        % pump (max pump rate = 20) with appropriate range of controls 
        case 'WRSA1'
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('cso_pump_sys');
            scenario.allowable_controls = -1: 0.2: 1;
            
        % risk-neutral with random cost sum_{t=0}^T e^(m*gK(X_t)), OUTLET TO STORM SEWER, TANK 1
        case 'WRSU2'   
            scenario.AUG_STATE = 0;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso_tank1drain');
        
        % augmented state with random cost max( gK(X_t) ), OUTLET TO STORM SEWER, TANK 1
        case 'WRSA2'   
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso_tank1drain');
        
        % risk-neutral with random cost sum_{t=0}^T e^(m*gK(X_t)), INCREASE SURFACE AREA OF TANK 2 BY 20%
        case 'WRSU3'
            scenario.AUG_STATE = 0;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso');
            scenario.surface_area(end) = 12000; %orignally was 10,000
        
        % augmented state with random cost max( gK(X_t) ), INCREASE SURFACE AREA OF TANK 2 BY 20%
        case 'WRSA3'
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso');
            scenario.surface_area(end) = 12000; %orignally was 10,000
            
        otherwise
            error('no matching scenario found'); 
            
    end
    
    % setup common properties
    scenario.title = ['Scenario ', scenarioID];
    
    scenario.risk_functional = 'RNE';
    scenario.bellman_backup_method = str2func('Expectation_with_expmgK_stage_cost_backup');
    
    if scenario.AUG_STATE
        scenario.risk_functional = 'CVAR_risk_func';
        scenario.bellman_backup_method = str2func('State_aug_for_cvar_max_backup');
    end

    scenario.cost_function_aggregation = str2func('max'); 

end



