%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Plots figure 4 from Chapman, et al., 
% “Risk-sensitive safety analysis via state-space augmentation.”
% OUTPUTS:
%   [file](s)
%       /staging/figures/figure4_1.png
%       /staging/figures/figure4_1.fig 
%       /staging/figures/figure4_2.png
%       /staging/figures/figure4_2.fig 
%       /staging/figures/figure4_3.png
%       /staging/figures/figure4_3.fig 
%       /staging/figures/figure4_4.png
%       /staging/figures/figure4_4.fig 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Plot_Figure_4()

    % this paper explores 1 baseline design and 3 design alternatives
    N_DESIGNS = 4; 

    % Scenario IDs for under approximation method  
    scenarioIDs_UND = { 
        'WRSU0', ... % 0: BASELINE DESIGN
        'WRSU1', ... % 1: AUTOMATED PUMP, MAX PUMP RATE = 10
        'WRSU2', ... % 2: OUTLET TO STORM SEWER, TANK 1
        'WRSU3' };   % 3: INCREASE SURFACE AREA OF TANK 2 BY 20%

    % Scenario IDs for state augmentation method with random cost max( gK(X_t) ) 
    scenarioIDs_AUG = { 
        'WRSA0', ... % 0: BASELINE DESIGN
        'WRSA1', ... % 1: AUTOMATED PUMP, MAX PUMP RATE = 10
        'WRSA2', ... % 2: OUTLET TO STORM SEWER, TANK 1
        'WRSA3' };   % 3: INCREASE SURFACE AREA OF TANK 2 BY 20%

    % underapproximation uses configuration 20
    configID_UND = 20; 

    staging_area = get_staging_directory('', '');
    outer_optimization_file = strcat([staging_area,'outer_optimization.mat']);
    staging_area = get_staging_directory('', 'figures');
    
    % if file is available, load it, otherwise prompt to Run_Outer_Optimization.
    if isfile(outer_optimization_file)
        load(outer_optimization_file, 'V_alphas', 'alphas', 'real_coordinates');
    else
        error(strcat('No outer optimizations available. Please Run_Outer_Optimization first.'));   
    end

    % load globals for underapproximation method
    % (i.e. for WRSU, configID = 20), (scenarioID, configurationID)
    global scenario;
    global config;
    global ambient;
    
    % scale results of underapproximation method to appropriate levels for
    % input vector of alphas
    for des = 1 : N_DESIGNS
        J0_cost_sum_scaled_by_y_with_log_etc_CELL{des} = get_cost_sum_scaled_by_y_with_log_etc(scenarioIDs_UND{des}, configID_UND, alphas);
    end

    if ~isequal(ambient.xcoord, real_coordinates)
        error('xcoord inconsistent between underapprox and exact methods');
    end

    nl = length(alphas);

    if scenario.dim ~= 2
        error('only written for dim == 2');  
    else
        
        rs_to_show = [0.2, 1, 1.8];

        % same as scenarios above, but with 1-based indexing
        BASELINE = 1; 
        REPLACE_VALVE_WITH_PUMP = 2; 
        ADDITIONAL_OUTLET_TO_STORM_SEWER_TANK_1 = 3; 
        INCREASE_SURFACE_AREA_OF_TANK_2 = 4; 

        for this_design = [BASELINE, REPLACE_VALVE_WITH_PUMP, ADDITIONAL_OUTLET_TO_STORM_SEWER_TANK_1, INCREASE_SURFACE_AREA_OF_TANK_2]

            figure

            V_alphas_this_design = V_alphas{this_design}; 

            J0_cost_sum_scaled_by_y_with_log_etc = J0_cost_sum_scaled_by_y_with_log_etc_CELL(this_design);
            
            for l_index = 1:nl
                
                W0_star_grid = reshape(V_alphas_this_design{l_index}, [ambient.x2n, ambient.x1n]);

                % begin plotting section
                set(gcf,'color','w');
                subplot(1, nl, l_index);

                M = cell2mat(J0_cost_sum_scaled_by_y_with_log_etc);
                [C, h] = contour(ambient.x2g, ambient.x1g, squeeze(M(l_index,:,:)), rs_to_show);
                clabel(C,h);
                h.LineWidth = 1.8;
                h.LineColor = 'magenta';
                h.LineStyle = ':';
                hold on;

                [CW, hW] = contour(ambient.x2g, ambient.x1g, W0_star_grid, rs_to_show);
                clabel(CW,hW);
                hW.LineWidth = 1.2;
                hW.LineColor = 'blue';
                hW.LineStyle = '-'; % we haven't used (magenta dotted, blue solid) combination yet

                title(['$\alpha$ = ', num2str(alphas(l_index))], 'Interpreter','Latex', 'FontSize', 12);

                if l_index == nl
                    legend({'Under-approx', 'State-aug'},'Interpreter','Latex','FontSize', 12, 'Location','northeast');
                end
                xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
                ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
                grid on;
                hold off;
            end

            if (this_design == BASELINE)
                sgtitle('Figure 4: a) Baseline'); 
            elseif (this_design == REPLACE_VALVE_WITH_PUMP)
                sgtitle('Figure 4: b) Replace valve with pump'); 
            elseif (this_design == ADDITIONAL_OUTLET_TO_STORM_SEWER_TANK_1)
                sgtitle('Figure 4: c) Add outlet to storm sewer, tank 1'); 
            elseif (this_design == INCREASE_SURFACE_AREA_OF_TANK_2)
                sgtitle('Figure 4: d) Increase surface area of tank 2 by 20%'); 
            else
                error('plotting not configured for this design');
            end

            path_to_png = strcat(staging_area,'figure4_',mat2str(this_design),'.png');
            path_to_fig = strcat(staging_area,'figure4_',mat2str(this_design),'.fig');
            saveas(gcf,path_to_fig);

            f = gcf;
            f.PaperUnits = 'inches';
            f.PaperPosition = [0 0 18 3.2];
            print(path_to_png,'-dpng','-r0');

        end
    
    end
        
end

