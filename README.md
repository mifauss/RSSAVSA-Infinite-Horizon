# Overview
Analysis code to generate the figure presented in Chapman, et al., “CVaR-based Safety Analysis for the Infinite Time Setting” 

## Environment
It is recommended to run the script on Matlab 2020b. And it is recommended to run the script on a cluster instead of a personal computer. (Running the main file takes more than a week on cedar supercomputer in ComputeCanada)


This code makes use of a parallel pool to speed up computation times. Please specify the pool size that reflects the resources you want to dedicate to these computations versus other tasks on your machine.

The parallel pool size can be specified by calling `parpool('local', n)` prior to run `Run_Infinite_Horizon_Design_MPC(scenarioID, alpha, mys_values)`. Documentation of Matlab parallel pool is avaliable at https://www.mathworks.com/help/parallel-computing/parpool.html.
(n is number of workers)

## Introduction
In the paper on page 3. The computational process is listed as follows:

![image](https://user-images.githubusercontent.com/89077814/130007972-db368f31-5504-4ba6-a0b9-0ff392847de4.png)

Therefore, our code is splitted into three parts:
1) Calculate the function V_s using the algorithm guranted by Theorem 1.
2) Use results from 1) to calculate V_alpha^* , this step will be called **outer optimization**.
3) Get the S^r_alpha set and visualize the result.

## Calculate V_s
Algorithm 1 provides us an approximation algorithm, which uses v_s^t to approximate V_s. In numeric setting, we need to choose the number of iterations N such that v_s^t gives a good approximation. This is specified in `configuration options/get_scenario.m`, a total of five scenarios are provided:

| Code          |N        
| ------------- |:-------------:|
| 'WRSA0'     | 200 |
| 'WRSA1      | 250      |
| 'WRSA2 | 280
| 'WRSA3 | 300|
| 'WRSA4 | 400|


Also, we need to specify the range of *s* such that *V_s* is calculated. The main file uses a range [0,2] with 0.1 increment.

Once we set the number N and *s* range, we can run the function `Run_Infinite_Horizon_Design_MPC(scenarioID, alpha, mys_values)` to obtain files containing information about *V_s*.  
(ScenarioID is 'WRSAi' as a string, enter 0.99 for alpha, and your s range for mys_values)

This step takes almost all the computational resources.

The results are stored as .mat files as follows:

![Animation](https://user-images.githubusercontent.com/89077814/130104997-4a9cb0f8-9eba-4e35-8afa-6866bc29a6db.gif)

Each folder with name between 10 and 30 represents a *s* value, which contains results for different N. Once s value and N is set, a .mat file will store the V_s array, and a log file will be generated to show runtime. These folders will be saved under `ome_directory/staging/`

## Outer Optimization

Once the V_s folders are ready. One can run outer optimization to obtain V_alpha^* . 
One can run `Run_Outer_Optimization(scenarioID, start_configID, end_configID, alphas)` to generate an outer optimization file(corresponding to a specific V_alpha^* ) by specifying an alpha value. The resultant file will be saved under `staging/` for example as `outer_optimization_WRSA1_N=250_alpha=0.99.mat`.

Run `generate_out_optimization_files.m` will run outer optimization for alpha = [0.99,0.05,0.0005] and N=[200,250,280,300,400].

The results are stored as .mat files as follows:
![Animation1](https://user-images.githubusercontent.com/89077814/130107588-9802fcec-7e2a-411d-8ff6-fc89dfb69574.gif)

## Get S^r_alpha Set and Visualize Result

Now all the outer optimization files should be produced. We can use these files to generate a figure representing the resultant S^r_alpha set. 
One can use `Plot_Infinte_Horizon_Single_Figure(scenarioID,alpha)` to generate a figure with name `alpha_N` under `taging/figure`, for example:
![Animation2](https://user-images.githubusercontent.com/89077814/130112760-b48f9c05-1498-46e1-a20b-96b94be543ac.gif)

In order to create a figure containing multiple of figures above, first run `generate_separate_figures.m`, this will generate all .fig files under `staging/figures`. And then run 
`generate_whole_figure(alpha_vec,N_vec)`, this function will generate a figure containing subplots according to the input entered. 
For example, if I enter alpha_vec = [0.99 0.05] and N_vec = [200 250 280], the result will be shown as:
![readme](https://user-images.githubusercontent.com/89077814/130112824-95c408ce-9372-438f-9e74-b25ee099ee7b.jpg)

## Defining Your Own Test

Scenario settings such as number of iterations, or surface area of water tank can be specified under `configuration_options/get_scenario.m`. Parameters such as state space grid spacing can be changed in `configuration_options/get_config.m`.


