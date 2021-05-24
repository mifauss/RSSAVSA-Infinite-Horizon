%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Generates applicable figures in
% “Risk-sensitive safety analysis via state-space augmentation.”
% OUTPUTS:
%   [file](s)
%       /staging/figures/figure[n].png
%       /staging/figures/figure[n].fig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Generate_Figure(figureNumber)

   switch(figureNumber)

       case 2 
           Plot_Figure_2();
       
       case 4
           Plot_Figure_4();
           
       case 5
           Plot_Figure_5();

       case 6
           Plot_Figure_6_Or_Create_Table_4('figure');    
           
       otherwise
           disp(strcat({'Not applicable to figure '}, mat2str(figureNumber)));  
       
   end 
   
end