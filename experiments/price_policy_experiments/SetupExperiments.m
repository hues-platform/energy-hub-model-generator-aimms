%% NOTES

% You've simplified the experiments relative to what is currently described
% in the paper.  This should be changed in the paper.

% Now you assume that you don't get any compensation for
% feed-in from non-renewables.  This should be changed in the paper.

%% TODO

% Make the RTP network fee dependent on quantity not price.

% Create elements to accommodate a dynamic grid feed-in_price.

% Check the file paths in LoadTechnologies.m and LoadCase.m to make sure they're
% correct.  Quickly check the other m files as well.

% Save the results in a folder named according to the experiment/scenario name.

% Test to make sure the dynamic feed-in pricing and net metering code are working

% BEFORE MERGING WITH MAIN BRANCH:

% Fix the code for the test experiments and the generic energy hub basic
% experiment

% Check with Ashreeta before you merge to make sure you don't screw
% anything up that she's working on.

% Automatically output a text file with basic information about the run,
% which should go into the results folder.  This can then be read by the
% visualization code.

%% CLEAR THE WORKSPACE

clear
clc

%% SET THE PATH

%set this path to the root of the project
addpath(genpath('C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\src'));

%source path
source_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\src\';

%add the path to the experiment folder
experiment_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\experiments\price_policy_experiments\';

%% FIT EXPERIMENTS

for fit_level = 0:5:30
    
    copyfile(strcat(experiment_path,'technology_data\storage_technology_data_basic.csv'),strcat(experiment_path,'technology_data\storage_technology_data.csv'));

    experiment_name = strcat('FIT_', num2str(fit_level));
    
    experiment_dynamic_electricity_price = 0;
    experiment_dynamic_grid_feed_in_price = 0;

    experiment_grid_electricity_price = 0.214;
    experiment_grid_electricity_feed_in_price = fit_level;
    
    experiment_implement_net_metering = 0;
    
    RunExperiment

end

%% FIP EXPERIMENTS

for fip_level = 0:5:30
    
    copyfile(strcat(experiment_path,'technology_data\storage_technology_data_basic.csv'),strcat(experiment_path,'technology_data\storage_technology_data.csv'));
    
    spot_prices = csv_read(strcat(experiment_path,'price_time_series\electricity_spot_prices.csv'));
    fip_time_series = spot_prices + fip_level;
    csv_write((strcat(experiment_path,'price_time_series\electricity_feed_in_price.csv')),fip_time_series);

    experiment_name = strcat('FIP_', num2str(fip_level));
    
    experiment_dynamic_electricity_price = 0;
    experiment_dynamic_grid_feed_in_price = 1;

    experiment_grid_electricity_price = 0.214;
    experiment_grid_electricity_feedin_price = 0;
    
    experiment_implement_net_metering = 0;
    
    RunExperiment

end

%% NET METERING EXPERIMENTS

copyfile(strcat(experiment_path,'technology_data\storage_technology_data_withNM.csv'),strcat(experiment_path,'technology_data\storage_technology_data.csv'));

experiment_name = 'NetMetering';

experiment_dynamic_electricity_price = 0;
experiment_dynamic_grid_feed_in_price = 0;

experiment_grid_electricity_price = 0.214;
experiment_grid_electricity_feedin_price = 0;

experiment_implement_net_metering = 1;

RunExperiment


%% REAL-TIME PRICING EXPERIMENTS

copyfile(strcat(experiment_path,'technology_data\storage_technology_data_basic.csv'),strcat(experiment_path,'technology_data\storage_technology_data.csv'));

spot_prices = csv_read(strcat(experiment_path,'price_time_series\electricity_spot_prices.csv'));
electricity_tax = 0.03;
electricity_network_surcharge = 0.1 * (spot_prices - min(spot_prices)) / (max(spot_prices) - min(spot_prices)) + 0.05; %varies between 0.05 and 0.15 depending on the spot price
rtp_time_series = spot_prices + electricity_tax + electricity_network_surcharge;
csv_write((strcat(experiment_path,'price_time_series\electricity_costs.csv')),fip_time_series);

experiment_name = 'RTP';

experiment_dynamic_electricity_price = 1;
experiment_dynamic_grid_feed_in_price = 0;

experiment_grid_electricity_price = 0;
experiment_grid_electricity_feedin_price = 0;

experiment_implement_net_metering = 0;

RunExperiment

%% TOU PRICING EXPERIMENTS

copyfile(strcat(experiment_path,'technology_data\storage_technology_data_basic.csv'),strcat(experiment_path,'technology_data\storage_technology_data.csv'));

copyfile(strcat(experiment_path,'price_time_series\TOU_prices.csv'),strcat(experiment_path,'price_time_series\electricity_costs.csv'));

experiment_name = 'TOU';

experiment_dynamic_electricity_price = 1;
experiment_dynamic_grid_feed_in_price = 0;

experiment_grid_electricity_price = 0;
experiment_grid_electricity_feedin_price = 0;

experiment_implement_net_metering = 0;

RunExperiment

%% FLAT PRICING EXPERIMENTS

copyfile(strcat(experiment_path,'technology_data\storage_technology_data_basic.csv'),strcat(experiment_path,'technology_data\storage_technology_data.csv'));

experiment_name = 'FlatPricing';

experiment_dynamic_electricity_price = 0;
experiment_dynamic_grid_feed_in_price = 0;

experiment_grid_electricity_price = 0.214;
experiment_grid_electricity_feedin_price = 0;

experiment_implement_net_metering = 0;

RunExperiment

%%