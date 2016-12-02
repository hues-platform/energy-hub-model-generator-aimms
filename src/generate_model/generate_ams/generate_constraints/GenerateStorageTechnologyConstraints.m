%% GENERATE STORAGE TECHNOLOGY CONSTRAINTS

if simplified_storage_representation == 0

    %energy balance constraints for storages
    constraint_energy_balance_storage = '';
    if apply_constraint_energy_balance_storage == 1 
        if multiple_hubs == 0
            constraint_energy_balance_storage = '\n\t\tConstraint Storage_balance_constraint {\n\t\t\tIndexDomain: (t,stor) | t > first(Time);\n\t\t\tDefinition: Storage_SOC(t,stor) = (1 - Storage_standing_losses(stor)) * Storage_SOC(t-1,stor) + Storage_charging_efficiency(stor) *  Storage_input_energy(t,stor) - (1 / Storage_discharging_efficiency(stor)) * Storage_output_energy(t,stor);\n\t\t}';
        else
            constraint_energy_balance_storage = '\n\t\tConstraint Storage_balance_constraint {\n\t\t\tIndexDomain: (t,stor,h) | t > first(Time);\n\t\t\tDefinition: Storage_SOC(t,stor,h) = (1 - Storage_standing_losses(stor)) * Storage_SOC(t-1,stor,h) + Storage_charging_efficiency(stor) *  Storage_input_energy(t,stor,h) - (1 / Storage_discharging_efficiency(stor)) * Storage_output_energy(t,stor,h);\n\t\t}';
        end
    end

    %max allowable charging rate constraint
    constraint_max_charging_rate_storage = '';
    if apply_constraint_max_charging_rate_storage == 1
        if multiple_hubs == 0
            constraint_max_charging_rate_storage = '\n\t\tConstraint Storage_charging_rate_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_input_energy(t,stor) <= Storage_max_charge_rate(stor) * Storage_capacity(stor);\n\t\t}';
        else
            constraint_max_charging_rate_storage = '\n\t\tConstraint Storage_charging_rate_constraint {\n\t\t\tIndexDomain: (t,stor,h);\n\t\t\tDefinition: Storage_input_energy(t,stor,h) <= Storage_max_charge_rate(stor) * Storage_capacity(stor,h);\n\t\t}';
        end
    end

    %max allowable discharging rate constraint
    constraint_max_discharging_rate_storage = '';
    if apply_constraint_max_discharging_rate_storage == 1
        if multiple_hubs == 0
            constraint_max_discharging_rate_storage = '\n\t\tConstraint Storage_discharging_rate_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_output_energy(t,stor) <= Storage_max_discharge_rate(stor) * Storage_capacity(stor);\n\t\t}';
        else
            constraint_max_discharging_rate_storage = '\n\t\tConstraint Storage_discharging_rate_constraint {\n\t\t\tIndexDomain: (t,stor,h);\n\t\t\tDefinition: Storage_output_energy(t,stor,h) <= Storage_max_discharge_rate(stor) * Storage_capacity(stor,h);\n\t\t}';
        end
    end

    %storage capacity constraint
    constraint_capacity_storage = '';
    if apply_constraint_capacity_storage == 1
        if multiple_hubs == 0
            constraint_capacity_storage = '\n\t\tConstraint Storage_capacity_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_SOC(t,stor) <= Storage_capacity(stor);\n\t\t}';
        else
            constraint_capacity_storage = '\n\t\tConstraint Storage_capacity_constraint {\n\t\t\tIndexDomain: (t,stor,h);\n\t\t\tDefinition: Storage_SOC(t,stor,h) <= Storage_capacity(stor,h);\n\t\t}';
        end
    end

    %minimum state of charge constraint
    constraint_min_soc_storage = '';
    if apply_constraint_min_soc_storage == 1
        if multiple_hubs == 0
            constraint_min_soc_storage = '\n\t\tConstraint Storage_minimum_SOC_constraint {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tDefinition: Storage_SOC(t,stor) >= Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}';
        else
            constraint_min_soc_storage = '\n\t\tConstraint Storage_minimum_SOC_constraint {\n\t\t\tIndexDomain: (t,stor,h);\n\t\t\tDefinition: Storage_SOC(t,stor,h) >= Storage_capacity(stor,h) * Storage_min_SOC(stor);\n\t\t}';
        end
    end

    %storage installation constraint
    constraint_installation_storage = '';
    if apply_constraint_installation_storage == 1
        if multiple_hubs == 0
            constraint_installation_storage = '\n\t\tConstraint Storage_installation_constraint {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Storage_capacity(stor) <= Big_M * Installation_storage(stor);\n\t\t}';
        else
            constraint_installation_storage = '\n\t\tConstraint Storage_installation_constraint {\n\t\t\tIndexDomain: (stor,h);\n\t\t\tDefinition: Storage_capacity(stor,h) <= Big_M * Installation_storage(stor,h);\n\t\t}';
        end
    end

    %installed techs constraint
    constraint_installed_storage_techs = '';
    if apply_constraint_installed_storage_techs == 1
        if multiple_hubs == 0
            constraint_installed_storage_techs = '\n\t\tConstraint Installed_storage_techs_constraint {\n\t\t\tIndexDomain: (x,stor);\n\t\t\tDefinition: Installation_storage(x,stor) = Installed_storage_techs(stor);\n\t\t}';
        else
            constraint_installed_storage_techs = '\n\t\tConstraint Installed_storage_techs_constraint {\n\t\t\tIndexDomain: (x,stor,h);\n\t\t\tDefinition: Installation_storage(x,stor,h) = Installed_storage_techs(stor,h);\n\t\t}';
        end
    end
    
    %min capacity constraint for storage
    constraint_min_capacity_storage = '';
    if apply_constraint_min_capacity_storage == 1
        if multiple_hubs == 0
            constraint_min_capacity_storage = '\n\t\tConstraint Storage_minimum_capacity_constraint {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Storage_capacity(stor) >= Storage_minimum_capacity(stor);\n\t\t}';
        else
            constraint_min_capacity_storage = '\n\t\tConstraint Storage_minimum_capacity_constraint {\n\t\t\tIndexDomain: (stor,h);\n\t\t\tDefinition: Storage_capacity(stor,h) >= Storage_minimum_capacity(stor);\n\t\t}';
        end
    end

    %max capacity constraint for storage
    constraint_max_capacity_storage = '';
    if apply_constraint_max_capacity_storage == 1
        if multiple_hubs == 0
            constraint_max_capacity_storage = '\n\t\tConstraint Storage_maximum_capacity_constraint {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Storage_capacity(stor) <= Storage_maximum_capacity(stor);\n\t\t}';
        else
            constraint_max_capacity_storage = '\n\t\tConstraint Storage_maximum_capacity_constraint {\n\t\t\tIndexDomain: (stor,h);\n\t\t\tDefinition: Storage_capacity(stor,h) <= Storage_maximum_capacity(stor);\n\t\t}';
        end
    end
    
    %min temperature constraint for thermal storage
    constraint_min_temperature_storage = '';
    if apply_constraint_min_temperature_storage == 1
        index_domain_string = '';
        for t=1:length(storages_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storages_with_temperature_constraints(t)),'''');
            if t < length(storages_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR stor = '); 
            end
        end
        if multiple_hubs == 0
            constraint_min_temperature_storage = strcat('\n\t\tConstraint Storage_minimum_temperature_thermal_storage_constraint {\n\t\t\tIndexDomain: (t,stor) | (stor = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t,stor) >= Min_temperature_thermal_storage(stor);\n\t\t}');
        else
            constraint_min_temperature_storage = strcat('\n\t\tConstraint Storage_minimum_temperature_thermal_storage_constraint {\n\t\t\tIndexDomain: (t,stor,h) | (stor = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t,stor,h) >= Min_temperature_thermal_storage(stor);\n\t\t}');
        end
    end
    
    %max temperature constraint for thermal storage
    constraint_max_temperature_storage = '';
    if apply_constraint_max_temperature_storage == 1
        index_domain_string = '';
        for t=1:length(storages_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storages_with_temperature_constraints(t)),'''');
            if t < length(storages_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR stor = '); 
            end
        end
        if multiple_hubs == 0
            constraint_max_temperature_storage = strcat('\n\t\tConstraint Storage_maximum_temperature_thermal_storage_constraint {\n\t\t\tIndexDomain: (t,stor) | (stor = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t,stor) <= Max_temperature_thermal_storage(stor);\n\t\t}');
        else
            constraint_max_temperature_storage = strcat('\n\t\tConstraint Storage_maximum_temperature_thermal_storage_constraint {\n\t\t\tIndexDomain: (t,stor,h) | (stor = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t,stor,h) <= Max_temperature_thermal_storage(stor);\n\t\t}');
        end
    end
    
    %thermal storage heat balance constraint
    constraint_thermal_storage_balance = '';
    if apply_constraint_thermal_storage_balance == 1
        index_domain_string = '';
        for t=1:length(storages_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storages_with_temperature_constraints(t)),'''');
            if t < length(storages_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR stor = '); 
            end
        end
        if multiple_hubs == 0
            constraint_thermal_storage_balance = strcat('\n\t\tConstraint Thermal_storage_balance_constraint {\n\t\t\tIndexDomain: (t,stor,x) | (stor = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t+1,stor) = Temperature_thermal_storage(t,stor) + Storage_input_energy(t,stor) / (Storage_capacity(x,stor) * Thermal_storage_specific_heat(stor)) - Storage_output_energy(t,stor) / (Storage_capacity(x,stor) * Thermal_storage_specific_heat(stor));');
        else
            constraint_thermal_storage_balance = strcat('\n\t\tConstraint Thermal_storage_balance_constraint {\n\t\t\tIndexDomain: (t,stor,x,h) | (stor = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t+1,stor,h) = Temperature_thermal_storage(t,stor,h) + Storage_input_energy(t,stor,h) / (Storage_capacity(x,stor,h) * Thermal_storage_specific_heat(stor)) - Storage_output_energy(t,stor,h) / (Storage_capacity(x,stor,h) * Thermal_storage_specific_heat(stor));');
        end
    end    
    
else
    
    %energy balance constraints for storages
    constraint_energy_balance_storage = '';
    if apply_constraint_energy_balance_storage == 1
        if multiple_hubs == 0
            constraint_energy_balance_storage = '\n\t\tConstraint Storage_balance_constraint {\n\t\t\tIndexDomain: (t,x) | t > first(Time);\n\t\t\tDefinition: Storage_SOC(t,x) = (1 - Storage_standing_losses(x)) * Storage_SOC(t-1,x) + Storage_charging_efficiency(x) *  Storage_input_energy(t,x) - (1 / Storage_discharging_efficiency(x)) * Storage_output_energy(t,x);\n\t\t}';
        else
            constraint_energy_balance_storage = '\n\t\tConstraint Storage_balance_constraint {\n\t\t\tIndexDomain: (t,x,h) | t > first(Time);\n\t\t\tDefinition: Storage_SOC(t,x,h) = (1 - Storage_standing_losses(x)) * Storage_SOC(t-1,x,h) + Storage_charging_efficiency(x) *  Storage_input_energy(t,x,h) - (1 / Storage_discharging_efficiency(x)) * Storage_output_energy(t,x,h);\n\t\t}';
        end
    end

    %max allowable charging rate constraint
    constraint_max_charging_rate_storage = '';
    if apply_constraint_max_charging_rate_storage == 1
        if multiple_hubs == 0
            constraint_max_charging_rate_storage = '\n\t\tConstraint Storage_charging_rate_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_input_energy(t,x) <= Storage_max_charge_rate(x) * Storage_capacity(x);\n\t\t}';
        else
            constraint_max_charging_rate_storage = '\n\t\tConstraint Storage_charging_rate_constraint {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tDefinition: Storage_input_energy(t,x,h) <= Storage_max_charge_rate(x) * Storage_capacity(x,h);\n\t\t}';
        end
    end

    %max allowable discharging rate constraint
    constraint_max_discharging_rate_storage = '';
    if apply_constraint_max_discharging_rate_storage == 1
        if multiple_hubs == 0
            constraint_max_discharging_rate_storage = '\n\t\tConstraint Storage_discharging_rate_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_output_energy(t,x) <= Storage_max_discharge_rate(x) * Storage_capacity(x);\n\t\t}';
        else
            constraint_max_discharging_rate_storage = '\n\t\tConstraint Storage_discharging_rate_constraint {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tDefinition: Storage_output_energy(t,x,h) <= Storage_max_discharge_rate(x) * Storage_capacity(x,h);\n\t\t}';
        end
    end

    %storage capacity constraint
    constraint_capacity_storage = '';
    if apply_constraint_capacity_storage == 1
        if multiple_hubs == 0
            constraint_capacity_storage = '\n\t\tConstraint Storage_capacity_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_SOC(t,x) <= Storage_capacity(x);\n\t\t}';
        else
            constraint_capacity_storage = '\n\t\tConstraint Storage_capacity_constraint {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tDefinition: Storage_SOC(t,x,h) <= Storage_capacity(x,h);\n\t\t}';
        end
    end

    %minimum state of charge constraint
    constraint_min_soc_storage = '';
    if apply_constraint_min_soc_storage == 1
        if multiple_hubs == 0
            constraint_min_soc_storage = '\n\t\tConstraint Storage_minimum_SOC_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: Storage_SOC(t,x) >= Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
        else
            constraint_min_soc_storage = '\n\t\tConstraint Storage_minimum_SOC_constraint {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tDefinition: Storage_SOC(t,x,h) >= Storage_capacity(x,h) * Storage_min_SOC(x);\n\t\t}';
        end
    end

    %installation constraint for storage
    constraint_installation_storage = '';
    if apply_constraint_installation_storage == 1
        if multiple_hubs == 0
            constraint_installation_storage = '\n\t\tConstraint Storage_installation_constraint {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Storage_capacity(x) <= Big_M * Installation_storage(x);\n\t\t}';
        else
            constraint_installation_storage = '\n\t\tConstraint Storage_installation_constraint {\n\t\t\tIndexDomain: (x,h);\n\t\t\tDefinition: Storage_capacity(x,h) <= Big_M * Installation_storage(x,h);\n\t\t}';
        end
    end

    %installed techs constraint
    constraint_installed_storage_techs = '';
    if apply_constraint_installed_storage_techs == 1
        if multiple_hubs == 0
            constraint_installed_storage_techs = '\n\t\tConstraint Installed_storage_techs_constraint {\n\t\t\tIndexDomain: (x);\n\t\t\tDefinition: Installation_storage(x) = Installed_storage_techs(x);\n\t\t}';
        else
            constraint_installed_storage_techs = '\n\t\tConstraint Installed_storage_techs_constraint {\n\t\t\tIndexDomain: (x,h);\n\t\t\tDefinition: Installation_storage(x,h) = Installed_storage_techs(x,h);\n\t\t}';
        end
    end
    
    %min capacity constraint for storage
    constraint_min_capacity_storage = '';
    if apply_constraint_min_capacity_storage == 1
        if multiple_hubs == 0
            constraint_min_capacity_storage = '\n\t\tConstraint Storage_minimum_capacity_constraint {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Storage_capacity(x) >= Storage_minimum_capacity(x);\n\t\t}';
        else
            constraint_min_capacity_storage = '\n\t\tConstraint Storage_minimum_capacity_constraint {\n\t\t\tIndexDomain: (x,h);\n\t\t\tDefinition: Storage_capacity(x,h) >= Storage_minimum_capacity(x);\n\t\t}';
        end
    end

    %max capacity constraint for storage
    constraint_max_capacity_storage = '';
    if apply_constraint_max_capacity_storage == 1
        if multiple_hubs == 0
            constraint_max_capacity_storage = '\n\t\tConstraint Storage_maximum_capacity_constraint {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Storage_capacity(x) <= Storage_maximum_capacity(x);\n\t\t}';
        else
            constraint_max_capacity_storage = '\n\t\tConstraint Storage_maximum_capacity_constraint {\n\t\t\tIndexDomain: (x,h);\n\t\t\tDefinition: Storage_capacity(x,h) <= Storage_maximum_capacity(x);\n\t\t}';
        end
    end
    
    %min temperature constraint for thermal storage
    constraint_min_temperature_storage = '';
    if apply_constraint_min_temperature_storage == 1
        storage_types_with_temperature_constraints = unique_technologies.storage_techs_types(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        index_domain_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storage_types_with_temperature_constraints(t)),'''');
            if t < length(storage_types_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR x = '); 
            end
        end
        if multiple_hubs == 0
            constraint_min_temperature_storage = strcat('\n\t\tConstraint Storage_minimum_temperature_thermal_storage_constraint {\n\t\t\tIndexDomain: (t,x) | (x = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t,x) >= Min_temperature_thermal_storage(x);\n\t\t}');
        else
            constraint_min_temperature_storage = strcat('\n\t\tConstraint Storage_minimum_temperature_thermal_storage_constraint {\n\t\t\tIndexDomain: (t,x,h) | (x = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t,x,h) >= Min_temperature_thermal_storage(x);\n\t\t}');
        end
    end
    
    %max temperature constraint for thermal storage
    constraint_max_temperature_storage = '';
    if apply_constraint_max_temperature_storage == 1
        storage_types_with_temperature_constraints = unique_technologies.storage_techs_types(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        index_domain_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storage_types_with_temperature_constraints(t)),'''');
            if t < length(storage_types_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR x = '); 
            end
        end
        if multiple_hubs == 0
            constraint_max_temperature_storage = strcat('\n\t\tConstraint Storage_maximum_temperature_thermal_storage_constraint {\n\t\t\tIndexDomain: (t,x) | (x = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t,x) <= Max_temperature_thermal_storage(x);\n\t\t}');
        else
            constraint_max_temperature_storage = strcat('\n\t\tConstraint Storage_maximum_temperature_thermal_storage_constraint {\n\t\t\tIndexDomain: (t,x,h) | (x = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t,x,h) <= Max_temperature_thermal_storage(x);\n\t\t}');
        end
    end
    
    %thermal storage heat balance constraint
    constraint_thermal_storage_balance = '';
    if apply_constraint_thermal_storage_balance == 1
        storage_types_with_temperature_constraints = unique_technologies.storage_techs_types(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        index_domain_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storage_types_with_temperature_constraints(t)),'''');
            if t < length(storage_types_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR x = '); 
            end
        end
        if multiple_hubs == 0
            constraint_thermal_storage_balance = strcat('\n\t\tConstraint Thermal_storage_balance_constraint {\n\t\t\tIndexDomain: (t,x) | (x = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t+1,x) = Temperature_thermal_storage(t,x) + Storage_input_energy(t,x) / (Storage_capacity(x) * Thermal_storage_specific_heat(x)) - Storage_output_energy(t,x) / (Storage_capacity(x) * Thermal_storage_specific_heat(x));');
        else
            constraint_thermal_storage_balance = strcat('\n\t\tConstraint Thermal_storage_balance_constraint {\n\t\t\tIndexDomain: (t,x,h) | (x = ',index_domain_string,');\n\t\t\tDefinition: Temperature_thermal_storage(t+1,x,h) = Temperature_thermal_storage(t,x,h) + Storage_input_energy(t,x,h) / (Storage_capacity(x,h) * Thermal_storage_specific_heat(x)) - Storage_output_energy(t,x,h) / (Storage_capacity(x,h) * Thermal_storage_specific_heat(x));');
        end
    end    
    
end

constraints_section = strcat(constraints_section,constraint_energy_balance_storage,constraint_max_charging_rate_storage,constraint_max_discharging_rate_storage,constraint_capacity_storage,...
    constraint_min_soc_storage,constraint_installation_storage,constraint_installed_storage_techs,constraint_min_capacity_storage,constraint_max_capacity_storage,constraint_min_temperature_storage,constraint_max_temperature_storage,constraint_thermal_storage_balance);
