
%% SET THE CONSTRAINTS TO BE APPLIED
% These constraints are automatically set based on selected options/inputs
% Generally, these should not be changed

% INITIALLY, SET ALL THE CONSTRAINTS TO ZERO
apply_constraint_energy_balance = 0;
apply_constraint_capacity = 0;
apply_constraint_dispatch = 0;
apply_constraint_min_part_load = 0;
apply_constraint_solar_availability = 0;
apply_constraint_roof_area = 0;
apply_constraint_min_capacity = 0;
apply_constraint_max_capacity = 0;
apply_constraint_min_capacity_grid = 0;
apply_constraint_max_capacity_grid = 0;
apply_constraint_installation = 0;
apply_constraint_installed_conversion_techs = 0;
apply_constraint_installed_storage_techs = 0;
apply_constraint_operation = 0;
apply_constraint_grid_capacity_violation1 = 0;
apply_constraint_grid_capacity_violation2 = 0;
apply_constraint_htp_ratio_heat = 0;
apply_constraint_htp_ratio_dhw = 0;
apply_constraint_htp_ratio_anergy = 0;
apply_constraint_chp_heat = 0;
apply_constraint_chp_dhw = 0;
apply_constraint_chp_anergy = 0;
apply_constraint_chp2 = 0;
apply_constraint_energy_balance_storage = 0;
apply_constraint_max_charging_rate_storage = 0;
apply_constraint_max_discharging_rate_storage = 0;
apply_constraint_capacity_storage = 0;
apply_constraint_min_soc_storage = 0;
apply_constraint_electrical_storage_initialization_to_min_soc = 0;
apply_constraint_electrical_storage_initialization_cyclical = 0;
apply_constraint_electrical_storage_1st_hour = 0;
apply_constraint_heat_storage_initialization_to_min_soc = 0;
apply_constraint_heat_storage_initialization_cyclical = 0;
apply_constraint_heat_storage_1st_hour = 0;
apply_constraint_cool_storage_initialization_to_min_soc = 0;
apply_constraint_cool_storage_initialization_cyclical = 0;
apply_constraint_cool_storage_1st_hour = 0;
apply_constraint_dhw_storage_initialization_to_min_soc = 0;
apply_constraint_dhw_storage_initialization_cyclical = 0;
apply_constraint_dhw_storage_1st_hour = 0;
apply_constraint_anergy_storage_initialization_to_min_soc = 0;
apply_constraint_anergy_storage_initialization_cyclical = 0;
apply_constraint_anergy_storage_1st_hour = 0;
apply_constraint_thermal_storage_temperature_intialization = 0;
apply_constraint_installation_storage = 0;
apply_constraint_min_capacity_storage = 0;
apply_constraint_max_capacity_storage = 0;
apply_constraint_min_temperature_storage = 0;
apply_constraint_max_temperature_storage = 0;
apply_constraint_thermal_storage_balance = 0;
apply_constraint_max_carbon = 0;
apply_constraint_link_installation = 0;
apply_constraint_link_operation = 0;
apply_constraint_link_capacity = 0;
apply_constraint_link_flow_direction = 0;

%ACTIVATE THE DIFFERENT CONSTRAINTS DEPENDING ON THE INPUTS
% These constraints are applicable as long as you are considering energy conversion techs
if isempty(technologies.conversion_techs_names) == 0
    apply_constraint_energy_balance = 1;
    apply_constraint_capacity = 1;
    apply_constraint_dispatch = 1;
    apply_constraint_min_part_load = 1;
    
    %only applicable if the system is grid connected
    if grid_connected_system == 1
        apply_constraint_grid_capacity_violation1 = 1;
        apply_constraint_grid_capacity_violation2 = 1;
    end
    
    %only applicable if the system is grid connected and we're doing selection/sizing
    if grid_connected_system == 1 && select_techs_and_do_sizing == 1
        apply_constraint_min_capacity_grid = 1;
        apply_constraint_max_capacity_grid = 1;
    end

    %to be created if there are pre-installed conversion techs && you're doing sizing & tech selection
    if include_installed_technologies == 1 && isempty(installed_technologies.conversion_techs_names) == 0 && select_techs_and_do_sizing == 1
        apply_constraint_installed_conversion_techs = 1;
    end
    
    %only applicable if you're considering solar technologies
    if isempty(solar_technologies) == 0
        apply_constraint_solar_availability = 1;
        if select_techs_and_do_sizing == 1
            apply_constraint_roof_area = 1;
        end
    end

    %only applicable if you're doing sizing & tech selection of conversion techs
    if select_techs_and_do_sizing == 1
        apply_constraint_min_capacity = 1;
        apply_constraint_max_capacity = 1;
        apply_constraint_installation = 1;
        apply_constraint_operation = 1;
    end

    %only applicable if you're doing sizing & tech selection AND are considering CHP techs
    if isempty(chp_technologies) == 0 && select_techs_and_do_sizing == 1
        apply_constraint_chp2 = 1;
    end
    %only applicable if you're doing sizing & tech selection AND are considering heat CHP techs
    if isempty(chp_heat_technologies) == 0 && select_techs_and_do_sizing == 1
        apply_constraint_htp_ratio_heat = 1;
        apply_constraint_chp_heat = 1;
    end
    %only applicable if you're doing sizing & tech selection AND are considering DHW CHP techs
    if isempty(chp_dhw_technologies) == 0 && select_techs_and_do_sizing == 1
        apply_constraint_htp_ratio_dhw = 1;
        apply_constraint_chp_dhw = 1;
    end
    %only applicable if you're doing sizing & tech selection AND are considering anergy CHP techs
    if isempty(chp_anergy_technologies) == 0 && select_techs_and_do_sizing == 1
        apply_constraint_htp_ratio_anergy = 1;
        apply_constraint_chp_anergy = 1;
    end
