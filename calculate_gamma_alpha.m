%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Calculate the gamma_alpha value so that we can get results about
% convergence.
% INPUT:
    % Make sure under /staging. We have two files:
    % 1.outer_optimization_WRSA0_N=280_alpha=0.05.mat
    % 2.outer_optimization_WRSA0_N=300_alpha=0.05.mat
    % So before running this script, make sure to run Outer Optimization
    % for N=280,alpha=0.05 and N=300,alpha=0.05, and save the output as a
    % file with above name.
% OUTPUT: 
    % gamma_alpha = sup_x{|V_alpha_280(x)-V_alpha_300(x)|}
    % If this value is smaller than delta_x/100, then the convergence
    % criteria is met.
    % Note the delta_x we use is 0.1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gamma_alpha = calculate_gamma_alpha(alpha,N_prime,N)
    scIDprime = '';
    switch N_prime
        case 200         
            scIDprime = '0';
        case 250         
            scIDprime = '1';
        case 280         
            scIDprime = '2';
        case 300         
            scIDprime = '3';
        case 400             
           scIDprime = '4';
    end
    
    scID = '';
    switch N
        case 200         
            scID = '0';
        case 250         
            scID = '1';
        case 280         
            scID = '2';
        case 300         
            scID = '3';
        case 400             
           scID = '4';
    end
    prime_directory = strcat('staging/outer_optimization_WRSA',scIDprime,'_N=',num2str(N_prime),'_alpha=',num2str(alpha),'.mat');
    unprime_directory = strcat('staging/outer_optimization_WRSA',scID,'_N=',num2str(N),'_alpha=',num2str(alpha),'.mat');
    load(prime_directory,'V_alphas');  
    V_alpha_280 = V_alphas{1};
    load(unprime_directory,'V_alphas'); 
    V_alpha_300 = V_alphas{1};
    abs_diff = abs(V_alpha_280(:)-V_alpha_300(:));
    gamma_alpha = max(abs_diff);
end

%When N_prime=280, N=300, alpha=0.05, the result is gamma_alpha=0.0030
%When N_prime=280, N=300, alpha=0.0005, the result is gamma_alpha=0.0048


    
    

