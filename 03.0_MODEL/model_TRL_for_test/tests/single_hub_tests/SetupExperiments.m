%% DESCRIPTION

%this is a testing script for a single hub system

%% CLEAR THE WORKSPACE

clear
clc

%% SET THE PATH

%set this to the path of the experiment folder
experiment_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\tests\single_hub_tests\';

%set this path to the root of the project
project_root_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\';

%add some paths
addpath(genpath(strcat(project_root_path,'src')));
addpath(genpath(experiment_path));
cd(project_root_path);

%% DEFINE AND RUN THE EXPERIMENTS
%% Single hub test without sizing

experiment_name = 'Single_hub_test_no_sizing';

experiment_select_techs_and_do_sizing = 0;
experiment_include_installed_technologies = 1;

SetExperimentParameters
RunExperiment

%% Single hub test with sizing

experiment_name = 'Single_hub_test_with_sizing';

experiment_select_techs_and_do_sizing = 1;
experiment_include_installed_technologies = 0;

SetExperimentParameters
RunExperiment
