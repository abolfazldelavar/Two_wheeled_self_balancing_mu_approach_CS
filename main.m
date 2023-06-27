close all; clear; clc;

% ------ Segway Robust Control -----
% -------- Abolfazl Delavar -------- 
% ------ faryadell@gmail.com -------
%%------------------------------------------------------------------------#
    
    run PLTOPT.m                %Plot options
    run MODELING_SYSTEM;        %Making Gnominal and other perturbated systems
    run WEIGHTS.m               %Performance and Uncertainty Weights
    run LFT_MODELING.m          %Making LFT from a Simulink file
    run NOMINAL_CONTROLLER.m    %Stablizing with a Hinf Controller - Without Uncertainty
    run INIT.m                  %Frequency band and blk's structure
    run ROBUSTNESS1.m           %Robust analysis first Hinf controller
    SelectedController = minreal(K{2});
    run RESULTS.m               %Simulation for selected robust control
    run WORST.m                 %Worst case test
    run NLPAR.m                 %Nonelinear closeloop with Kmiu
%%------------------------------------------------------------------------#

