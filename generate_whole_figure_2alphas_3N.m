%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Utilizing the separate figrues saved in staging/figures, we
% create final eps image that will be used in the paper.
% INPUT:
    %
% OUTPUT: 
    % A final eps image file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function generate_whole_figure_2alphas_3N()
%     reference_matrix=["0.99_200","0.05_200","0.0005_200", 
%                 "0.99_250","0.05_250","0.0005_250", 
%                 "0.99_300","0.05_300","0.0005_300"];
%             str_name=reference_matrix(1);
%             directory=strcat('staging\figures\',str_name,'.fig');
%             h1=openfig(directory,'reuse');
%             ax=gca;
%             fig=get(ax,'children');
%             s=subplot(3,3,1);
%             copyobj(fig,s);
h2 = openfig('0.05_200.fig','reuse');
ax2 = gca;
h3 = openfig('0.0005_200.fig','reuse');
ax3 = gca;
h5 = openfig('0.05_250.fig','reuse');
ax5 = gca;
h6 = openfig('0.0005_250.fig','reuse');
ax6 = gca;
h8 = openfig('0.05_300.fig','reuse');
ax8 = gca;
h9 = openfig('0.0005_300.fig','reuse');
ax9 = gca;
% test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
h10 = figure; %create new figure
set(gcf,'color','w');



s2 = subplot(2,3,1);
title(['$\alpha$ = ', num2str(0.05),', $N$ = ',num2str(200)], 'Interpreter','Latex', 'FontSize', 12);
xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
grid on;

s5 = subplot(2,3,2);
title(['$\alpha$ = ', num2str(0.05),', $N$ = ',num2str(250)], 'Interpreter','Latex', 'FontSize', 12);
xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
grid on;

s8 = subplot(2,3,3);
title(['$\alpha$ = ', num2str(0.05),', $N$ = ',num2str(300)], 'Interpreter','Latex', 'FontSize', 12);
xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
grid on;

s3 = subplot(2,3,4);
title(['$\alpha$ = ', num2str(0.0005),', $N$ = ',num2str(200)], 'Interpreter','Latex', 'FontSize', 12);
xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
grid on;

s6 = subplot(2,3,5);
title(['$\alpha$ = ', num2str(0.0005),', $N$ = ',num2str(250)], 'Interpreter','Latex', 'FontSize', 12);
xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
grid on;


s9 = subplot(2,3,6);
title(['$\alpha$ = ', num2str(0.0005),', $N$ = ',num2str(300)], 'Interpreter','Latex', 'FontSize', 12);
xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
grid on;


fig2 = get(ax2,'children');
fig3 = get(ax3,'children');
fig5 = get(ax5,'children');
fig6 = get(ax6,'children');
fig8 = get(ax8,'children');
fig9 = get(ax9,'children');

copyobj(fig2,s2);
copyobj(fig3,s3);
copyobj(fig5,s5);
copyobj(fig6,s6);
copyobj(fig8,s8);
copyobj(fig9,s9);

close(h2);
close(h3);
close(h5);
close(h6);
close(h8);
close(h9);
end

