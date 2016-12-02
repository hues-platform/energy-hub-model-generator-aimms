%% SELECT THE SETS, PARAMETERS AND VARIABLES TO BE CREATED

% INITIALLY, SET ALL SELECTIONS TO ZERO
create_time_set = 0;
create_conversion_techs_set = 0;
create_energy_carriers_set = 0;
create_storage_techs_set = 0;
create_hubs_set = 0;
create_param_loads = 0;
create_param_operating_costs = 0;
create_param_operating_costs_grid = 0;
create_param_OMV_costs = 0;
create_param_linear_capital_costs = 0;
create_param_fixed_capital_costs = 0;
create_param_linear_storage_costs = 0;
create_param_fixed_storage_costs = 0;
create_param_electricity_feedin_price = 0;
create_param_int_rate = 0;
create_param_lifetimes = 0;
create_param_storage_lifetimes = 0;
create_param_technology_CRF = 0;
create_param_storage_CRF = 0;
create_param_C_matrix = 0;
create_param_S_matrix = 0;
create_param_capacity = 0;
create_param_capacity_grid = 0;
create_param_minimum_capacities = 0;
create_param_maximum_capacities = 0;
create_param_min_capacity_grid = 0;
create_param_max_capacity_grid = 0;
create_param_minimum_part_load = 0;
create_param_max_charge_rate = 0;
create_param_max_discharge_rate = 0;
create_param_standing_losses = 0;
create_param_charging_efficiency = 0;
create_param_discharging_efficiency = 0;
create_param_min_soc = 0;
create_param_storage_capacity = 0;
create_param_min_capacity_storage = 0;
create_param_max_capacity_storage = 0;
create_param_min_temperature_storage = 0;
create_param_max_temperature_storage = 0;
create_param_thermal_storage_specific_heat = 0;
create_param_roof_area = 0;
create_param_carbon_factors = 0;
create_param_max_carbon = 0;
create_param_solar_radiation = 0;
create_param_big_M = 0;
create_param_installed_conversion_technologies = 0;
create_param_installed_storage_technologies = 0;
create_param_link_installation = 0;
create_param_link_lengths = 0;
create_param_link_losses = 0;
create_param_link_capacity = 0;

create_variable_input_streams = 0;
create_variable_electricity_output = 0;
create_variable_heat_output = 0;
create_variable_cool_output = 0;
create_variable_dhw_output = 0;
create_variable_anergy_output = 0;
create_variable_exported_energy = 0;
create_variable_technology_installation = 0;
create_variable_technology_operation = 0;
create_variable_technology_capacity = 0;
create_variable_grid_capacity = 0;
create_variable_storage_charge_rate = 0;
create_variable_storage_discharge_rate = 0;
create_variable_storage_soc = 0;
create_variable_storage_capacity = 0;
create_variable_storage_installation = 0;
create_variable_storage_temperature = 0;
create_variable_energy_demands = 0;
create_variable_operating_cost_per_technology = 0;
create_variable_maintenance_cost_per_technology = 0;
create_variable_capital_cost_per_technology = 0;
create_variable_total_cost_per_technology = 0;
create_variable_total_cost_grid = 0;
create_variable_capital_cost_per_storage = 0;
create_variable_total_cost_per_storage = 0;
create_variable_total_carbon_per_technology = 0;
create_variable_total_carbon_per_timestep = 0;
create_variable_total_cost_per_technology_without_capital_costs = 0;
create_variable_total_cost_grid_without_capital_costs = 0;
create_variable_link_flows = 0;
create_variable_link_operation = 0;
create_variable_link_losses = 0;
create_objectivefn_operating_cost_grid = 0;
create_objectivefn_operating_cost = 0;
create_objectivefn_maintenance_cost = 0;
create_objectivefn_maintenance_cost_per_timestep = 0;
create_objectivefn_income_via_exports = 0;
create_objectivefn_capital_cost = 0;
create_objectivefn_total_carbon = 0;
create_objectivefn_total_cost = 0;

%% SELECT FORM OF STORAGE REPRESENTATION

%determine whether to use a simplified storage representation
% (this increases speed by representing storage technologies in terms of their energy carrier, rather than as individual technologies)
if multiple_hubs == 0
    if length(electricity_storage_technologies) > 1 || length(heat_storage_technologies) > 1 || length(cool_storage_technologies) > 1 || length(dhw_storage_technologies) > 1 || length(anergy_storage_technologies) > 1
        simplified_storage_representation = 0;
    else
        simplified_storage_representation = 1;
    end
