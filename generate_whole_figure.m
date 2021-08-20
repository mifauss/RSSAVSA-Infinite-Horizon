%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Utilizing the separate figrues saved in staging/figures, we
% create final eps image that will be used in the paper.
% Note:
    % Must first run generate_separate_figures.m, so that 12 .fig files are
    % ready under staging/figures.
% OUTPUT: 
    % A final eps image file.
% Input:
    % alpha_vec is a row vector containing all the alpha value you are
    % interested. Similar for N_vec.
    % alpha_vec must be a subset of [0.99 0.05 0.0005]
    % N_vec must be a subset of [200 250 280 300 400]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function generate_whole_figure(alpha_vec,N_vec)

total_number = length(N_vec)*length(alpha_vec);

for i = 1:length(N_vec)
    for j = 1:length(alpha_vec)
        alphastr = num2str(alpha_vec(j));
        Nstr = num2str(N_vec(i));
        result_string = strcat(alphastr,'_',Nstr);
        reference_matrix(i,j)= string(result_string);
    end
end
    reference_matrix = reshape(reference_matrix,1,[]);
    %reference_matrix=["0.99_200" "0.05_200" "0.0005_200" "0.99_250" "0.05_250" "0.0005_250" "0.99_300" "0.05_300" "0.0005_300" "0.99_400" "0.05_400" "0.0005_400"];
for i = 1:1:total_number
    filename = strcat('staging/figures/',reference_matrix(i),'.fig');
    h(i) = openfig(filename,'reuse');
    ax(i) = gca;
end
h(total_number+1)=figure;
set(gcf,'color','w');

for i = 1:1:total_number
    s(i) = subplot(length(alpha_vec),length(N_vec),i);
    matrix_string = reference_matrix(i);
    k = strfind(matrix_string,'_');
    alphastring = extractBetween(matrix_string,1,k-1);
    Nstring = extractBetween(matrix_string,k+1,strlength(matrix_string));
    alphanum = str2num(alphastring);
    Nnum = str2num(Nstring);
    alphastring = num2str(alphanum);
    Nstring = num2str(Nnum);
    title(['$\alpha$ = ', alphastring,', $N$ = ', Nstring], 'Interpreter','Latex', 'FontSize',12);
    xlabel('$x_2$','Interpreter','Latex','FontSize', 12);
    ylabel('$x_1$','Interpreter','Latex','FontSize', 12);
    ylim([0 5.3]);
    grid on;
end

for i = 1:1:total_number
    fig(i) = get(ax(i),'children');
end

for i=1:1:total_number
    copyobj(fig(i),s(i));
end

for j = 1:1:total_number
    close(h(j));
end
final = gcf;
saveas(final,'staging/figures/Final_Figure.eps');
end
