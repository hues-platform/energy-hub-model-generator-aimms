%% LOAD THE TECHNOLOGY DATA

if select_techs_and_do_sizing == 1

    %read the conversion technology data
    filename = strcat(experiment_path,'technology_data\conversion_technology_data.csv');
    [num,text,raw] = xlsread(filename);

    technologies.conversion_techs_names = raw(1,2:end);
    technologies.conversion_techs_outputs_1 = raw(2,2:end);
    technologies.conversion_techs_outputs_2 = raw(3,2:end);
    technologies.conversion_techs_inputs_1 = raw(4,2:end);
    technologies.conversion_techs_inputs_2 = raw(5,2:end);
    technologies.conversion_techs_lifetime = cell2mat(raw(6,2:end));
    technologies.conversion_techs_capital_cost_variable = cell2mat(raw(7,2:end));
    technologies.conversion_techs_capital_cost_fixed = cell2mat(raw(8,2:end));
    technologies.conversion_techs_OM_cost_variable = cell2mat(raw(9,2:end));
    technologies.conversion_techs_OM_cost_fixed = cell2mat(raw(10,2:end));
    technologies.conversion_techs_efficiency = cell2mat(raw(11,2:end));
    technologies.conversion_techs_min_part_load = cell2mat(raw(12,2:end));
    technologies.conversion_techs_output_ratio = cell2mat(raw(13,2:end));
    technologies.conversion_techs_input_ratio = cell2mat(raw(14,2:end));
    technologies.conversion_techs_min_capacity = cell2mat(raw(15,2:end));
    technologies.conversion_techs_max_capacity = cell2mat(raw(16,2:end));

    % read the storage technology data
    filename = strcat(experiment_path,'technology_data\storage_technology_data.csv');
    [num,text,raw] = xlsread(filename);

    technologies.storage_techs_names = raw(1,2:end);
    technologies.storage_techs_types = raw(2,2:end);
    technologies.storage_techs_lifetime = num(1,1:end);
    technologies.storage_techs_capital_cost_variable = num(2,1:end);
    technologies.storage_techs_capital_cost_fixed = num(3,1:end);
    technologies.storage_techs_charging_efficiency = num(4,1:end);
    technologies.storage_techs_discharging_efficiency = num(5,1:end);
    technologies.storage_techs_decay = num(6,1:end);
    technologies.storage_techs_max_charging_rate = num(7,1:end);
    technologies.storage_techs_max_discharging_rate = num(8,1:end);
    technologies.storage_techs_min_state_of_charge = num(9,1:end);
    technologies.storage_techs_min_capacity = num(10,1:end);
    technologies.storage_techs_max_capacity = num(11,1:end);

    %if min/max thermal storage temperatures are given, set the values
    if sum(~isnan(cell2mat(raw(14,2:end)))) > 0 && sum(~isnan(cell2mat(raw(15,2:end)))) > 0 && sum(~isnan(cell2mat(raw(16,2:end)))) > 0
        technologies.storage_techs_min_temperature = cell2mat(raw(14,2:end));
        technologies.storage_techs_max_temperature = cell2mat(raw(15,2:end));
        technologies.storage_techs_specific_heat = cell2mat(raw(16,2:end));
    end
    
else
    
    %create empty conversion technology variables
    technologies.conversion_techs_names = [];
    technologies.conversion_techs_outputs_1 = [];
    technologies.conversion_techs_outputs_2 = [];
    technologies.conversion_techs_inputs_1 = [];
    technologies.conversion_techs_inputs_2 = [];
    technologies.conversion_techs_lifetime = [];
    technologies.conversion_techs_capital_cost_variable = [];
    technologies.conversion_techs_capital_cost_fixed = [];
    technologies.conversion_techs_OM_cost_variable = [];
    technologies.conversion_techs_OM_cost_fixed = [];
    technologies.conversion_techs_efficiency = [];
    technologies.conversion_techs_min_part_load = [];
    technologies.conversion_techs_output_ratio = [];
    technologies.conversion_techs_input_ratio = [];
    technologies.conversion_techs_min_capacity = [];
    technologies.conversion_techs_max_capacity = [];
    
    %create empty storage technology variables
    technologies.storage_techs_names = [];
    technologies.storage_techs_types = [];
    technologies.storage_techs_lifetime = [];
    technologies.storage_techs_capital_cost_variable = [];
    technologies.storage_techs_capital_cost_fixed = [];
    technologies.storage_techs_charging_efficiency = [];
    technologies.storage_techs_discharging_efficiency = [];
    technologies.storage_techs_decay = [];
    technologies.storage_techs_max_charging_rate = [];
    technologies.storage_techs_max_discharging_rate = [];
    technologies.storage_techs_min_state_of_charge = [];
    technologies.storage_techs_min_capacity = [];
    technologies.storage_techs_max_capacity = [];
    
