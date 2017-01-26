%% LOAD CASE STUDY DATA

%% CLEAN UP THE INPUT FILES


rmdir('aimms_model\energy_hub\input_files','s');
mkdir('aimms_model\energy_hub\input_files');

%% LOAD DEMAND DATA

filename = strcat(experiment_path,'case_data\demand_data.csv');
[demand_data,demand_types,raw] = xlsread(filename);

%extract the demand data
demand_data = demand_data(11:end,:);
demand_types = demand_types(3,2:end);
unique_demand_types = unique(demand_types);

%determine the number of hubs
multiple_hubs = 0;
hubs = cell2mat(raw(4,2:end));
hub_list = sort(unique(hubs));
number_of_hubs = length(hub_list);
if number_of_hubs > 1
    multiple_hubs = 1;
end

%create the demand files
for d = demand_types
    relevant_columns = find(demand_types == d);
    relevant_demands = demand_data(:,relevant_columns);
    xlswrite(strcat('aimms_model\energy_hub\input_data\',d,'_demand.xlsx'),relevant_demands,'demand');
end

%% LOAD ENERGY INPUTS DATA

filename = strcat(experiment_path,'case_data\energy_inputs_data.csv');
[inputs_data,inputs_types,raw] = xlsread(filename);

inputs_data = inputs_data(11:end,:);
inputs_types = inputs_types(3,2:end);
hubs = cell2mat(raw(4,2:end));

consider_solar_inputs = 0;
solar_radiations = [];
if sum(strcmp('Solar',inputs_types)) > 0
    solar_inputs_columns = find(strcmp('Solar',inputs_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        solar_radiation = inputs_data(:,intersect(hub_columns,solar_inputs_columns));
        solar_radiations = horzcat(solar_radiations, solar_radiation);
    end
    if sum(sum(solar_radiations)) > 0
        consider_solar_inputs = 1;
        xlswrite('aimms_model\energy_hub\input_data\solar_inputs.xlsx',solar_radiations,'solar');
    end
end

%% LOAD DYNAMIC ELECTRICITY PRICE DATA

if dynamic_electricity_price == 1
    grid_electricity_price = csvread(strcat(experiment_path,'price_time_series\electricity_costs.csv'));
    xlswrite('aimms_model\energy_hub\input_data\electricity_costs.xlsx',grid_electricity_price,'electricity_costs');
end

if dynamic_grid_feed_in_price_renewables == 1
    grid_electricity_feedin_price_renewables = csvread(strcat(experiment_path,'price_time_series\electricity_feed_in_price_renewables.csv'));
    xlswrite('aimms_model\energy_hub\input_data\electricity_feed_in_price_renewables.xlsx',grid_electricity_feedin_price_renewables,'price');
end

if dynamic_grid_feed_in_price_nonrenewables == 1
    grid_electricity_feedin_price_nonrenewables = csvread(strcat(experiment_path,'price_time_series\electricity_feed_in_price_nonrenewables.csv'));
    xlswrite('aimms_model\energy_hub\input_data\electricity_feed_in_price_nonrenewables.xlsx',grid_electricity_feedin_price_nonrenewables,'price');
end

%% LOAD INSTALLED TECHNOLOGY DATA

if include_installed_technologies == 1

    %read the installed conversion technology data
    if exist(strcat(experiment_path,'case_data\installed_conversion_technologies.csv'),'file')==2
        filename = strcat(experiment_path,'case_data\installed_conversion_technologies.csv');
        [num,text,raw] = xlsread(filename);

        installed_technologies.conversion_techs_names = raw(1,2:end);
        installed_technologies.conversion_techs_outputs_1 = raw(2,2:end);
        installed_technologies.conversion_techs_outputs_2 = raw(3,2:end);
        installed_technologies.conversion_techs_inputs_1 = raw(4,2:end);
        installed_technologies.conversion_techs_inputs_2 = raw(5,2:end);
        installed_technologies.conversion_techs_efficiency = cell2mat(raw(6,1:end));
        installed_technologies.conversion_techs_min_part_load = cell2mat(raw(7,1:end));
        installed_technologies.conversion_techs_output_ratio = cell2mat(raw(8,1:end));
        installed_technologies.conversion_techs_input_ratio = cell2mat(raw(9,1:end));
        installed_technologies.conversion_techs_capacity = cell2mat(raw(10,1:end));
        installed_technologies.conversion_techs_node = cell2mat(raw(11,1:end));
    end

    %read the installed storage technology data
    if exist(strcat(experiment_path,'case_data\installed_storage_technologies.csv'),'file')==2
        filename = strcat(experiment_path,'case_data\installed_storage_technologies.csv');
        [num,text,raw] = xlsread(filename);

        installed_technologies.storage_techs_names = raw(1,2:end);
        installed_technologies.storage_techs_types = raw(2,2:end);
        installed_technologies.storage_techs_charging_efficiency = cell2mat(raw(3,2:end));
        installed_technologies.storage_techs_discharging_efficiency = cell2mat(raw(4,2:end));
        installed_technologies.storage_techs_decay = cell2mat(raw(5,2:end));
        installed_technologies.storage_techs_max_charging_rate = cell2mat(raw(6,2:end));
        installed_technologies.storage_techs_max_discharging_rate = cell2mat(raw(7,2:end));
        installed_technologies.storage_techs_min_state_of_charge = cell2mat(raw(8,2:end));
        installed_technologies.storage_techs_capacity = cell2mat(raw(12,2:end));
        installed_technologies.storage_techs_node = cell2mat(raw(13,2:end));

        %if min/max thermal storage temperatures are given, set the values
        if sum(~isnan(cell2mat(raw(9,2:end)))) > 0 && sum(~isnan(cell2mat(raw(10,2:end)))) > 0 && sum(~isnan(cell2mat(raw(11,2:end)))) > 0
            installed_technologies.storage_techs_min_temperature = cell2mat(raw(9,2:end));
            installed_technologies.storage_techs_max_temperature = cell2mat(raw(10,2:end));
            installed_technologies.storage_techs_specific_heat = cell2mat(raw(11,2:end));
        end
    end
end

%% LOAD NODE DATA

filename = strcat(experiment_path,'case_data\node_data.csv');
[data,text,raw] = xlsread(filename);

hubs = cell2mat(raw(1,2:end));

%set the value of the roof areas
%TODO: this is a stupidly inefficient way to do this
if ~isnan(cell2mat(raw(3,2:end)))
    roof_areas_unsorted = data(3,:);
    for h = sort(unique(hubs))
        roof_areas_sorted(h) = roof_areas_unsorted(find(hubs == h));
    end
end
roof_areas = roof_areas_sorted;

%set the value of the floor areas
%TODO: this is a stupidly inefficient way to do this
% if ~isnan(cell2mat(raw(6,2:end)))
%     floor_areas_unsorted = data(6,:);
%     for h = sort(unique(hubs))
%         floor_areas_sorted(h) = floor_areas_unsorted(find(hubs == h));
%     end
% end
% floor_areas = floor_areas_sorted;

%% LOAD NETWORK DATA

if multiple_hubs == 1
    
    %read the installed network technology data
    if exist(strcat(experiment_path,'case_data\installed_network_technologies.csv'),'file')==2 && exist(strcat(experiment_path,'case_data\network_data.csv'),'file')==2
        
        filename = strcat(experiment_path,'case_data\installed_network_technologies.csv');
        [num,text,raw] = xlsread(filename);

        installed_technologies.network_techs_names = raw(1,2:end);
        installed_technologies.network_techs_types = raw(2,2:end);
        installed_technologies.network_techs_capacities = cell2mat(raw(3,2:end));
        installed_technologies.network_techs_losses = cell2mat(raw(4,2:end));
        installed_technologies.network_techs_links = cell2mat(raw(5,2:end));
        
        filename = strcat(experiment_path,'case_data\network_data.csv');
        [data,text,raw] = xlsread(filename);

        links = cell2mat(raw(1,2:end));
        links_node1 = cell2mat(raw(2,2:end));
        links_node2 = cell2mat(raw(3,2:end));
        links_length = cell2mat(raw(4,2:end));
    end
end