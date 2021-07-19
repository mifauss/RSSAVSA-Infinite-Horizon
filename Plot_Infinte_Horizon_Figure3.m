%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot safe set for "infinite" horizon case
% Adapted from 'Plot_Figure_4.m', see the latter for more details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Plot_Infinte_Horizon_Figure3(scenarioID)

    staging_area = get_staging_directory('', '');
    %outer_optimization_file = strcat([staging_area,'outer_optimization.mat']);
    outer_optimization_file = strcat([staging_area,'outer_optimization_',scenarioID, '.mat']);
    staging_area = get_staging_directory('', 'figures');
    
    % if file is available, load it, otherwise prompt to Run_Outer_Optimization.
    if isfile(outer_optimization_file)
        load(outer_optimization_file, 'V_alpha', 'alpha', 'real_coordinates');
    else
        error(strcat('No outer optimizations available. Please Run_Outer_Optimization first.'));   
    end

    global ambient;
    global scenario;
    scenario = get_scenario(scenarioID);
    rs_to_show = [0.2, 0.5, 0.8, 1, 1.1, 1.3, 1.5, 1.7, 1.9];
    W0_star_grid = reshape(V_alpha{1}, [ambient.x2n, ambient.x1n]); %since we've only done the computation for one alpha value

    % begin plotting section
    figure
    set(gcf,'color','w');

    [CW, hW] = contour(ambient.x2g(:,:,1), ambient.x1g(:,:,1), W0_star_grid, rs_to_show);
    clabel(CW,hW);
    hW.LineWidth = 1.2;
    hW.LineColor = 'blue';
    hW.LineStyle = '-'; % we haven't used (magenta dotted, blue solid) combination yet

    title([scenario.design,': $\alpha$ = ', num2str(alpha), ', $N$ = ', num2str(scenario.exptNiter)], 'Interpreter','Latex', 'FontSize', 12);
    %legend('State-aug','Interpreter','Latex','FontSize', 12, 'Location','northeast');
    xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
    ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
    grid on;
    hold off;

    path_to_png = strcat(staging_area,'figure_inf',mat2str(1),'.png');
    path_to_fig = strcat(staging_area,'figure_inf',mat2str(1),'.fig');
    saveas(gcf,path_to_fig);

    f = gcf;
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 18 3.2];
    print(path_to_png,'-dpng','-r0');


end

