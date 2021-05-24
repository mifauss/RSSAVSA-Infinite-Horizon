%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Plots figure 2 from Chapman, et al., 
% “Risk-sensitive safety analysis via state-space augmentation.”
% OUTPUTS:
%   [file](s)
%       /staging/figures/figure2.png
%       /staging/figures/figure2.fig 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Plot_Figure_2

    close all; 
    
    figure(2); 

    global scenario;
    global config;
    global ambient;

    scenarioID = 'WRSU0'; configID = 10;

    scenario = get_scenario(scenarioID);

    config = get_config(configID);

    calculate_ambient_variables;

    gx1 = scenario.cost_function(ambient.xcoord, scenario);

    gx2 = no_clip_at_zero_max_flood_level(ambient.xcoord, scenario); 

    gx1_grid = reshape(gx1, [ambient.x2n, ambient.x1n]);

    gx2_grid = reshape(gx2, [ambient.x2n, ambient.x1n]);

    zMIN = min(min([gx1 gx2]));

    zMAX = max(max([gx1 gx2]));

    myX = [scenario.K_max(2); scenario.K_max(2); 0];
    myY = [0; scenario.K_max(1); scenario.K_max(1)];
    myZ = [zMIN; zMIN; zMIN];

    myX1_K = 0:0.1:scenario.K_max(1); myX1_Kn = length(myX1_K);
    myX2_K = 0:0.1:scenario.K_max(2); myX2_Kn = length(myX2_K);
    K_grid = reshape(zMIN * ones(myX1_Kn * myX2_Kn,1), [myX2_Kn, myX1_Kn]);

    [X1_K, X2_K] = ndgrid(myX1_K, myX2_K); 

    set_figure_properties;

    %Plot max(x1-k1, x2-k2, 0)

    subplot(1,2,1);

    mymesh1 = mesh(ambient.x2g, ambient.x1g, gx1_grid, 'FaceAlpha', 0.5); hold on;
    %mymesh1.EdgeColor = 'none'; % does not draw edges
    mymesh1.FaceColor = 'flat';

    mymesh2 = mesh(X2_K', X1_K', K_grid);

    mymesh2.FaceColor =[0.4660 0.6740 0.1880]; %dark-ish green
    mymesh2.EdgeColor = 'none';

    %plot3(myX, myY, myZ, 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 2 );
    % this just plots the boundary of K

    xlabel('$x_2$','Interpreter','Latex','FontSize', 16);

    ylabel('$x_1$','Interpreter','Latex','FontSize', 16);

    xlim([0 max(ambient.x2s)]);

    ylim([0 max(ambient.x1s)]);

    zlim([zMIN zMAX]);

    title('$\max\{x_1 - k_1, x_2 - k_2, 0\}$', 'Interpreter','Latex','FontSize', 16);

    grid on;

    % Plot max(x1-k1,x2-k2)

    subplot(1,2,2);

    mymesh1 = mesh(ambient.x2g, ambient.x1g, gx2_grid, 'FaceAlpha', 0.5); hold on;
    %facealpha makes it semi-transparent
    %mymesh1.EdgeColor = 'none'; % does not draw edges
    mymesh1.FaceColor = 'flat';

    mymesh2 = mesh(X2_K', X1_K', K_grid); hold on;

    mymesh2.FaceColor =[0.4660 0.6740 0.1880]; %dark-ish green
    mymesh2.EdgeColor = 'none';

    plot3(myX, myY, myZ, 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 2 );

    xlabel('$x_2$','Interpreter','Latex','FontSize', 16);

    ylabel('$x_1$','Interpreter','Latex','FontSize', 16);

    xlim([0 max(ambient.x2s)]);

    ylim([0 max(ambient.x1s)]);

    zlim([zMIN zMAX]);

    title('$\max\{x_1 - k_1, x_2 - k_2\}$', 'Interpreter','Latex','FontSize', 16);

    grid on;
    
    staging_area = get_staging_directory('', 'figures');
    path_to_png = strcat(staging_area,'figure2.png');
    path_to_fig = strcat(staging_area,'figure2.fig');
    saveas(gcf,path_to_fig);

    f = gcf;
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 16 6];
    print(path_to_png,'-dpng','-r0');
    
end








