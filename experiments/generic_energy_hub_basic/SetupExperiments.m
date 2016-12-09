%% DESCRIPTION

% This is a simple example of a script for setting up experiments.  This
% script creates and executes a single experiment (model run).

% To execute your experiments, simply run this script.

%% CLEAR THE WORKSPACE

clear
clc

%% SET THE PATH

addpath(genpath('C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms'));

%set this path to the root of the project
cd('C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\');

%set this to the path of the experiment folder
experiment_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\experiments\generic_energy_hub_basic\';

%% DEFINE AND RUN THE EXPERIMENTS

%set here the values of the parameters that should be varied in your
%experiments

%the values of the varied parameters should be given the corresponding
%variable name in SetExperimentParameters.m.

experiment_name = 'Generic_energy_hub_basic_experiment';

%run the experiment
RunExperiment