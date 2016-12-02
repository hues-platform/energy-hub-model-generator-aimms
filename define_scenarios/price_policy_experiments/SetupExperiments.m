%% NOTES

% You've simplified the experiments relative to what is currently described
% in the paper.  This should be changed in the paper.

%% TODO

% Create a new branch of the github repository in which to make the changes

% Create a new case defined as described in the paper

% Check to see if the experiments as defined are capable of backing up what
% you stated in the abstract

% Calculate flat electricity price to be used (weighted avg of TOU values),
% and set in the experiment definitions below.

% Create the CSVs for dynamic (feed-in) pricing and add the relevant code
% to the experiment definitions below for reading in the values.

% Create elements to accommodate a dynamic grid feed-in_price and
% (dynamic) grid feed-in price for renewables.

% Create elements to accommodate net metering.

% Save the results in a folder named according to the experiment/scenario name.

% Test to make sure the dynamic feed-in pricing and net metering code are working

%% CLEAR THE WORKSPACE

clear
clc

%% SET THE PATH

%set this path to the root of the project
addpath(genpath('H:\projects\ModularEnergyHub\module_EHM_generation'));

%% FIT EXPERIMENTS

for fit_level = 0:5:30

    experiment_name = strcat('FIT_', num2str(fit_level));
    
    experiment_dynamic_electricity_price = 0;
    experiment_dynamic_grid_feed_in_price = 1;
    experiment_different_grid_feed_in_price_for_renewables = 1;
    experiment_dynamic_grid_feed_in_price_for_renewables = 0;

    experiment_grid_electricity_price = ???;
    experiment_grid_electricity_feedin_price = 0;
    experiment_grid_electricity_feedin_price_for_renewables = fit_level;
    
    experiment_implement_net_metering = 0;
    
    RunExperiment

end

%% FIP EXPERIMENTS

for fip_level = 0:5:30

    experiment_name = strcat('FIP_', num2str(fip_level));
    
    experiment_dynamic_electricity_price = 0;
    experiment_dynamic_grid_feed_in_price = 1;
    experiment_different_grid_feed_in_price_for_renewables = 1;
    experiment_dynamic_grid_feed_in_price_for_renewables = 1;

    experiment_grid_electricity_price = ???;
    experiment_grid_electricity_feedin_price = 0;
    experiment_grid_electricity_feedin_price_for_renewables = 0;
    
    experiment_implement_net_metering = 0;
    
    RunExperiment

end

%% NET METERING EXPERIMENTS

experiment_name = 'NetMetering';

experiment_dynamic_electricity_price = 0;
experiment_dynamic_grid_feed_in_price = 1;
experiment_different_grid_feed_in_price_for_renewables = 1;
experiment_dynamic_grid_feed_in_price_for_renewables = 0;

experiment_grid_electricity_price = ???;
experiment_grid_electricity_feedin_price = 0;
experiment_grid_electricity_feedin_price_for_renewables = 0;

experiment_implement_net_metering = 1;

RunExperiment


%% REAL-TIME PRICING EXPERIMENTS

experiment_name = 'RTP';

experiment_dynamic_electricity_price = 1;
experiment_dynamic_grid_feed_in_price = 1;
experiment_different_grid_feed_in_price_for_renewables = 0;
experiment_dynamic_grid_feed_in_price_for_renewables = 0;

experiment_grid_electricity_price = 0;
experiment_grid_electricity_feedin_price = 0;
experiment_grid_electricity_feedin_price_for_renewables = 0;

experiment_implement_net_metering = 0;

RunExperiment

%% TOU PRICING EXPERIMENTS

experiment_name = 'TOU';

experiment_dynamic_electricity_price = 1;
experiment_dynamic_grid_feed_in_price = 1;
experiment_different_grid_feed_in_price_for_renewables = 0;
experiment_dynamic_grid_feed_in_price_for_renewables = 0;

experiment_grid_electricity_price = 0;
experiment_grid_electricity_feedin_price = 0;
experiment_grid_electricity_feedin_price_for_renewables = 0;

experiment_implement_net_metering = 0;

RunExperiment

%% FLAT PRICING EXPERIMENTS

experiment_name = 'FlatPricing';

experiment_dynamic_electricity_price = 0;
experiment_dynamic_grid_feed_in_price = 1;
experiment_different_grid_feed_in_price_for_renewables = 0;
experiment_dynamic_grid_feed_in_price_for_renewables = 0;

experiment_grid_electricity_price = ???;
experiment_grid_electricity_feedin_price = 0;
experiment_grid_electricity_feedin_price_for_renewables = 0;

experiment_implement_net_metering = 0;

RunExperiment

%% DEFAULT CASE EXPERIMENTS