end

if isempty(technologies.storage_techs_names) == 0
    
    %only applicable if you're considering storage techs
    apply_constraint_energy_balance_storage = 1;
    apply_constraint_max_charging_rate_storage = 1;
    apply_constraint_max_discharging_rate_storage = 1;
    apply_constraint_capacity_storage = 1;
    apply_constraint_min_soc_storage = 1;
    
    %to be created if there are storage techs with thermal temperature constraints
    if isempty(storages_with_temperature_constraints) == 0
        apply_constraint_min_temperature_storage = 1;
        apply_constraint_max_temperature_storage = 1;
        apply_constraint_thermal_storage_balance = 1;
        apply_constraint_thermal_storage_temperature_intialization = 1;
    end

    %to be created if there are pre-installed storage techs and you're doing selection and sizing
    if include_installed_technologies == 1 && isempty(installed_technologies.storage_techs_names) == 0 && select_techs_and_do_sizing == 1
        apply_constraint_installed_storage_techs = 1;
    end
    
    %only applicable if you're doing sizing and tech selection of storage
    if select_techs_and_do_sizing == 1
        apply_constraint_installation_storage = 1;
        apply_constraint_min_capacity_storage = 1;
        apply_constraint_max_capacity_storage = 1;
    end
end

%based on the selected initialization method options
%only applicable if you're considering electricity storage techs
if isempty(electricity_storage_technologies) == 0
    if electrical_storage_initialization_method == 1 
        apply_constraint_electrical_storage_initialization_to_min_soc = 1;
    else
        apply_constraint_electrical_storage_initialization_cyclical = 1;
        apply_constraint_electrical_storage_1st_hour = 1;
    end 
end

%only applicable if you're considering heat storage techs
if isempty(heat_storage_technologies) == 0
    if heat_storage_initialization_method == 1
        apply_constraint_heat_storage_initialization_to_min_soc = 1;
    else
        apply_constraint_heat_storage_initialization_cyclical = 1;
        apply_constraint_heat_storage_1st_hour = 1;
    end
end

%only applicable if you're considering cool storage techs
if isempty(cool_storage_technologies) == 0
    if cool_storage_initialization_method == 1
        apply_constraint_cool_storage_initialization_to_min_soc = 1;
    else
        apply_constraint_cool_storage_initialization_cyclical = 1;
        apply_constraint_cool_storage_1st_hour = 1;
    end
end

%only applicable if you're considering dhw storage techs
if isempty(dhw_storage_technologies) == 0
    if dhw_storage_initialization_method == 1
        apply_constraint_dhw_storage_initialization_to_min_soc = 1;
    else
        apply_constraint_dhw_storage_initialization_cyclical = 1;
        apply_constraint_dhw_storage_1st_hour = 1;
    end
end

%only applicable if you're considering anergy storage techs
if isempty(anergy_storage_technologies) == 0
    if anergy_storage_initialization_method == 1
        apply_constraint_anergy_storage_initialization_to_min_soc = 1;
    else
        apply_constraint_anergy_storage_initialization_cyclical = 1;
        apply_constraint_anergy_storage_1st_hour = 1;
    end
end

%only applicable if you have a carbon constraint
if carbon_limit_boolean == 1
    apply_constraint_max_carbon = 1;
end

%only applicable if you have multiple hubs
if multiple_hubs == 1
    apply_constraint_link_installation = 1;
    apply_constraint_link_operation = 1;
    apply_constraint_link_capacity = 1;
    apply_constraint_link_flow_direction = 1;
end
