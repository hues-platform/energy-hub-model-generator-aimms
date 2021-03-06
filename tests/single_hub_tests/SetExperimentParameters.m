%% DESCRIPTION

% This file sets the parameters for an experiment. Values may be manually
% set here, or dynamically set in SetupExperiments.m

%% SET THE SCENARIO NAME

%used for saving the results
scenario_name = experiment_name;

%% CASE TO BE ANALYZED

case_study = 'generic_energy_hub';

%% OBJECTIVE AND THE TYPE OF OPTIMIZATION

%objectives
% 1: cost minimization
% 2: carbon minimization
objective = 1;

%select technologies and do sizing?
select_techs_and_do_sizing = experiment_select_techs_and_do_sizing;
include_installed_technologies = experiment_include_installed_technologies;

%% TIME VARIABLES

timestep = 'hours';
timesteps = 1:24;
number_of_timesteps = length(timesteps);

%% ELECTRICITY GRID PARAMETERS

grid_connected_system = 1;
size_grid_connection = 0;
enforce_capacity_constraints_of_grid_connection = 0;
allow_grid_exports_from_storage = 1;

%only used if the grid connection is not being sized
grid_connection_capacity = 1000000;
grid_connection_node = 1; %only used in case of multi-hub system

%only used if the grid connection is being sized
grid_initial_connection_cost_per_kW = 0;
grid_initial_connection_cost_fixed = 0;
grid_connection_cost_per_kW = 0;
grid_connection_cost_fixed = 0;
grid_min_connection_capacity = 1000000;
grid_max_connection_capacity = 1000000;

%% PRICE PARAMETERS

gas_price = 0.09;
carbon_price = 0;
interest_rate = 0.08;

dynamic_electricity_price = 0;
dynamic_grid_feed_in_price_renewables = 0;
dynamic_grid_feed_in_price_nonrenewables = 0;

grid_electricity_price = 0.24;
grid_electricity_feedin_price_renewables = 0.14;
grid_electricity_feedin_price_nonrenewables = 0.14;

implement_net_metering = 0;

%% CARBON PARAMETERS

carbon_limit_boolean = 0;
carbon_limit = 0;
electricity_grid_carbon_factor = 0.137;
natural_gas_carbon_factor = 0.198;

%% CONSTRAINT OPTIONS

%storage initialization methods:
% 1: initialize the storage SOC to the minimum SOC
% 2: constrain the initial storage SOC to the same value as the end value
storage_initialization_method = 1; 

%% RUN OPTIONS

%set to 1 to execute the energy hub model automatically
%set to 0 if you want to run the energy hub model manually
execute_energy_hub_model = 0;