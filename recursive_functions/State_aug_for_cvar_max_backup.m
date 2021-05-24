%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Performs Bellman backup to minimize E_x^\pi( max( Y - s, 0 )), 
% where s = config.svar
% INPUT: 
    % J_k+1 : optimal cost-to-go at time k+1, array
    % globals: 
    %   ambient struct
    %   config struct 
    %   scenario struct
% OUTPUT: 
    % J_k : optimal cost-to-go starting at time k, array
    % mu_k : optimal controller at time k, array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ J_k, mu_k ] = State_aug_for_cvar_max_backup(J_kPLUS1)

    global ambient; global config; global scenario;
    
    amb = ambient; cfg = config; scn = scenario; 
    
    if scenario.dim == 2 && startsWith(scenario.id,'WRSA')
        
        J_kPLUS1_grid = zeros(ambient.x2n, ambient.x1n, ambient.x3n);
        % In J_kPLUS1_grid(:,:,k) each column represents a fixed value of x1
        % and the values of x2 change along the entries of this column (rows)
        % ambient.x3s(k) is the associated value of x3
    
        for k = 1 : ambient.x3n
        % select entries of J_kPLUS1 corresponding to kth value of x3
        
            if ~isequal( ambient.xcoord( k:ambient.x3n:end, 3 ), ambient.x3s(k)*ones(ambient.x2n*ambient.x1n,1) )
                error('issue with x3index'); 
            end
        
            J_kPLUS1_grid(:,:,k) = reshape( J_kPLUS1(k:ambient.x3n:end), [ambient.x2n, ambient.x1n] );
            
        end
        
        % F([x2, x1, x3]) finds the linear interpolated value of J_kPLUS1 at state x1, x2, x3
        % ambients are computed in calculate_ambient_variables.
        F = griddedInterpolant(ambient.x2g, ambient.x1g, ambient.x3g, J_kPLUS1_grid, 'linear'); 
        
    else
        error('only written for scenario.dim equal to 2 and scenario starting with WRSA');
    end
    
    stage_cost = zeros(ambient.nx,1);
    for j = 1:ambient.nx
        x1 = ambient.xcoord(j,1);
        x2 = ambient.xcoord(j,2);
        %x3 = ambient.xcoord(j,3); % extra state
        stage_cost(j) = scenario.cost_function([x1 x2], scenario);
        %cost_function is max(x1-k_max_1,x2-k_max_2,0) for water system
    end
    
    J_k = J_kPLUS1; 
    mu_k = J_kPLUS1;
    
    us = scenario.allowable_controls;
            
    parfor z = 1 : amb.nx
        
        J_k_all_us = zeros(length(us),1);
        
        for m = 1 : length(us)
            
            u = us(m); 
            inside_expected_value_k_wk = zeros(scn.nw,1); 
            
            for i = 1 : scn.nw
        
                % get next state realization
                x_kPLUS1 = scn.dynamics(amb.xcoord(z,1:2), u, scn.ws(:,i), cfg, scn, amb);     %third col of amb.xcoord is extra state            
                
                x_kPLUS1 = snap_to_boundary( x_kPLUS1, amb ); % computed using only x1 and x2 (no info about the extra state x3)
                
                extra_kPLUS1 = max( stage_cost(z), amb.xcoord(z,3) ); % dynamics of extra state, stage_cost = max(x1-k_max_1,x2-k_max_2,0)
                
                % F([x2, x1, x3]) finds the linear interpolated value of J_kPLUS1 at state x1, x2, x3; x3 is extra state
                J_kPLUS1 = F([fliplr(x_kPLUS1), extra_kPLUS1]); %comes from griddedInterpolant
                
                inside_expected_value_k_wk(i) = J_kPLUS1;  
                
            end
            
            our_expected_value = sum(inside_expected_value_k_wk .* scn.P); 
           
            J_k_all_us(m) = our_expected_value;
            
        end
        
        [optVal, optIdx] = min(J_k_all_us); 
        J_k(z) = optVal; 
        mu_k(z) = us(optIdx); 
        
    end
end
