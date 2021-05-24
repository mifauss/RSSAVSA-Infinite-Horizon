%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Plots figure 6 or creates table 4 from Chapman, et al., 
% “Risk-sensitive safety analysis via state-space augmentation.”
% INPUTS:
%   mode = either 'table' or 'figure'
% OUTPUTS (depending on selected mode):
%   [text] prints table 4 on the command prompt output
%   [file](s)
%       /staging/figures/figure6_1.png
%       /staging/figures/figure6_1.fig 
%       /staging/figures/figure6_2.png
%       /staging/figures/figure6_2.fig 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Plot_Figure_6_Or_Create_Table_4(mode)

    if strcmp(mode, 'table')
       figure6_1_filename = '';
       figure6_2_filename = '';
    elseif strcmp(mode, 'figure')
       figure6_1_filename = 'figure6_1';
       figure6_2_filename = 'figure6_2';
    end

    % this paper explores 1 baseline design and 3 design alternatives
    N_DESIGNS = 4; 

    % Scenario IDs for under approximation method  
    scenarioIDs_UND = { 
        'WRSU0', ... % 0: BASELINE DESIGN
        'WRSU1', ... % 1: AUTOMATED PUMP, MAX PUMP RATE = 10
        'WRSU2', ... % 2: OUTLET TO STORM SEWER, TANK 1
        'WRSU3' };   % 3: INCREASE SURFACE AREA OF TANK 2 BY 20%

    % underapproximation uses configuration 20
    configID_UND = 20; 
    
    % if file is available, load it, otherwise prompt to Run_Outer_Optimization.
    staging_area = get_staging_directory('', '');
    outer_optimization_file = strcat([staging_area,'outer_optimization.mat']);
    if isfile(outer_optimization_file)
        load(outer_optimization_file, 'V_alphas', 'alphas');
    else
        error(strcat('No outer optimizations available. Please Run_Outer_Optimization first.'));   
    end

    % scale results of underapproximation method to appropriate levels for
    % input vector of alphas
    for des = 1 : N_DESIGNS
        J0_cost_sum_scaled_by_y_with_log_etc_CELL{des} = get_cost_sum_scaled_by_y_with_log_etc(scenarioIDs_UND{des}, configID_UND, alphas);
    end
    
    % setup styles
    my_LineStyles = {'-', '-.', '-', '-.'};
    my_LineColors = {'magenta', 'blue', 'black', [ 0.9100 0.4100 0.1700]}; % dark orange
    legend_struct = {'a) Baseline', 'b) Add pump', 'c) Add outlet', 'd) Increase $a_2$'};
    myYLIM_b = 5; % start with 5 and then decrease to not show white space
    rs_to_show = [0.2, 1, 1.8];
    
    % last parameter is a zero flag since the data comes in the form: value_function_design_i(l_index,:,:)
    percent_change_newdesign_vs_baseline_UND = compare_designs( ...
        scenarioIDs_UND{1}, configID_UND, J0_cost_sum_scaled_by_y_with_log_etc_CELL, alphas, ...
        my_LineStyles, my_LineColors, rs_to_show, ...
        myYLIM_b, legend_struct, figure6_2_filename, 0);

    % last parameter is a one flag since the data comes in the form: value_function_design_i{l_index}
    % V_alphas{des} = Valpha for design des, is a cell where the l_index entry of cell is for myalphas(l_index)
    percent_change_newdesign_vs_baseline_AUG = compare_designs( ...
        scenarioIDs_UND{1}, configID_UND, V_alphas, alphas, ...
        my_LineStyles, my_LineColors, rs_to_show, ...
        myYLIM_b, legend_struct, figure6_1_filename, 1);
    
    if strcmp(mode,'table')
    
        disp('                  ');
        disp('Table IV     ');
        disp('                  ');
        
        for alpha_index = 1:length(alphas)
            alpha = alphas(alpha_index); 
            
            % header
            disp(strcat(['alpha = ', pad(mat2str(alpha),6), '    | b vs. a  | c vs. a | d vs. a |', ]));
            
            % state augmentation row
            disp(strcat([pad('   State-Aug      |',20), ...
                pad(mat2str(round(percent_change_newdesign_vs_baseline_AUG{2}(2,alpha_index),2,'significant')),9,'both'), ...
                '|',...
                pad(mat2str(round(percent_change_newdesign_vs_baseline_AUG{3}(2,alpha_index),2,'significant')),9,'both'), ...
                '|',...
                pad(mat2str(round(percent_change_newdesign_vs_baseline_AUG{4}(2,alpha_index),2,'significant')),9,'both'), ...
                '|',...
                ]));
            
           % under-approx row
            disp(strcat([pad('   Under-Approx.  |',20), ...
                pad(mat2str(round(percent_change_newdesign_vs_baseline_UND{2}(2,alpha_index),2,'significant')),9,'both'), ...
                '|',...
                pad(mat2str(round(percent_change_newdesign_vs_baseline_UND{3}(2,alpha_index),2,'significant')),9,'both'), ...
                '|',...
                pad(mat2str(round(percent_change_newdesign_vs_baseline_UND{4}(2,alpha_index),2,'significant')),9,'both'), ...
                '|',...
                ]));
            
            disp('                  ');
    
        end
    end
    
end


