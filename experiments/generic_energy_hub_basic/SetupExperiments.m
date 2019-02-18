%% DESCRIPTION

% This is a simple example of a script for setting up experiments.  This script creates and executes a single experiment (model run).
% To execute your experiments, simply run this script.

%% CLEAR THE WORKSPACE

clear
clc

%% SET THE DIRECTORIES

experiment_path = 'D:\Surfdrive\Modelleren\EnergyHub\ehub-modeling-tool\experiments\generic_energy_hub_basic\';
project_root_path = 'D:\Surfdrive\Modelleren\EnergyHub\ehub-modeling-tool\';
aimms_executable_path = 'C:\Program Files (x86)\AIMMS\IFA\Aimms\4.62.1.4-x64-VS2017\Bin\aimms.exe';
analysis_scripts_path = 'D:\Surfdrive\Modelleren\EnergyHub\ehub-modeling-tool\analysis_scripts\';

cd(project_root_path);

%% ADD DIRECTORIES TO THE MATLAB SEARCH PATH

addpath(genpath(strcat(project_root_path,'src')));
addpath(genpath(experiment_path));

%% DEFINE AND RUN THE EXPERIMENTS
%% Experiment 1 - with technology selection and sizing

%set here the values of the parameters that should be varied in your experiments
%the values of the varied parameters should be given the corresponding variable name in SetExperimentParameters.m.

experiment_name = 'Generic_energy_hub_experiment_with_sizing';

experiment_select_techs_and_do_sizing = 1;
experiment_include_installed_technologies = 0;

%set the experiment parameters and run the experiment
SetExperimentParameters
RunExperiment

%% Experiment 2 - without techonology selection and sizing

experiment_name = 'Generic_energy_hub_experiment_without_sizing';

experiment_select_techs_and_do_sizing = 0;
experiment_include_installed_technologies = 1;

%set the experiment parameters and run the experiment
SetExperimentParameters
RunExperiment


%% Experiment n

%add another experiment here...