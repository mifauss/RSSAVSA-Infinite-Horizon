close all; clearvars; clc;

%myscenarioIDs = {'WRSA0', 'WRSA1', 'WRSA2', 'WRSA3','WRSA4', 'WRSA5' };
% scenario.exptNiter = 30; 'WRSA0'
% scenario.exptNiter = 60; 'WRSA1'
% scenario.exptNiter = 90; 'WRSA2'
% scenario.exptNiter = 200;'WRSA3'
% scenario.exptNiter = 1;  'WRSA4'
% scenario.exptNiter = 250;'WRSA5'
Ns = [30, 60, 90, 200, 1, 250];

load('staging\outer_optimization_j_1.mat') % N = 30

V_alpha_N_30 = V_alpha{1};

load('staging\outer_optimization_j_2.mat') % N = 60

V_alpha_N_60 = V_alpha{1};

load('staging\outer_optimization_j_3.mat') % N = 90

V_alpha_N_90 = V_alpha{1};

load('staging\outer_optimization_j_4.mat') % N = 200

V_alpha_N_200 = V_alpha{1};

load('staging\outer_optimization_j_5.mat') % N = 1

V_alpha_N_1 = V_alpha{1};

load('staging\outer_optimization_j_6.mat') %N = 250

V_alpha_N_250 = V_alpha{1};

maxdiff_N250_vs_N200 = max(abs(V_alpha_N_250-V_alpha_N_200)); % this is 0.0038

maxdiff_N250_vs_N90 = max(abs(V_alpha_N_250-V_alpha_N_90));

maxdiff_N250_vs_N60 = max(abs(V_alpha_N_250-V_alpha_N_60));

maxdiff_N250_vs_N30 = max(abs(V_alpha_N_250-V_alpha_N_30));

maxdiff_N250_vs_N1 = max(abs(V_alpha_N_250-V_alpha_N_1));

for j = 1 : 6
    Plot_Infinte_Horizon_Figure2(j,Ns(j))
end







