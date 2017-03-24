%% DESCRIPTION

% USE THIS SCRIPT TO SET UP AND RUN THE CODE FOR YOUR EXERCISES
% EACH "%%" MARKS A NEW CODE SECTION.
% TO RUN A CODE SECTION, PUT OUR CURSOR IN THE RESPECTIVE SECTION AND CLICK "RUN SECTION" ABOVE.

%% 1. CLEAR THE WORKSPACE AND SET THE DIRECTORIES (run this before each exercise)

clear
clc
experiment_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\experiments\generic_energy_hub_basic\';
project_root_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\';
cd(project_root_path);

%% 2. ADD DIRECTORIES TO THE MATLAB SEARCH PATH (run this once at the start)

addpath(genpath(strcat(project_root_path,'src')));
addpath(genpath(experiment_path));

%% 3. RUN THE EXPERIMENT

experiment_name = 'Suurstoffi_simple';
experiment_select_techs_and_do_sizing = 0;
experiment_include_installed_technologies = 1;
SetExperimentParameters
RunExperiment
