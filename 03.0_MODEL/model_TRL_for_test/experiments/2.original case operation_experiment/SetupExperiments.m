%% DESCRIPTION

% This script sets up expermints for assessing energy hub participation in electricity balancing markets.

%% CLEAR THE WORKSPACE

clear
clc

%% DEFINE THE PATHS

%set this to the path of the experiment folder
%experiment_path = 'C:\Users\Raphaela\Documents\GitHub\ehub-modeling-tool\experiments\2.original case operation_experiment\';
experiment_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\experiments\2.original case operation_experiment\';

%set this path to the root of the project
%project_root_path = 'C:\Users\Raphaela\Documents\GitHub\ehub-modeling-tool\';
project_root_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\';

cd(project_root_path);

%% ADD THE PATHS

addpath(genpath(strcat(project_root_path,'src')));
addpath(genpath(experiment_path));

%% DEFINE AND RUN THE EXPERIMENTS
%% Experiment 1

experiment_name = 'Electricity balancing market participation';

experiment_select_techs_and_do_sizing = 0;
experiment_include_installed_technologies = 1;

%set the experiment parameters and run the experiment
SetExperimentParameters
RunExperiment


%% Experiment n

%add another experiment here...