end

technologies_for_selection_and_sizing = technologies; %used for determining whether to use simplified storage representation or not.

%% ADD THE INSTALLED TECHNOLOGIES

%if there are installed conversion technologies
if include_installed_technologies == 1
    if exist(strcat(experiment_path,'case_data\installed_conversion_technologies.csv'),'file')==2

        %add the installed energy conversion technologies
        number_of_installed_conversion_techs = length(installed_technologies.conversion_techs_names);

        technologies.conversion_techs_names = horzcat(technologies.conversion_techs_names,installed_technologies.conversion_techs_names);
        technologies.conversion_techs_outputs_1 = horzcat(technologies.conversion_techs_outputs_1,installed_technologies.conversion_techs_outputs_1);
        technologies.conversion_techs_outputs_2 = horzcat(technologies.conversion_techs_outputs_2,installed_technologies.conversion_techs_outputs_2);
        technologies.conversion_techs_inputs_1 = horzcat(technologies.conversion_techs_inputs_1,installed_technologies.conversion_techs_inputs_1);
        technologies.conversion_techs_inputs_2 = horzcat(technologies.conversion_techs_inputs_2,installed_technologies.conversion_techs_inputs_2);
        technologies.conversion_techs_lifetime = horzcat(technologies.conversion_techs_lifetime,zeros(1,number_of_installed_conversion_techs));
        technologies.conversion_techs_capital_cost_variable = horzcat(technologies.conversion_techs_capital_cost_variable,zeros(1,number_of_installed_conversion_techs));
        technologies.conversion_techs_capital_cost_fixed = horzcat(technologies.conversion_techs_capital_cost_fixed,zeros(1,number_of_installed_conversion_techs));
        technologies.conversion_techs_OM_cost_variable = horzcat(technologies.conversion_techs_OM_cost_variable,zeros(1,number_of_installed_conversion_techs));
        technologies.conversion_techs_OM_cost_fixed = horzcat(technologies.conversion_techs_OM_cost_fixed,zeros(1,number_of_installed_conversion_techs));
        technologies.conversion_techs_efficiency = horzcat(technologies.conversion_techs_efficiency,installed_technologies.conversion_techs_efficiency);
        technologies.conversion_techs_min_part_load = horzcat(technologies.conversion_techs_min_part_load,installed_technologies.conversion_techs_min_part_load);
        technologies.conversion_techs_output_ratio = horzcat(technologies.conversion_techs_output_ratio,installed_technologies.conversion_techs_output_ratio);
        technologies.conversion_techs_input_ratio = horzcat(technologies.conversion_techs_input_ratio,installed_technologies.conversion_techs_input_ratio);
        technologies.conversion_techs_min_capacity = horzcat(technologies.conversion_techs_min_capacity,installed_technologies.conversion_techs_capacity);
        technologies.conversion_techs_max_capacity = horzcat(technologies.conversion_techs_max_capacity,installed_technologies.conversion_techs_capacity);
    end

    %if there are installed storage technologies
    if exist(strcat(experiment_path,'case_data\installed_storage_technologies.csv'),'file')==2

        %add the installed energy storage technologies
        number_of_installed_storage_techs = length(installed_technologies.storage_techs_names);

        technologies.storage_techs_names = horzcat(technologies.storage_techs_names,installed_technologies.storage_techs_names);
        technologies.storage_techs_types = horzcat(technologies.storage_techs_types,installed_technologies.storage_techs_types);
        technologies.storage_techs_lifetime = horzcat(technologies.storage_techs_lifetime,zeros(1,number_of_installed_storage_techs));
        technologies.storage_techs_capital_cost_variable = horzcat(technologies.storage_techs_capital_cost_variable,zeros(1,number_of_installed_storage_techs));
        technologies.storage_techs_capital_cost_fixed = horzcat(technologies.storage_techs_capital_cost_fixed,zeros(1,number_of_installed_storage_techs));
        technologies.storage_techs_charging_efficiency = horzcat(technologies.storage_techs_charging_efficiency,installed_technologies.storage_techs_charging_efficiency);
        technologies.storage_techs_discharging_efficiency = horzcat(technologies.storage_techs_discharging_efficiency,installed_technologies.storage_techs_discharging_efficiency);
        technologies.storage_techs_decay = horzcat(technologies.storage_techs_decay,installed_technologies.storage_techs_decay);
        technologies.storage_techs_max_charging_rate = horzcat(technologies.storage_techs_max_charging_rate,installed_technologies.storage_techs_max_charging_rate);
        technologies.storage_techs_max_discharging_rate = horzcat(technologies.storage_techs_max_discharging_rate,installed_technologies.storage_techs_max_discharging_rate);
        technologies.storage_techs_min_state_of_charge = horzcat(technologies.storage_techs_min_state_of_charge,installed_technologies.storage_techs_min_state_of_charge);
        technologies.storage_techs_min_capacity = horzcat(technologies.storage_techs_min_capacity,installed_technologies.storage_techs_capacity);
        technologies.storage_techs_max_capacity = horzcat(technologies.storage_techs_max_capacity,installed_technologies.storage_techs_capacity);

        %if min/max thermal storage temperatures are given, set the values
        if exist('installed_technologies.storage_techs_min_temperature','var') == 1 && exist('installed_technologies.storage_techs_max_temperature','var') == 1 && exist('installed_technologies.storage_techs_specific_heat','var') == 1
            technologies.storage_techs_min_temperature = horzcat(technologies.storage_techs_min_temperature,installed_technologies.storage_techs_min_temperature);
            technologies.storage_techs_max_temperature = horzcat(technologies.storage_techs_max_temperature,installed_technologies.storage_techs_max_temperature);
            technologies.storage_techs_specific_heat = horzcat(technologies.storage_techs_specific_heat,installed_technologies.storage_techs_specific_heat);
        end
    end
