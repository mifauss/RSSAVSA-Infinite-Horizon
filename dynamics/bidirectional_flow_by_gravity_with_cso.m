%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Describes the instantaneous rate of water level change 
%   in a two-tank system connected by a bidirectional pump to mitigate 
%   combined sewer overflows. 
% INPUT:
    % xk(i) : water elevation at time k in tank i [ft]
    % uk : pump setting at time k [no units]
    % wk : average surface runoff rate on [k, k+1) [ft^3/s]
% OUTPUT:
    % xk_plus1(i) : water elevation at time k+1 in tank i [ft]
% ASSUMPTIONS: 
    % System is outfitted with (passive) technology to linearize outflow with elevation
    % u \in [-1, 1] provides linear control of pump flow rate
        % u = -1 : all power is devoted to putting water into tank 2
        % u = +1 : all power is devoted to putting water into tank 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function xk_plus1 = bidirectional_flow_by_gravity_with_cso( xk, uk, wk, cfg, scn, amb )

% xk is a row vector where
% xk(1) is x1 at current time step
% xk(2) is x2 at current time step

CSZ = scn.combined_sewer_outlet_elevation; % [ft] minimum elevation before discharge to combined sewer 
CSR = scn.combined_sewer_outlet_radius;    % [ft] combined sewer outlet radius
CSQ = scn.combined_sewer_outlet_quantity;  % [dimensionless] combined sewer outlet quantity

SSZ = scn.storm_sewer_outlet_elevation;    % [ft] minimum elevation before discharge to storm sewer
SSR = scn.storm_sewer_outlet_radius;       % [ft] storm sewer outlet radius

% q_storm: discharge rate to storm sewer (from tank 2)
q_storm_sewer = q_outlet_linearized(xk(2), 1, SSR, SSZ, amb.xmax(2)); 

% q_to_combined_sewer: discharge to combined sewer from each tank
q_to_combined_sewer_1 = q_outlet_linearized(xk(1), 1, CSR(1), CSZ(1), amb.xmax(1)) .* CSQ(1); 
q_to_combined_sewer_2 = q_outlet_linearized(xk(2), 1, CSR(2), CSZ(2), amb.xmax(2)) .* CSQ(2);

R1 = scn.outlet_radius_s1;        % [ft] pipe radius (bidirectional flow s1 <=> s2)
Z1 = scn.outlet_elevation_s1;     % [ft] invert elevation of pipe from s1 bottom (outlet of s1)
Z_in1 = scn.inlet_elevation_s2;   % [ft] invert elevation of pipe from s2 bottom (inlet of s2)

% head in x1
h1 = max(xk(1)-Z1,0); 
% head in x2
h2 = max(xk(2)-Z_in1,0); 

q_valve = q_pipe(h1, h2, uk, R1);

% f is a column vector where
% f(1) is x1_dot
% f(2) is x2_dot
f = ones(scn.dim,1);

if size(wk(:,1),1) == 2
   w1 = wk(1); 
   w2 = wk(2);   
else
   w1 = wk;
   w2 = wk; 
end

f(1) = ( w1 - q_to_combined_sewer_1 - q_valve ) / scn.surface_area(1);                  % time-derivative of x1 [ft/s]
f(2) = ( w2 - q_to_combined_sewer_2 + q_valve - q_storm_sewer ) / scn.surface_area(2);  % time-derivative of x2 [ft/s]

xk_plus1 = xk + f' * cfg.dt; 