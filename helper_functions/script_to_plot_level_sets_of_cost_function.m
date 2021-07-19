% script for plotting level sets of g(x)
% follows similar steps as in Run_Outer_Optimization to extra real
% coordinates.

close all; clearvars; clc;

scenarioID = 'WRSA0';
configID = 20;
global scenario;

verifiedAmbient = check_grid_consistency(scenarioID, configID, configID);

real_coordinates = verifiedAmbient.xcoord(1:verifiedAmbient.x3n:end, 1:2);

gx = zeros(verifiedAmbient.x1n * verifiedAmbient.x2n,1);

for i = 1 : verifiedAmbient.x1n * verifiedAmbient.x2n
    x1 = real_coordinates(i,1);
    x2 = real_coordinates(i,2);
    gx(i) = scenario.cost_function([x1 x2], scenario);
end

rs_to_show = [0.2, 0.5, 0.8, 1, 1.1, 1.3, 1.5];
    
gx_grid = reshape(gx, [verifiedAmbient.x2n, verifiedAmbient.x1n]);

% begin plotting section
figure
set(gcf,'color','w');

[CW, hW] = contour(verifiedAmbient.x2g(:,:,1), verifiedAmbient.x1g(:,:,1), gx_grid, rs_to_show);
clabel(CW,hW);
hW.LineWidth = 1.2;
hW.LineColor = 'blue';
hW.LineStyle = '-'; % we haven't used (magenta dotted, blue solid) combination yet

title('Level sets of $g_K(x)$', 'Interpreter','Latex', 'FontSize', 12);
%legend('State-aug','Interpreter','Latex','FontSize', 12, 'Location','northeast');
xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
grid on;
hold off;



    