end

%% ADD THE ELECTRICITY GRID

%add the electricity grid properties to the conversion technology data
if grid_connected_system == 1
    if size_grid_connection == 1

        technologies.conversion_techs_names(end+1) = {'Grid'};
        technologies.conversion_techs_outputs_1(end+1) = {'Elec'};
        technologies.conversion_techs_outputs_2(end+1) = {NaN};
        technologies.conversion_techs_inputs_1(end+1) = {'Grid_electricity'};
        technologies.conversion_techs_inputs_2(end+1) = {NaN};
        technologies.conversion_techs_lifetime(end+1) = 0;
        technologies.conversion_techs_capital_cost_variable(end+1) = grid_initial_connection_cost_per_kW;
        technologies.conversion_techs_capital_cost_fixed(end+1) = grid_initial_connection_cost_fixed;
        technologies.conversion_techs_OM_cost_variable(end+1) = grid_connection_cost_per_kW;
        technologies.conversion_techs_OM_cost_fixed(end+1) = grid_connection_cost_fixed;
        technologies.conversion_techs_efficiency(end+1) = 1.0;
        technologies.conversion_techs_min_part_load(end+1) = 0;
        technologies.conversion_techs_output_ratio(end+1) = 0;
        technologies.conversion_techs_input_ratio(end+1) = 0;
        technologies.conversion_techs_min_capacity(end+1) = grid_min_connection_capacity;
        technologies.conversion_techs_max_capacity(end+1) = grid_max_connection_capacity;

    else

        technologies.conversion_techs_names(end+1) = {'Grid'};
        technologies.conversion_techs_outputs_1(end+1) = {'Elec'};
        technologies.conversion_techs_outputs_2(end+1) = {NaN};
        technologies.conversion_techs_inputs_1(end+1) = {'Grid_electricity'};
        technologies.conversion_techs_inputs_2(end+1) = {NaN};
        technologies.conversion_techs_lifetime(end+1) = 0;
        technologies.conversion_techs_capital_cost_variable(end+1) = 0;
        technologies.conversion_techs_capital_cost_fixed(end+1) = 0;
        technologies.conversion_techs_OM_cost_variable(end+1) = 0;
        technologies.conversion_techs_OM_cost_fixed(end+1) = 0;
        technologies.conversion_techs_efficiency(end+1) = 1.0;
        technologies.conversion_techs_min_part_load(end+1) = 0;
        technologies.conversion_techs_output_ratio(end+1) = 0;
        technologies.conversion_techs_input_ratio(end+1) = 0;
        technologies.conversion_techs_min_capacity(end+1) = grid_connection_capacity;
        technologies.conversion_techs_max_capacity(end+1) = grid_connection_capacity;

    end
end

%% ADD NET METERING STORAGE

