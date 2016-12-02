
%% SET THE SCENARIO NAME

%used for saving the results
scenario_name = experiment_name;

%% CASE TO BE ANALYZED

case_study = 'case_buildingsim_paper';

%% OBJECTIVE AND THE TYPE OF OPTIMIZATION

%objectives
% 1: cost minimization
% 2: carbon minimization
objective = 1;

%select technologies and do sizing?
select_techs_and_do_sizing = 1;
include_installed_technologies = 0;

%% TIME VARIABLES

timestep = 'hours';
timesteps = 1:8760;
number_of_timesteps = length(timesteps);

%% ELECTRICITY GRID PARAMETERS

grid_connected_system = 1;
size_grid_connection = 0;
grid_connection_capacity = 1000000;

%% PRICE PARAMETERS

gas_price = 0.09;
carbon_price = 0;
interest_rate = 0.08;

dynamic_electricity_price = experiment_dynamic_electricity_price;
dynamic_grid_feed_in_price = experiment_dynamic_grid_feed_in_price;
different_grid_feed_in_price_for_renewables = experiment_different_grid_feed_in_price_for_renewables;
dynamic_grid_feed_in_price_for_renewables = experiment_dynamic_grid_feed_in_price_for_renewables;

grid_electricity_price = experiment_grid_electricity_price;
grid_electricity_feedin_price = experiment_grid_electricity_feedin_price;
grid_electricity_feedin_price_for_renewables = experiment_grid_electricity_feedin_price_for_renewables;

if dynamic_electricity_price == 1
    grid_electricity_price = csvread(strcat(experiment_path,'price_time_series\electricity_costs.csv'));
    xlswrite(strcat(source_path,'aimms_model\energy_hub\electricity_costs.xlsx'),grid_electricity_price,'electricity_costs');
end

if dynamic_feed_in_price == 1
    grid_electricity_feed_in_price = csvread(strcat(experiment_path,'price_time_series\electricity_feed_in_price.csv'));
    xlswrite(strcat(source_path,'aimms_model\energy_hub\electricity_feed_in_price.xlsx'),grid_electricity_feed_in_price,'price');
end

%% CARBON PARAMETERS

carbon_limit_boolean = 0;
carbon_limit = 0;
electricity_grid_carbon_factor = 0.137;
natural_gas_carbon_factor = 0.198;

%% CONSTRAINT OPTIONS

%storage initialization methods:
% 1: initialize the storage SOC to the minimum SOC
% 2: constrain the initial storage SOC to the same value as the end value
electrical_storage_initialization_method = 1; 
heat_storage_initialization_method = 2;
cool_storage_initialization_method = 2;
dhw_storage_initialization_method = 2;
anergy_storage_initialization_method = 2;