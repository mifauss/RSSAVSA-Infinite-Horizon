%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: 
%    Fills several fields of scenario struct for stormwater system
% INPUT:
%   scenarioId = the string id of the scenario to use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function scenario = fill_scenario_fields_watersys_baseline(scenarioId) 

    scenario = []; scenario.dim = 2; scenario.id = scenarioId;
    
    scenario.surface_area = [30000, 10000];               % [ft^2] tank surface area

    scenario.pump_elevation = [1, 1];                     % [ft] minimum tank elevation before pumping can occur
    
    scenario.max_pump_rate = 10;                          % [cfs] maximum pumping rate

    scenario.combined_sewer_outlet_quantity = [3, 1];     % [dimensionless] number of oulets discharging to combined sewer
    scenario.combined_sewer_outlet_elevation = [3, 4];    % [ft] minimum elevation before discharge to combined sewer
    scenario.combined_sewer_outlet_radius = [1/4, 3/8];   % [ft] radius of combined sewer outlets

    scenario.storm_sewer_outlet_elevation = 1;            % [ft] minimum elevation in tank 2 before discharge to storm sewer
    scenario.storm_sewer_outlet_radius = 1/3;             % [ft] radius of storm sewer outlet
    
    % For valve, drain by gravity
    scenario.outlet_radius_s1 = 1/3;                      % [ft] pipe radius (bidirectional flow s1 <=> s2)
    scenario.outlet_elevation_s1 = 1;                     % [ft] invert elevation of pipe from s1 bottom (outlet of s1), Z1
    scenario.inlet_elevation_s2 = 2;                      % [ft] invert elevation of pipe from s2 bottom (inlet of s2), Z_in1
    
    % Top of constraint set boundary corresponds to approx. 2 cfs 
    % linearized discharge to the combined sewer.
    scenario.K_min = zeros(2,1);
    scenario.K_max = scenario.combined_sewer_outlet_elevation';
    
    [scenario.ws, scenario.P, scenario.nw, scenario.wunits] = get_runoff_disturbance_profile('right skew');
    
    scenario.cost_function = str2func('max_flood_level');
    
    scenario.allowable_controls = 0: 0.1: 1; % this is reset for pump case
     
end