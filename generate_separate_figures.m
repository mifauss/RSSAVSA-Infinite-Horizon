%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Save separate figures, so that we can generate the whole plot
% using subplot(). This function generate 3 figures for N=200,250 or 300.
% Depending on the N value of WRSA0.
% INPUT:
    %
% OUTPUT: 
    % fig files saved in staging/figures.
    % Format in: 'alpha_N.mat'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function generate_separate_figures()
    Plot_Infinte_Horizon_Single_Figure('WRSA0',0.99);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA0',0.05);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA0',0.0005);
    close;
    
    Plot_Infinte_Horizon_Single_Figure('WRSA1',0.99);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA1',0.05);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA1',0.0005);
    close;
    
    Plot_Infinte_Horizon_Single_Figure('WRSA2',0.99);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA2',0.05);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA2',0.0005);
    close;
    
    Plot_Infinte_Horizon_Single_Figure('WRSA3',0.99);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA3',0.05);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA3',0.0005);
    close;
    
    Plot_Infinte_Horizon_Single_Figure('WRSA4',0.99);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA4',0.05);
    close;
    Plot_Infinte_Horizon_Single_Figure('WRSA4',0.0005);
    close;
end