else
    simplified_storage_representation = 1;
    
    %check if there are multiple storage techs of the same type being considered for installation
    electricity_storage_techs_not_installed = technologies_for_selection_and_sizing.storage_techs_names(find(strcmp(technologies_for_selection_and_sizing.storage_techs_types,'Elec')));
    heat_storage_techs_not_installed = technologies_for_selection_and_sizing.storage_techs_names(find(strcmp(technologies_for_selection_and_sizing.storage_techs_types,'Heat')));
    cool_storage_techs_not_installed = technologies_for_selection_and_sizing.storage_techs_names(find(strcmp(technologies_for_selection_and_sizing.storage_techs_types,'Cool')));
    dhw_storage_techs_not_installed = technologies_for_selection_and_sizing.storage_techs_names(find(strcmp(technologies_for_selection_and_sizing.storage_techs_types,'DHW')));
    anergy_storage_techs_not_installed = technologies_for_selection_and_sizing.storage_techs_names(find(strcmp(technologies_for_selection_and_sizing.storage_techs_types,'Anergy')));
    if length(electricity_storage_techs_not_installed) > 1 || length(heat_storage_techs_not_installed) > 1 || length(cool_storage_techs_not_installed) > 1 || length(dhw_storage_techs_not_installed) > 1 || length(anergy_storage_techs_not_installed) > 1
        simplified_storage_representation = 0;
    end
    
    %check if there are multiple storage techs of the same type already installed at any of the hubs
    for h=1:number_of_hubs
        if include_installed_technologies == 1 && isempty(installed_technologies.storage_techs_names) == 0
            electricity_storage_techs_this_hub = installed_technologies.storage_techs_names(find(installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Elec')) == h)));
            heat_storage_techs_this_hub = installed_technologies.storage_techs_names(find(installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Heat')) == h)));
            cool_storage_techs_this_hub = installed_technologies.storage_techs_names(find(installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Cool')) == h)));
            dhw_storage_techs_this_hub = installed_technologies.storage_techs_names(find(installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'DHW')) == h)));
            anergy_storage_techs_this_hub = installed_technologies.storage_techs_names(find(installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Anergy')) == h)));
            if length(electricity_storage_techs_this_hub) > 1 || length(heat_storage_techs_this_hub) > 1 || length(cool_storage_techs_this_hub) > 1 || length(dhw_storage_techs_this_hub) > 1 || length(anergy_storage_techs_this_hub) > 1
                simplified_storage_representation = 0;
            end
        end
    end
end

%% SELECT SETS

%these sets should always be created
create_time_set = 1;
create_conversion_techs_set = 1;
create_energy_carriers_set = 1;

%to be created if there are storage technologies
if isempty(energy_storage_technologies) == 0 && simplified_storage_representation == 0
    create_storage_techs_set = 1;
end

if multiple_hubs == 1
   create_hubs_set = 1; 
end
    
%% SELECT PARAMS
%these params should always be created
create_param_loads = 1;
create_param_C_matrix = 1;
create_param_big_M = 1;

%to be created if the system is grid connected
if grid_connected_system == 1
    create_param_electricity_feedin_price = 1;
    create_param_operating_costs_grid = 1;
    create_objectivefn_operating_cost_grid = 1;
end

%to be created if the system is grid connected and we're not doing selection/sizing
if grid_connected_system == 1 && select_techs_and_do_sizing == 0
    create_param_capacity_grid = 1;
end

%to be created if the system is grid connected and we're doing selection/sizing
if grid_connected_system == 1 && select_techs_and_do_sizing == 1
    create_param_min_capacity_grid = 1;
    create_param_max_capacity_grid = 1;
end

%to be created if there are energy conversion techs
if isempty(technologies.conversion_techs_names) == 0
    create_param_OMV_costs = 1;
    create_param_minimum_part_load = 1;
    create_param_carbon_factors = 1;
    create_param_operating_costs = 1;

    %to be created if there are pre-installed conversion techs & you're doing selection/sizing
    if include_installed_technologies == 1 && isempty(installed_technologies.conversion_techs_names) == 0 && select_techs_and_do_sizing == 1
        create_param_installed_conversion_technologies = 1;
    end
        
    %to be created if there are conversion techs and we're not doing selection/sizing
    if select_techs_and_do_sizing == 0
        create_param_capacity = 1;
    end
    
    %to be created if there are conversion techs and we're doing selection/sizing
    if select_techs_and_do_sizing == 1
        create_param_linear_capital_costs = 1;
        create_param_fixed_capital_costs = 1;
        create_param_technology_CRF = 1;
        create_param_int_rate = 1;
        create_param_lifetimes = 1;
        create_param_minimum_capacities = 1;
        create_param_maximum_capacities = 1;
    end
end

%to be created if there are storage techs
if isempty(technologies.storage_techs_names) == 0
    create_param_S_matrix = 1;
    create_param_max_charge_rate = 1;
    create_param_max_discharge_rate = 1;
    create_param_standing_losses = 1;
    create_param_charging_efficiency = 1;
    create_param_discharging_efficiency = 1;
    create_param_min_soc = 1;
    
    %to be created if there are storage techs with thermal temperature constraints
    if isempty(storages_with_temperature_constraints) == 0
        create_param_min_temperature_storage = 1;
        create_param_max_temperature_storage = 1;
        create_param_thermal_storage_specific_heat = 1;
    end

    %to be created if there are pre-installed storage techs and we're doing selection/sizing
    if include_installed_technologies == 1 && isempty(installed_technologies.storage_techs_names) == 0 && select_techs_and_do_sizing == 1
        create_param_installed_storage_technologies = 1;
    end

    %to be created if there are storage techs and we're not doing selection/sizing
    if select_techs_and_do_sizing == 0
        create_param_storage_capacity = 1;
    end
    
    %to be created if there are storage techs and we're doing selection/sizing
    if select_techs_and_do_sizing == 1
        create_param_linear_storage_costs = 1;
        create_param_fixed_storage_costs = 1;
        create_param_storage_lifetimes = 1;
        create_param_storage_CRF = 1;
        create_param_int_rate = 1;
        create_param_min_capacity_storage = 1;
        create_param_max_capacity_storage = 1;
    end
end

%to be created if there are solar techs
if isempty(solar_technologies) == 0
    create_param_solar_radiation = 1;
    if select_techs_and_do_sizing == 1
        create_param_roof_area = 1;
    end
end

%to be created if therea re multiple hubs
if multiple_hubs == 1
    create_param_link_installation = 1;
    create_param_link_lengths = 1;
    create_param_link_losses = 1;
    create_param_link_capacity = 1;
end

%to be created if there is a carbon limit
if carbon_limit_boolean == 1
    create_param_max_carbon = 1;
end

%% SELECT VARIABLES

%these variables should always be created
create_variable_input_streams = 1;
create_objectivefn_operating_cost = 1;
create_objectivefn_maintenance_cost = 1;
create_objectivefn_maintenance_cost_per_timestep = 1;
create_objectivefn_total_carbon = 1;
create_objectivefn_total_cost = 1;

%these variables should be created depending on the energy outputs
if ismember('Elec',technologies.conversion_techs_outputs) == 1
    create_variable_electricity_output = 1;
end
if ismember('Heat',technologies.conversion_techs_outputs) == 1
    create_variable_heat_output = 1;
end
if ismember('Cool',technologies.conversion_techs_outputs) == 1
    create_variable_cool_output = 1;
end
if ismember('DHW',technologies.conversion_techs_outputs) == 1
    create_variable_dhw_output = 1;
end
if ismember('Anergy',technologies.conversion_techs_outputs) == 1
    create_variable_anergy_output = 1;
end

%to be created if the system is grid connected
if grid_connected_system == 1
    create_variable_exported_energy = 1;
    create_objectivefn_income_via_exports = 1;
end

%to be created if the system is grid connected and we're doing selection/sizing
if grid_connected_system == 1 && select_techs_and_do_sizing == 1
    create_variable_grid_capacity = 1;
end

%to be created if there are multiple hubs
if multiple_hubs == 1
    create_variable_link_flows = 1;
    create_variable_link_operation = 1;
    create_variable_link_losses = 1;
end

%to be created if there are dispatchable conversion techs
if isempty(dispatchable_technologies) == 0
    create_variable_technology_operation = 1;
end

%to be created if there are conversion techs and we're doing selection/sizing
if isempty(technologies.conversion_techs_names) == 0 && select_techs_and_do_sizing == 1
    create_variable_technology_installation = 1;
    create_variable_technology_capacity = 1;
    create_objectivefn_capital_cost = 1;
end

%to be created if there are storage techs
if isempty(technologies.storage_techs_names) == 0
    create_variable_storage_charge_rate = 1;
    create_variable_storage_discharge_rate = 1;
    create_variable_storage_soc = 1;
    
    %to be created if there are storage techs with thermal temperature constraints
    if isempty(storages_with_temperature_constraints) == 0
        create_variable_storage_temperature = 1;
    end

    %to be created if there are storage techs and we're doing selection/sizing
    if select_techs_and_do_sizing == 1
        create_variable_storage_capacity = 1;
        create_variable_storage_installation = 1;
    end
end

%% SELECT OUTPUT VARIABLES

if print_demand_data == 1
    create_variable_energy_demands = 1;
end

if print_cost_data == 1
    
    if isempty(technologies.conversion_techs_names) == 0
        create_variable_operating_cost_per_technology = 1;
        create_variable_maintenance_cost_per_technology = 1;
    end
    
    if grid_connected_system == 1
        if select_techs_and_do_sizing == 1
            create_variable_total_cost_grid = 1;
        else
            create_variable_total_cost_grid_without_capital_costs = 1;
        end
    end
    
    if select_techs_and_do_sizing == 1
        create_variable_capital_cost_per_technology = 1;
        create_variable_total_cost_per_technology = 1;
        
        if isempty(technologies.storage_techs_names) == 0
            create_variable_capital_cost_per_storage = 1;
            create_variable_total_cost_per_storage = 1;
        end
    else
        create_variable_total_cost_per_technology_without_capital_costs = 1;
    end   
end

if print_emissions_data == 1
    create_variable_total_carbon_per_technology = 1;
    create_variable_total_carbon_per_timestep = 1;
end




