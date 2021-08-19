%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Generates applicable tables in
% “Risk-sensitive safety analysis via state-space augmentation.”
% OUTPUTS: prints table to command line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Generate_Table(tableNumber)

   switch(tableNumber)

       case 4
           Plot_Figure_6_Or_Create_Table_4('table');    
           
       otherwise
           disp(strcat({'Not applicable to table '}, mat2str(tableNumber)));  
       
   end 
   
end