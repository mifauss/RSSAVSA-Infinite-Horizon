%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Generate Out Optimization files under staging/. These files will
% be used to generate figures and calculate gamma_alpha.
% INPUT:
    % The 10-30 files under /staging, WRSA0-WRSA4 must all be ready.
    % Please run get_Infinite_Horizon first.
% OUTPUT: 
    % A total of 5*3 = 15 outer optimization files under /staging.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function generate_out_optimization_files()
    Run_Outer_Optimization('WRSA0',10,30,0.99);
    Run_Outer_Optimization('WRSA0',10,30,0.05);
    Run_Outer_Optimization('WRSA0',10,30,0.0005);
    
    Run_Outer_Optimization('WRSA1',10,30,0.99);
    Run_Outer_Optimization('WRSA1',10,30,0.05);
    Run_Outer_Optimization('WRSA1',10,30,0.0005);
    
    Run_Outer_Optimization('WRSA2',10,30,0.99);
    Run_Outer_Optimization('WRSA2',10,30,0.05);
    Run_Outer_Optimization('WRSA2',10,30,0.0005);
    
    Run_Outer_Optimization('WRSA3',10,30,0.99);
    Run_Outer_Optimization('WRSA3',10,30,0.05);
    Run_Outer_Optimization('WRSA3',10,30,0.0005);
    
    Run_Outer_Optimization('WRSA4',10,30,0.99);
    Run_Outer_Optimization('WRSA4',10,30,0.05);
    Run_Outer_Optimization('WRSA4',10,30,0.0005);
end

