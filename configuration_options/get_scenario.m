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
            scenario.allowable_controls = 0: 0.3: 1;
        
        % augmented state with random cost sup( gK(X_t) ), BASELINE DESIGN,
        % N = 60   
        case 'WRSA1'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 60; 
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            scenario.allowable_controls = 0: 0.3: 1;
            
        case 'WRSA2'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 90;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            scenario.allowable_controls = 0: 0.3: 1;
            
        case 'WRSA3'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 200;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            scenario.allowable_controls = 0: 0.3: 1;
            
       case 'WRSA4'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 1;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            scenario.allowable_controls = 0: 0.3: 1;
        
       case 'WRSA5'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 250;
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            scenario.allowable_controls = 0: 0.3: 1;
            
       case 'WRSA6'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 300; 
            scenario.design = 'Baseline';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            scenario.allowable_controls = 0: 0.3: 1;
       
       case 'WRSA7'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('cso_pump_sys'); 
            scenario.exptNiter = 250;   
            scenario.allowable_controls = -1: 0.3: 1;
            scenario.design = 'Pump';
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            
       case 'WRSA8'          
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 250;
            scenario.design = 'Inc. Tank 2 SA';
            scenario.surface_area(end) = 12000;
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            scenario.allowable_controls = 0: 0.3: 1;
            
        case 'WRSA9'
            scenario.AUG_STATE = 1;
            scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso'); 
            scenario.exptNiter = 200;
            [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile_almostdet();
            scenario.ws = scenario.ws*1.3;
            scenario.design = 'Baseline';
            scenario.allowable_controls = 0: 0.3: 1;
            
        % augmented state with random cost max( gK(X_t) ), PUMP
        % pump (max pump rate = 20) with appropriate range of controls 
        % case 'WRSA1'
        %    scenario.AUG_STATE = 1;
        %    scenario.dynamics = str2func('cso_pump_sys');
        %    scenario.allowable_controls = -1: 0.2: 1;
        
        % augmented state with random cost max( gK(X_t) ), OUTLET TO STORM SEWER, TANK 1
        % case 'WRSA2'   
          %  scenario.AUG_STATE = 1;
          %  scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso_tank1drain');
        
        % augmented state with random cost max( gK(X_t) ), INCREASE SURFACE AREA OF TANK 2 BY 20%
        %case 'WRSA3'
            %scenario.AUG_STATE = 1;
            %scenario.dynamics = str2func('bidirectional_flow_by_gravity_with_cso');
            %scenario.surface_area(end) = 12000; %orignally was 10,000
            
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



