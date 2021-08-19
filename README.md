# Overview
Analysis code to generate figures and artifacts presented in Chapman, et al., “CVaR-based Safety Analysis for the Infinite Time Setting” 

## Environment
It is recommended to run the script on Matlab 2020b. And it is recommended to run the script on a cluster instead of a personal computer. (Running the main file takes more than a week on cedar supercomputer in ComputeCanada)

## Introduction
In the paper on page 3. The computational process is listed as follows:

![image](https://user-images.githubusercontent.com/89077814/130007972-db368f31-5504-4ba6-a0b9-0ff392847de4.png)

Therefore, our code is splitted into three parts:
1) Calculate the function V_s using the algorithm guranted by Theorem 1.
2) Use results from 1) to calculate V_alpha^* , this step will be called *outer_optimization*.
3) Get the S^r_alpha set and visualize the result.

## Calculate V_s
Algorithm 1 provides us an approximation algorithm, which uses v_s^t to approximate V_s. In numeric setting, we need to choose the number of iterations N such that v_s^t gives a good approximation. This is specified in `configuration options/get_scenario.m`, a total of five scenarios are provided:
1. Code:'WRSA0',N=200.
2. Code:'WRSA1',N=250.
3. Code:'WRSA2',N=280.
4. Code:'WRSA3',N=300.
5. Code:'WRSA4',N=400.

Also, we need to specify the range of s such that V_s is calculated. The main file uses a range [0,2] with 0.1 increment.

Once we set the number N and s range, we can run the function `Run_Infinite_Horizon_Design_MPC(scenarioID, alpha, mys_values)` to obtain files containing information about V_s.  
(ScenarioID is 'WRSAi' as a string, enter 0.99 for alpha, and your s range for mys_values)

This step takes almost all the computational resources.

The results are stored as .mat files as follows:

