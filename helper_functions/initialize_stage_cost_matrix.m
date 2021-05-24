%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Initializes the stage cost for each element in the state-space
% INPUT: 
%	globals: 
%		ambient struct 
%		config struct
%		scenario struct
% OUTPUT: Stage cost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function c = initialize_stage_cost_matrix(scenarioID) 

global scenario 
global config
global ambient

%recall that ambient is computed in calculate_ambient_variables.m
%config.svar is computed in get_config.m
if startsWith(scenarioID,'WRSA') % augmented state
    c = zeros(ambient.nx,1);
    for j = 1:ambient.nx
        x1 = ambient.xcoord(j,1);
        x2 = ambient.xcoord(j,2);
        x3 = ambient.xcoord(j,3); % extra state
        gx = scenario.cost_function([x1 x2], scenario);
        c(j) = max( (max( gx , x3 ) - config.svar) , 0 );
    end
    
else

    % assumes cost is only based on x1,x2; there is no augmented state x3
    gx = scenario.cost_function(ambient.xcoord, scenario); 

    %RNE - risk neutral, the stage cost is: exp( m * g(Xt) ), which we sum over time.
    c = exp( config.m * gx);

end
