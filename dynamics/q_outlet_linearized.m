%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Computes outflow through an orifice using orifice equation
% INPUT:
    % x = pond stage vector measured from pond base [ft]
    % u = valve setting vector, a proportion   
    % R = outlet radius [ft]
    % Z = outlet invert elevation [ft]
    % xmax = maximum water level for calibration of linear outflow regulator
% OUTPUT: Outflow vector [ft^3/s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function q = q_outlet_linearized(x, u, R, Z, xmax)

    % build a row vector of repeating xmax 
    % with same length as x
    %xmax = repmat(xmax, 1, length(x));

	q_max = q_outlet_natural(xmax, u, R, Z);     % [ft] maximum discharge 
    head_at_xmax = xmax - Z;                     % [ft] water surface elevation above outlet invert
    
    freeboard = xmax - x;                                       % [ft] distance of water surface from xmax
    freeboard_above_invert = min(freeboard, head_at_xmax);      % [ft] portion of the freeboard above Z
    
    q = q_max - (q_max / head_at_xmax)*freeboard_above_invert;  % [cfs] outflow from linear regulator
    
        % when freeboard == 0, freeboard_above_invert = 0, q = q_max
        % when freeboard <= head_at_xmax, freeboard_above_invert = head_at_xmax, q = 0 

end