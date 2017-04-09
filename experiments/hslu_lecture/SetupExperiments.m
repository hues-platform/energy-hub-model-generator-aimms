%% DESCRIPTION

% USE THIS SCRIPT TO SET UP AND RUN THE CODE FOR YOUR EXERCISES
% EACH "%%" MARKS A NEW CODE SECTION.
% TO RUN A CODE SECTION, PUT OUR CURSOR IN THE RESPECTIVE SECTION AND CLICK "RUN SECTION" ABOVE.
% FOLLOW THE INSTRUCTIONS FOR EACH EXERCISE.

%% 1. CLEAR THE WORKSPACE AND SET THE DIRECTORIES (run this before each exercise)

clear
clc
experiment_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\experiments\generic_energy_hub_basic\';
project_root_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\';
cd(project_root_path);

%% 2. ADD DIRECTORIES TO THE MATLAB SEARCH PATH (run this once at the start)

addpath(genpath(strcat(project_root_path,'src')));
addpath(genpath(experiment_path));

%% EXERCISE 1

% Directions: 
% 1. Set the "experiment_path" and "project_root_path" variables in section 1 to the correct paths on your machine.
% 2. Run the code in sections 1 and 2 above (put cursor in the respective section and click "Run Section" in the toolbar at the top of the screen).
% 3. Run the code in this section.

experiment_name = 'Exercise_1';
SetExperimentParameters
RunExperiment

%% EXERCISE 2

% Directions:
% 1. Open the file experiments/hslu_lecture/case_data/installed_conversion_technologies.csv in Excel
% 2. Change the capacity of the gas boiler to ..., save and close.
% 3. Run the code in section 1 above, then run the code in this section.

experiment_name = 'Exercise_2';
SetExperimentParameters
RunExperiment

%% EXERCISE 3

% Directions:
% 1. Open the file experiments/hslu_lecture/case_data/installed_conversion_technologies.csv in Excel
% 2. Add a new technology called "CHP engine", with the following properties: 
% 3. Run the code in section 1 above, then run the code in this section.

experiment_name = 'Exercise_3';
SetExperimentParameters
RunExperiment

%% EXERCISE 4

% Directions:
% 1. Open the file experiments/hslu_lecture/SetExperimentParameters.m
% 2. Change the value of the variable "grid_electricity_price" to 0.10, and save the file.
% 3. Run the code in section 1 above, then run the code in this section.

experiment_name = 'Exercise_4';
SetExperimentParameters
RunExperiment

%% EXERCISE 5

% Directions:
% 1. Open the file experiments/hslu_lecture/SetExperimentParameters.m
% 2. Change the value of the variable "objective" to 2, and save the file.
% 3. Run the code in section 1 above, then run the code in this section.

experiment_name = 'Exercise_5';
SetExperimentParameters
RunExperiment

%% EXERCISE 6

% Directions:
% 1. Open the file experiments/hslu_lecture/SetExperimentParameters.m
% 2. Change the value of the variable "objective" back to 1.
% 3. Change the value of the variable "select_techs_and_do_sizing" to 1.
% 4. Change the value of the variable "include_installed_technologies" to 0, and save the file.
% 5. Run the code in section 1 above, then run the code in this section.

experiment_name = 'Exercise_6';
SetExperimentParameters
RunExperiment

%% EXERCISE 7

% Directions:
% 1. Open the file experiments/hslu_lecture/SetExperimentParameters.m
% 2. Change the value of the variable "grid_electricity_feedin_price_renewables" to ..., and save the file.
% 3. Run the code in section 1 above, then run the code in this section.

experiment_name = 'Exercise_7';
SetExperimentParameters
RunExperiment

%% EXERCISE 8

% Directions:
% 1. Open the file experiments/hslu_lecture/SetExperimentParameters.m
% 2. Change the value of the variable "objective" to 2, and save the file.
% 3. Run the code in section 1 above, then run the code in this section.

experiment_name = 'Exercise_8';
SetExperimentParameters
RunExperiment
