%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Helper function that compares designs. 
% INPUT:
%   underapproxScenarioID = the string id of the underapproximation scenario
%   underapproxConfigurationID = the numeric id of the configuration to use
%   value_function_CELL = a cell array indexed by the design, with each
%   element containing a value function
%       - a) for under-approx method, value_function_design_i{l_index} or
%       - b) for augmented state method, value_function_design_i(l_index,:,:)
%   alphas = a vector of CVaR alpha values corresponding ot the entries
%        of value_function_design_i inside value_function_CELL
%   my_LineStyles = line styles
%   my_LineColors = line colors
%   rs_to_show = contours to show in plot
%   myYLIM = y limits
%   legend_struct = a struct containing legend information
%   base_figure_filename = an empty string if no plots should be saved, a base
%       filename (e.g., 'figure4') with no extension otherwise
%   augmented_state_format = a binary indicator of whether or not the
%       value_function_CELL elements are of the format:
%       for augmented state method, value_function_design_i(l_index,:,:)
%   [file]
%       /staging/{underapproxScenarioID}/{underapproxConfigurationID}/Bellman_complete.mat : a
%       file containing Bellman recursion results for underapproxScenarioID and
%       underapproxConfigurationID
% OUTPUTS:
%    percent_change_newdesign_vs_baseline = a summary of results 
%    
%   [file](s)
%       /staging/figures/base_filename.png
%       /staging/figures/base_filename.fig 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function percent_change_newdesign_vs_baseline = compare_designs( ...
    underapproxScenarioID, ...
    underapproxConfigurationID, ...
    value_function_CELL, ...
    alphas, ...
    my_LineStyles, ...
    my_LineColors, ...
    rs_to_show, ...
    myYLIM, ...
    legend_struct, ...
    base_figure_filename, ...
    augmented_state_format)

    % load underapproximation
    staging_area = get_staging_directory(underapproxScenarioID, underapproxConfigurationID);
    bellman_file = strcat([staging_area,'Bellman_complete.mat']);

    % if file is available, load it, otherwise prompt to Run_Bellman_Recursion.
    if isfile(bellman_file)
        load(bellman_file);
    else
        error(strcat('No results available for this scenario (',underapproxScenarioID, ') and configuration (', mat2str(underapproxConfigurationID),'). Please Run_Bellman_Recursion first.'));  
    end

    % load globals (for WRS, configID = 20)
    global scenario;
    global config;
    global ambient;

    if strcmp(base_figure_filename, '')
       plot_results = 0; 
    else
       plot_results = 1; 
    end
    
    nl = length(alphas);

    N_DESIGNS = length(value_function_CELL);
    
    if scenario.dim ~= 2

        error('only written for real dim = 2');
    else

        if plot_results
            figure
        end

        percent_change_newdesign_vs_baseline = cell(N_DESIGNS,1);
        W0_star_grid = cell(nl,1);

        for l_index = 1 : nl % for each alpha want to show contours for all designs on one plot

            if plot_results
                set(gcf,'color','w');
                subplot(1, nl, l_index);
            end

            for i = 1 : N_DESIGNS

                % grab results for design i 
                value_function_design_i = value_function_CELL{i};

                % plot results for design i, alpha = myalpha(l_index)
                if ~augmented_state_format          % used for under-approx method, value_function_design_i{l_index}

                    if plot_results
                        [C, h] = contour(ambient.x2g, ambient.x1g, squeeze(value_function_design_i(l_index,:,:)),rs_to_show);
                    end

                elseif augmented_state_format       % used for state-aug method, value_function_design_i(l_index,:,:)

                    W0_star_grid{l_index} = reshape(value_function_design_i{l_index}, [ambient.x2n, ambient.x1n]);
                    
                    if plot_results
                        [C, h] = contour(ambient.x2g, ambient.x1g, W0_star_grid{l_index}, rs_to_show);
                    end

                end

                if plot_results
                    clabel(C,h);
                    h.LineWidth = 1.2;
                    h.LineColor = my_LineColors{i};
                    h.LineStyle = my_LineStyles{i};
                    h.ShowText = 'off'; % to not display labels on contour lines.
                    hold on;
                end

                if i == 1 % for baseline design, particular l_index
                    number_states_baseline_l = zeros(length(rs_to_show),1);
                    for r = 1 : length(rs_to_show)
                        % number of states inside contour r, baseline design
                        if ~augmented_state_format  
                           number_states_baseline_l(r) = sum( sum( value_function_design_i(l_index,:,:) <= rs_to_show(r) ) );
                        elseif augmented_state_format  
                            number_states_baseline_l(r) = sum( sum( W0_star_grid{l_index} <= rs_to_show(r) ) );
                        end
                    end

                elseif i > 1 % any design other than baseline, particular l_index
                    for r = 1:length(rs_to_show)
                        % number of states inside contour level = rs_to_show(r), design i
                        if ~augmented_state_format
                            number_states_design_i_r_l = sum( sum( value_function_design_i(l_index,:,:) <= rs_to_show(r) ) );
                        elseif augmented_state_format 
                            number_states_design_i_r_l = sum( sum( W0_star_grid{l_index} <= rs_to_show(r) ) );
                        end
                        % percent change newdesign i vs. baseline, contour level = rs_to_show(r), alpha = myalpha(l_index)
                        percent_change_newdesign_vs_baseline{i}(r, l_index) = (number_states_design_i_r_l - number_states_baseline_l(r)) / number_states_baseline_l(r);
                    end
                end

            end

            if plot_results
                % label figure
                title(['$\alpha$ = ', num2str(alphas(l_index))], 'Interpreter','Latex', 'FontSize', 12);
                xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
                ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
                ylim([0 myYLIM]);
                grid on;
                hold off;

                if l_index ==  nl
                   legend(legend_struct,'Interpreter','Latex','FontSize', 10, 'Location','northeast');
                end
            end

        end

        % save figure
        if plot_results
            
            if(augmented_state_format)
                sgtitle('State-Aug. Method');
            else
                sgtitle('Under-Approx. Method');
            end
            
            staging_area = get_staging_directory('', 'figures');
            path_to_png = strcat(staging_area,base_figure_filename,'.png');
            path_to_fig = strcat(staging_area,base_figure_filename,'.fig');

            saveas(gcf,path_to_fig);
            f = gcf;
            f.PaperUnits = 'inches';
            f.PaperPosition = [0 0 18 3.2];
            print(path_to_png,'-dpng','-r0');
        end
        
    end
 
end