if implement_net_metering == 1
    technologies.storage_techs_names(end+1) = {'Net_meter'};
    technologies.storage_techs_types(end+1) = {'Elec'};
    technologies.storage_techs_lifetime(end+1) = 100;
    technologies.storage_techs_capital_cost_variable(end+1) = 0;
    technologies.storage_techs_capital_cost_fixed(end+1) = 0;
    technologies.storage_techs_charging_efficiency(end+1) = 1;
    technologies.storage_techs_discharging_efficiency(end+1) = 1;
    technologies.storage_techs_decay(end+1) = 0;
    technologies.storage_techs_max_charging_rate(end+1) = 1;
    technologies.storage_techs_max_discharging_rate(end+1) = 1;
    technologies.storage_techs_min_state_of_charge(end+1) = 0;
    technologies.storage_techs_min_capacity(end+1) = 100000;
    technologies.storage_techs_max_capacity(end+1) = 100000;
end

%% ADD OPERATING COSTS

%add operating costs to the conversion technology data
technologies.conversion_techs_operating_costs = [];
for t=1:length(technologies.conversion_techs_names)
    if strcmp(technologies.conversion_techs_names(t),'Grid')
        technologies.conversion_techs_operating_costs(t) = 0; %this isn't used
    elseif strcmp(technologies.conversion_techs_inputs_1(t),'Gas')
        technologies.conversion_techs_operating_costs(t) = gas_price;
    else
        technologies.conversion_techs_operating_costs(t) = 0;
    end
end

%% ADD CARBON FACTORS

%add carbon factors to the conversion technology data
technologies.conversion_techs_carbon_factors = [];
for t=1:length(technologies.conversion_techs_names)
    if strcmp(technologies.conversion_techs_names(t),'Grid')
        technologies.conversion_techs_carbon_factors(t) = electricity_grid_carbon_factor;
    elseif strcmp(technologies.conversion_techs_inputs_1(t),'Gas')
        technologies.conversion_techs_carbon_factors(t) = natural_gas_carbon_factor;
    else
        technologies.conversion_techs_carbon_factors(t) = 0;
    end
end

%% CLEAN UP THE STRINGS

%remove spaces from the names/properties of the conversion and storage technologies
technologies.conversion_techs_names = strrep(technologies.conversion_techs_names,' ','_');
technologies.storage_techs_names = strrep(technologies.storage_techs_names,' ','_');

%remove spaces from the names/properties of the installed conversion and storage technologies
if include_installed_technologies == 1
    
    %if there are installed conversion technologies
    if exist(strcat(experiment_path,'case_data\installed_conversion_technologies.csv'),'file')==2
        installed_technologies.conversion_techs_names = strrep(installed_technologies.conversion_techs_names,' ','_');
    end

    %if there are installed storage technologies
    if exist(strcat(experiment_path,'case_data\installed_storage_technologies.csv'),'file')==2
        installed_technologies.storage_techs_names = strrep(installed_technologies.storage_techs_names,' ','_');
    end
end

%% CREATE TECHNOLOGY LISTS WHICH ONLY INCLUDE UNIQUE TECHNOLOGIES
%this is necessary because, when multiple hubs are present, it's useful to be able to get a list of technologies that doesn't repeat any single technology more than once.

[C,ia,ic] = unique(technologies.conversion_techs_names);
unique_conversion_techs_indices = ia;
unique_technologies.conversion_techs_names = technologies.conversion_techs_names(unique_conversion_techs_indices);
unique_technologies.conversion_techs_outputs_1 = technologies.conversion_techs_outputs_1(unique_conversion_techs_indices);
unique_technologies.conversion_techs_outputs_2 = technologies.conversion_techs_outputs_2(unique_conversion_techs_indices);
unique_technologies.conversion_techs_inputs_1 = technologies.conversion_techs_inputs_1(unique_conversion_techs_indices);
unique_technologies.conversion_techs_inputs_2 = technologies.conversion_techs_inputs_2(unique_conversion_techs_indices);
unique_technologies.conversion_techs_lifetime = technologies.conversion_techs_lifetime(unique_conversion_techs_indices);
unique_technologies.conversion_techs_capital_cost_variable = technologies.conversion_techs_capital_cost_variable(unique_conversion_techs_indices);
unique_technologies.conversion_techs_capital_cost_fixed = technologies.conversion_techs_capital_cost_fixed(unique_conversion_techs_indices);
unique_technologies.conversion_techs_OM_cost_variable = technologies.conversion_techs_OM_cost_variable(unique_conversion_techs_indices);
unique_technologies.conversion_techs_OM_cost_fixed = technologies.conversion_techs_OM_cost_fixed(unique_conversion_techs_indices);
unique_technologies.conversion_techs_efficiency = technologies.conversion_techs_efficiency(unique_conversion_techs_indices);
unique_technologies.conversion_techs_min_part_load = technologies.conversion_techs_min_part_load(unique_conversion_techs_indices);
unique_technologies.conversion_techs_output_ratio = technologies.conversion_techs_output_ratio(unique_conversion_techs_indices);
unique_technologies.conversion_techs_input_ratio = technologies.conversion_techs_input_ratio(unique_conversion_techs_indices);
unique_technologies.conversion_techs_min_capacity = technologies.conversion_techs_min_capacity(unique_conversion_techs_indices);
unique_technologies.conversion_techs_max_capacity = technologies.conversion_techs_max_capacity(unique_conversion_techs_indices);
unique_technologies.conversion_techs_operating_costs = technologies.conversion_techs_operating_costs(unique_conversion_techs_indices);
unique_technologies.conversion_techs_carbon_factors = technologies.conversion_techs_carbon_factors(unique_conversion_techs_indices);

