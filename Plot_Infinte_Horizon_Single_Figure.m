%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot safe set for "infinite" horizon case
% Adapted from 'Plot_Figure_4.m', see the latter for more details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Plot_Infinte_Horizon_Single_Figure(scenarioID,alpha)

    Nnumber = 0;
    switch scenarioID
        case 'WRSA0'          
            Nnumber = 200;
        case 'WRSA1'          
            Nnumber = 250;
        case 'WRSA2'          
            Nnumber = 280;
        case 'WRSA3'          
            Nnumber = 300;
       case 'WRSA4'              
           Nnumber = 400;
    end
    Nstring = num2str(Nnumber);
    
    outer_optimization_file = strcat('staging/outer_optimization_',scenarioID,'_N=',Nstring,'_alpha=',num2str(alpha),'.mat');
    staging_area = get_staging_directory('', 'figures');
    
    % if file is available, load it, otherwise prompt to Run_Outer_Optimization.
    if isfile(outer_optimization_file)
        load(outer_optimization_file, 'V_alphas', 'alphas', 'real_coordinates');
    else
        error(strcat('No outer optimizations available. Please Run_Outer_Optimization first.'));   
    end
    V_alpha=V_alphas;
    alpha=alphas;

    global ambient;
    global scenario;
    scenario = get_scenario(scenarioID);
    rs_to_show = [0.2, 0.5, 0.6,0.8, 1, 1.2, 1.5, 1.8];
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
    ylim([0 5]);
    grid on;
    hold off;
    
    alpha_string=num2str(alpha);
    N_string=num2str(scenario.exptNiter);
    fileName=strcat(alpha_string,'_',N_string);

    path_to_png = strcat(staging_area,fileName,'.png');
    path_to_fig = strcat(staging_area,fileName,'.fig');
    saveas(gcf,path_to_fig);

    f = gcf;
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 18 3.2];
    print(path_to_png,'-dpng','-r0');


end

