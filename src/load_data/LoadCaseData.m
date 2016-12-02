%% LOAD CASE STUDY DATA

%% CLEAN UP THE INPUT FILES

if exist('aimms_model\energy_hub\electricity_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\electricity_demand.xlsx');
end
if exist('aimms_model\energy_hub\heating_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\heating_demand.xlsx');
end
if exist('aimms_model\energy_hub\cooling_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\cooling_demand.xlsx');
end
if exist('aimms_model\energy_hub\dhw_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\dhw_demand.xlsx');
end
if exist('aimms_model\energy_hub\anergy_demand.xlsx','file')==2
  delete('aimms_model\energy_hub\anergy_demand.xlsx');
end
if exist('aimms_model\energy_hub\solar_inputs.xlsx','file')==2
  delete('aimms_model\energy_hub\solar_inputs.xlsx');
end

%% LOAD DEMAND DATA

filename = strcat('case_study_data\',case_study,'\demand_data.csv');
[demand_data,demand_types,raw] = xlsread(filename);

%extract the demand data
demand_data = demand_data(11:end,:);
demand_types = demand_types(3,2:end);

%determine the number of hubs
multiple_hubs = 0;
hubs = cell2mat(raw(4,2:end));
hub_list = sort(unique(hubs));
number_of_hubs = length(hub_list);
if number_of_hubs > 1
    multiple_hubs = 1;
end

%write the demand data files

%get demand types, and save as a list (you may have to augment this list later with the technology inputs/outputs)
%for each of the demand types, write a demand file
%for d=demand_types
%    relevant_demand_columns = find(strcmp(d,demand_types));
%    for h = hub_list
%        hub_columns = find(hubs == h);
%        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
%        hub_demands = horzcat(hub_demands,hub_demand);
%    end
%    if sum(sum(hub_demands)) > 0
%        xlswrite(strcat('aimms_model\energy_hub\',demand_types(d),'_demand.xlsx'),hub_demands,strcat('electricity_demand',demand_types(d)));
%    end
%end

consider_electricity_demand = 0;
consider_heating_demand = 0;
consider_cooling_demand = 0;
consider_dhw_demand = 0;
consider_anergy_demand = 0;

hub_demands = [];
if sum(strcmp('Elec',demand_types)) > 0
    relevant_demand_columns = find(strcmp('Elec',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_electricity_demand = 1;
        xlswrite('aimms_model\energy_hub\electricity_demand.xlsx',hub_demands,'electricity_demand');
    end
end
hub_demands = [];
if sum(strcmp('Heat',demand_types)) > 0
    relevant_demand_columns = find(strcmp('Heat',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_heating_demand = 1;
        xlswrite('aimms_model\energy_hub\heating_demand.xlsx',hub_demands,'heating_demand');
    end
end
hub_demands = [];
if sum(strcmp('Cool',demand_types)) > 0
    relevant_demand_columns = find(strcmp('Cool',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_cooling_demand = 1;
        xlswrite('aimms_model\energy_hub\cooling_demand.xlsx',hub_demands,'cooling_demand');
    end
end
hub_demands = [];
if sum(strcmp('DHW',demand_types)) > 0
    relevant_demand_columns = find(strcmp('DHW',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_dhw_demand = 1;
        xlswrite('aimms_model\energy_hub\dhw_demand.xlsx',hub_demands,'dhw_demand');
    end
end
hub_demands = [];
if sum(strcmp('Anergy',demand_types)) > 0
    relevant_demand_columns = find(strcmp('Anergy',demand_types));
    for h = hub_list
        hub_columns = find(hubs == h);
        hub_demand = demand_data(:,intersect(relevant_demand_columns,hub_columns));
        hub_demands = horzcat(hub_demands,hub_demand);
    end
    if sum(sum(hub_demands)) > 0
        consider_anergy_demand = 1;
        xlswrite('aimms_model\energy_hub\anergy_demand.xlsx',hub_demands,'anergy_demand');
    end
end

%% LOAD ENERGY INPUTS DATA

filename = strcat('case_study_data\',case_study,'\energy_inputs_data.csv');
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
        xlswrite('aimms_model\energy_hub\solar_inputs.xlsx',solar_radiations,'solar');
    end
end

%% LOAD INSTALLED TECHNOLOGY DATA

if include_installed_technologies == 1

    %read the installed conversion technology data
    if exist(strcat('case_study_data\',case_study,'\installed_conversion_technologies.csv'),'file')==2
        filename = strcat('case_study_data\',case_study,'\installed_conversion_technologies.csv');
        [num,text,raw] = xlsread(filename);

        installed_technologies.conversion_techs_names = raw(1,2:end);
        installed_technologies.conversion_techs_outputs = raw(2,2:end);
        installed_technologies.conversion_techs_inputs = raw(3,2:end);
        installed_technologies.conversion_techs_efficiency = num(1,1:end);
        installed_technologies.conversion_techs_min_part_load = num(2,1:end);
        installed_technologies.conversion_techs_HTP_ratio = num(3,1:end);
        installed_technologies.conversion_techs_capacity = num(4,1:end);
        installed_technologies.conversion_techs_node = num(5,1:end);
    end

    %read the installed storage technology data
    if exist(strcat('case_study_data\',case_study,'\installed_storage_technologies.csv'),'file')==2
        filename = strcat('case_study_data\',case_study,'\installed_storage_technologies.csv');
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

filename = strcat('case_study_data\',case_study,'\node_data.csv');
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
    if exist(strcat('case_study_data\',case_study,'\installed_network_technologies.csv'),'file')==2 && exist(strcat('case_study_data\',case_study,'\network_data.csv'),'file')==2
        
        filename = strcat('case_study_data\',case_study,'\installed_network_technologies.csv');
        [num,text,raw] = xlsread(filename);

        installed_technologies.network_techs_names = raw(1,2:end);
        installed_technologies.network_techs_types = raw(2,2:end);
        installed_technologies.network_techs_capacities = cell2mat(raw(3,2:end));
        installed_technologies.network_techs_losses = cell2mat(raw(4,2:end));
        installed_technologies.network_techs_links = cell2mat(raw(5,2:end));
        
        filename = strcat('case_study_data\',case_study,'\network_data.csv');
        [data,text,raw] = xlsread(filename);

        links = cell2mat(raw(1,2:end));
        links_node1 = cell2mat(raw(2,2:end));
        links_node2 = cell2mat(raw(3,2:end));
        links_length = cell2mat(raw(4,2:end));
    end
end