[C,ia,ic] = unique(technologies.storage_techs_names);
unique_storage_techs_indices = ia;
unique_technologies.storage_techs_names = technologies.storage_techs_names(unique_storage_techs_indices);
unique_technologies.storage_techs_types = technologies.storage_techs_types(unique_storage_techs_indices);
unique_technologies.storage_techs_lifetime = technologies.storage_techs_lifetime(unique_storage_techs_indices);
unique_technologies.storage_techs_capital_cost_variable = technologies.storage_techs_capital_cost_variable(unique_storage_techs_indices);
unique_technologies.storage_techs_capital_cost_fixed = technologies.storage_techs_capital_cost_fixed(unique_storage_techs_indices);
unique_technologies.storage_techs_charging_efficiency = technologies.storage_techs_charging_efficiency(unique_storage_techs_indices);
unique_technologies.storage_techs_discharging_efficiency = technologies.storage_techs_discharging_efficiency(unique_storage_techs_indices);
unique_technologies.storage_techs_decay = technologies.storage_techs_decay(unique_storage_techs_indices);
unique_technologies.storage_techs_max_charging_rate = technologies.storage_techs_max_charging_rate(unique_storage_techs_indices);
unique_technologies.storage_techs_max_discharging_rate = technologies.storage_techs_max_discharging_rate(unique_storage_techs_indices);
unique_technologies.storage_techs_min_state_of_charge = technologies.storage_techs_min_state_of_charge(unique_storage_techs_indices);
unique_technologies.storage_techs_min_capacity = technologies.storage_techs_min_capacity(unique_storage_techs_indices);
unique_technologies.storage_techs_max_capacity = technologies.storage_techs_max_capacity(unique_storage_techs_indices);

%% SET SOME VARIABLE VALUES FOR LATER USE

notnan_cell = @(V) any(~isnan(V(:))); %for extracting the non-NaN values from a cell array
isnan_cell = @(V) any(isnan(V(:))); %for extracting the NaN values from a cell array

%get a list of the energy outputs
nonnan_conversion_techs_outputs_2 = unique_technologies.conversion_techs_outputs_2(cellfun(notnan_cell,unique_technologies.conversion_techs_outputs_2));
energy_outputs = union(unique_technologies.conversion_techs_outputs_1,nonnan_conversion_techs_outputs_2);
energy_outputs = union(energy_outputs,demand_types);

%get lists of different groupings of conversion technologies
energy_conversion_technologies = unique_technologies.conversion_techs_names;
energy_storage_technologies = unique_technologies.storage_techs_names;
technologies_with_single_output = unique_technologies.conversion_techs_names(cellfun(isnan_cell,unique_technologies.conversion_techs_outputs_2));
technologies_with_multiple_outputs = unique_technologies.conversion_techs_names(cellfun(notnan_cell,unique_technologies.conversion_techs_outputs_2));
technologies_with_single_input = unique_technologies.conversion_techs_names(cellfun(isnan_cell,unique_technologies.conversion_techs_inputs_2));
technologies_with_multiple_inputs = unique_technologies.conversion_techs_names(cellfun(notnan_cell,unique_technologies.conversion_techs_inputs_2));
solar_technologies = unique_technologies.conversion_techs_names(find(strcmp(unique_technologies.conversion_techs_inputs_1,'Solar')));
technologies_excluding_grid = unique_technologies.conversion_techs_names(find(~strcmp(unique_technologies.conversion_techs_names,'Grid')));
if exist('technologies.storage_techs_min_temperature','var')
    storages_with_temperature_constraints = unique_technologies.storage_techs_names(find(~isnan(unique_technologies.storage_techs_min_temperature)));
else
    storages_with_temperature_constraints = [];
end
