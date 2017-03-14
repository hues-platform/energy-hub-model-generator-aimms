%% DESCRIPTION

% This is a simple example of a script for setting up experiments.  This script creates and executes a single experiment (model run).
% To execute your experiments, simply run this script.

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
%% Experiment 1 - with technology selection and sizing

%set here the values of the parameters that should be varied in your experiments
%the values of the varied parameters should be given the corresponding variable name in SetExperimentParameters.m.
% 
% experiment_name = 'Generic_energy_hub_experiment_with_sizing';
% 
% experiment_select_techs_and_do_sizing = 1;
% experiment_include_installed_technologies = 0;
% 
% %set the experiment parameters and run the experiment
% SetExperimentParameters
% RunExperiment

% %% Experiment 2 - without techonology selection and sizing

experiment_name = 'Generic_energy_hub_experiment_without_sizing';

experiment_select_techs_and_do_sizing = 0;
experiment_include_installed_technologies = 1;

%set the experiment parameters and run the experiment
SetExperimentParameters
RunExperiment


%% Experiment n

%add another experiment here...