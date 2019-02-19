%% NOTES

% You've simplified the experiments relative to what is currently described
% in the paper.  This should be changed in the paper.

% Now you assume that you don't get any compensation for
% feed-in from non-renewables.  This should be changed in the paper.

%% TODO

% BEFORE MERGING WITH MAIN BRANCH:

% Fix the code for the test experiments and the generic energy hub basic
% experiment

% Make sure you're uploading only the necessary files (i.e. not all the
% extraneous aimms files.

% Check with Ashreeta before you merge to make sure you don't screw
% anything up that she's working on.

% Automatically output a text file with basic information about the run,
% which should go into the results folder.  This can then be read by the
% visualization code.

%% CLEAR THE WORKSPACE

clear
clc

%% SET THE PATH

addpath(genpath('C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\src'));
addpath(genpath('C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\experiments\price_policy_experiments'));

%set this path to the root of the project
cd('C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\');

%add the path to the experiment folder
experiment_path = 'C:\Users\boa\Documents\Repositories_Github\energy-hub-model-generator-aimms\experiments\price_policy_experiments\';

%% FIT EXPERIMENTS

for fit_level = 0.19
%for fit_level = 0.0:0.05:0.30

    experiment_name = strcat('FIT_', num2str(fit_level));
    
    experiment_dynamic_electricity_price = 0;
    experiment_dynamic_grid_feed_in_price_renewables = 0;
    experiment_dynamic_grid_feed_in_price_nonrenewables = 0;

    experiment_grid_electricity_price = 0.214;
    experiment_grid_electricity_feedin_price_renewables = fit_level;
    experiment_grid_electricity_feedin_price_nonrenewables = 0;
    
    experiment_implement_net_metering = 0;
    
    SetExperimentParameters
    RunExperiment

end

%% FIP EXPERIMENTS

for fip_level = 0.19
%for fip_level = 0.0:0.05:0.30
    
    spot_prices = csvread(strcat(experiment_path,'price_time_series\electricity_spot_prices.csv'));
    fip_time_series = spot_prices + fip_level;
    fip_time_series = fip_time_series * fip_level / mean(fip_time_series); %scale the average to that of the FIT level
    csvwrite((strcat(experiment_path,'price_time_series\electricity_feed_in_price_renewables.csv')),fip_time_series);

    experiment_name = strcat('FIP_', num2str(fip_level));
    
    experiment_dynamic_electricity_price = 0;
    experiment_dynamic_grid_feed_in_price_renewables = 1;
    experiment_dynamic_grid_feed_in_price_nonrenewables = 0;

    experiment_grid_electricity_price = 0.214;
    experiment_grid_electricity_feedin_price_renewables = 0;
    experiment_grid_electricity_feedin_price_nonrenewables = 0;
    
    experiment_implement_net_metering = 0;
    
    SetExperimentParameters
    RunExperiment

end

%% NET METERING EXPERIMENTS

experiment_name = 'NetMetering';

experiment_dynamic_electricity_price = 0;
experiment_dynamic_grid_feed_in_price_renewables = 0;
experiment_dynamic_grid_feed_in_price_nonrenewables = 0;

experiment_grid_electricity_price = 0.214;
experiment_grid_electricity_feedin_price_renewables = 0;
experiment_grid_electricity_feedin_price_nonrenewables = 0;

experiment_implement_net_metering = 1;

SetExperimentParameters
RunExperiment


%% REAL-TIME PRICING EXPERIMENTS

spot_prices = csvread(strcat(experiment_path,'price_time_series\electricity_spot_prices.csv'));
spot_quantities = csvread(strcat(experiment_path,'price_time_series\electricity_spot_quantities.csv'));
electricity_tax = 0.03;
electricity_network_surcharge = 0.1 * (spot_quantities - min(spot_quantities)) / (max(spot_quantities) - min(spot_quantities)) + 0.05; %varies between 0.05 and 0.15 depending on the spot quantity
rtp_time_series = spot_prices + electricity_tax + electricity_network_surcharge;
rtp_time_series = rtp_time_series * 0.214 / mean(rtp_time_series); %scale the average to that of the flat price

csvwrite((strcat(experiment_path,'price_time_series\electricity_costs.csv')),rtp_time_series);

experiment_name = 'RTP';

experiment_dynamic_electricity_price = 1;
experiment_dynamic_grid_feed_in_price_renewables = 0;
experiment_dynamic_grid_feed_in_price_nonrenewables = 0;

experiment_grid_electricity_price = 0;
experiment_grid_electricity_feedin_price_renewables = 0.19;
experiment_grid_electricity_feedin_price_nonrenewables = 0;

experiment_implement_net_metering = 0;

SetExperimentParameters
RunExperiment

%% TOU PRICING EXPERIMENTS

copyfile(strcat(experiment_path,'price_time_series\TOU_prices.csv'),strcat(experiment_path,'price_time_series\electricity_costs.csv'));

experiment_name = 'TOU';

experiment_dynamic_electricity_price = 1;
experiment_dynamic_grid_feed_in_price_renewables = 0;
experiment_dynamic_grid_feed_in_price_nonrenewables = 0;

experiment_grid_electricity_price = 0;
experiment_grid_electricity_feedin_price_renewables = 0.19;
experiment_grid_electricity_feedin_price_nonrenewables = 0;

experiment_implement_net_metering = 0;

SetExperimentParameters
RunExperiment

%% FLAT PRICING EXPERIMENTS

experiment_name = 'FlatPricing';

experiment_dynamic_electricity_price = 0;
experiment_dynamic_grid_feed_in_price_renewables = 0;
experiment_dynamic_grid_feed_in_price_nonrenewables = 0;

experiment_grid_electricity_price = 0.214;
experiment_grid_electricity_feedin_price_renewables = 0.19;
experiment_grid_electricity_feedin_price_nonrenewables = 0;

experiment_implement_net_metering = 0;

SetExperimentParameters
RunExperiment

%% COMBINED NET METERING / TOU EXPERIMENT

experiment_name = 'Combined_NM_TOU';

copyfile(strcat(experiment_path,'price_time_series\TOU_prices.csv'),strcat(experiment_path,'price_time_series\electricity_costs.csv'));

experiment_dynamic_electricity_price = 1;
experiment_dynamic_grid_feed_in_price_renewables = 0;
experiment_dynamic_grid_feed_in_price_nonrenewables = 0;

experiment_grid_electricity_price = 0;
experiment_grid_electricity_feedin_price_renewables = 0;
experiment_grid_electricity_feedin_price_nonrenewables = 0;

experiment_implement_net_metering = 1;

SetExperimentParameters
RunExperiment
