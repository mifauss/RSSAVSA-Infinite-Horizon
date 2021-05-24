%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Plots figure 5 from Chapman, et al., 
% “Risk-sensitive safety analysis via state-space augmentation.”
% OUTPUTS:
%   [file](s)
%       /staging/figures/figure5_1.png
%       /staging/figures/figure5_1.fig 
%       /staging/figures/figure5_2.png
%       /staging/figures/figure5_2.fig 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Plot_Figure_5()

    staging_area = get_staging_directory('WRSU0', 20);
    bellman_file = strcat([staging_area,'Bellman_complete.mat']);
    staging_area = get_staging_directory('', '');
    outer_optimization_file = strcat([staging_area,'outer_optimization.mat']);
    staging_area = get_staging_directory('', 'figures');

    % if file is available, load it, otherwise prompt to Run_Outer_Optimization.
    if isfile(outer_optimization_file)
        load(outer_optimization_file, 'V_alphas', 'alphas', 'real_coordinates');
    else
        error(strcat('No outer optimizations available. Please Run_Outer_Optimization first.'));   
    end

    % if file is available, load it, otherwise prompt to Run_Bellman_Recursion.
    if isfile(bellman_file)
        load(bellman_file, '-regexp', '^(?!staging_area$).') % This provides Js; does not overwrite existing staging directory, ensuring pc/linux filepath compatibility
    else
        error(strcat('No results available for scenario (',scenarioID, ') and configuration (', mat2str(configurationID),'). Please Run_Bellman_Recursion first.'));  
    end

    % load globals for underapproximation method
    % (i.e. for WRSU, configID = 20), (scenarioID, configurationID)
    global scenario;
    global config;
    global ambient;

    if ~isequal(ambient.xcoord, real_coordinates)
        error('xcoord inconsistent between underapprox and exact methods');
    end

    nl = length(alphas);

    if scenario.dim ~= 2
        error('only written for dim == 2');  
    else
        
        rs_to_show = 0.1 : 0.1 : 1.9;

        BASELINE = 1; 
        REPLACE_VALVE_WITH_PUMP = 2; 

        for this_design = [BASELINE, REPLACE_VALVE_WITH_PUMP]

            figure

            V_alphas_this_design = V_alphas{this_design}; 

            for l_index = 1:nl

                W0_star_grid = reshape(V_alphas_this_design{l_index}, [ambient.x2n, ambient.x1n]);

                % begin plotting section
                set(gcf,'color','w');
                subplot(1, nl, l_index);

                [CW, hW] = contour(ambient.x2g, ambient.x1g, W0_star_grid, rs_to_show);
                clabel(CW,hW);
                hW.LineWidth = 1.2;
                hW.LineColor = 'blue';
                hW.LineStyle = '-'; % we haven't used (magenta dotted, blue solid) combination yet
                hW.ShowText = 'off';

                title(['$\alpha$ = ', num2str(alphas(l_index))], 'Interpreter','Latex', 'FontSize', 12);

                if l_index == nl
                    legend({'State-aug'},'Interpreter','Latex','FontSize', 12, 'Location','northeast');
                end
                xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
                ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
                grid on;
                hold off;
            end

            if (this_design == BASELINE)
                sgtitle('Figure 5: a) Baseline'); 
            else
                sgtitle('Figure 5: b) Replace valve with pump'); 
            end

            path_to_png = strcat(staging_area,'figure5_',mat2str(this_design),'.png');
            path_to_fig = strcat(staging_area,'figure5_',mat2str(this_design),'.fig');
            saveas(gcf,path_to_fig);

            f = gcf;
            f.PaperUnits = 'inches';
            f.PaperPosition = [0 0 18 3.2];
            print(path_to_png,'-dpng','-r0');

        end
    
    end
        
end

