%% ENERGY STORAGE TECHNOLOGY VARIABLES

if simplified_storage_representation == 0

    %variable denoting the storage charging rate
    variable_storage_charge_rate = '';
    if create_variable_storage_charge_rate == 1
        if multiple_hubs == 0
            variable_storage_charge_rate = '\n\t\tVariable Storage_input_energy {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tRange: nonnegative;\n\t\t}';
        else
            variable_storage_charge_rate = '\n\t\tVariable Storage_input_energy {\n\t\t\tIndexDomain: (t,stor,h);\n\t\t\tRange: nonnegative;\n\t\t}';
        end
    end

    %variable denoting the storage discharging rate
    variable_storage_discharge_rate = '';
    if create_variable_storage_discharge_rate == 1
        if multiple_hubs == 0
            variable_storage_discharge_rate = '\n\t\tVariable Storage_output_energy {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tRange: nonnegative;\n\t\t}';
        else
            variable_storage_discharge_rate = '\n\t\tVariable Storage_output_energy {\n\t\t\tIndexDomain: (t,stor,h);\n\t\t\tRange: nonnegative;\n\t\t}';
        end
    end

    %variable denoting the state of charge of a storage
    variable_storage_soc = '';
    if create_variable_storage_soc == 1
        if multiple_hubs == 0
            variable_storage_soc = '\n\t\tVariable Storage_SOC {\n\t\t\tIndexDomain: (t,stor);\n\t\t\tRange: nonnegative;\n\t\t}';
        else
            variable_storage_soc = '\n\t\tVariable Storage_SOC {\n\t\t\tIndexDomain: (t,stor,h);\n\t\t\tRange: nonnegative;\n\t\t}';
        end
    end

    %variable denoting the capacity of a storage
    variable_storage_capacity = '';
    if create_variable_storage_capacity == 1
        if multiple_hubs == 0
            variable_storage_capacity = '\n\t\tVariable Storage_capacity {\n\t\t\tIndexDomain: (x,stor) | Smatrix(x,stor) > 0;\n\t\t\tRange: nonnegative;\n\t\t}';
        else
            variable_storage_capacity = '\n\t\tVariable Storage_capacity {\n\t\t\tIndexDomain: (x,stor,h) | Smatrix(x,stor) > 0;\n\t\t\tRange: nonnegative;\n\t\t}';
        end
    end

    %binary variable denoting the intallation of a storage
    variable_storage_installation = '';
    if create_variable_storage_installation == 1
        if multiple_hubs == 0
            variable_storage_installation = '\n\t\tVariable Installation_storage {\n\t\t\tIndexDomain: (x,stor) | Smatrix(x,stor) > 0;\n\t\t\tRange: binary;\n\t\t}';
        else
            variable_storage_installation = '\n\t\tVariable Installation_storage {\n\t\t\tIndexDomain: (x,stor,h) | Smatrix(x,stor) > 0;\n\t\t\tRange: binary;\n\t\t}';
        end
    end
    
    %variable denoting the temperature of a thermal storage
    variable_storage_temperature = '';
    if create_variable_storage_temperature == 1
        index_domain_string = '';
        for t=1:length(storages_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storages_with_temperature_constraints(t)),'''');
            if t < length(storages_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR stor = '); 
            end
        end
        if multiple_hubs == 0
            variable_storage_temperature = strcat('\n\t\tVariable Temperature_thermal_storage {\n\t\t\tIndexDomain: (t,stor) | stor = ',index_domain_string,';\n\t\t\tRange: free;\n\t\t}');
        else
            variable_storage_temperature = strcat('\n\t\tVariable Temperature_thermal_storage {\n\t\t\tIndexDomain: (t,stor,h) | stor = ',index_domain_string,';\n\t\t\tRange: free;\n\t\t}');
        end
    end
    
    variable_capital_cost_per_storage = '';
    if create_variable_capital_cost_per_storage == 1
        if multiple_hubs == 0
            variable_capital_cost_per_storage = '\n\t\tVariable Capital_cost_per_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: (Fixed_capital_costs_storage(stor) * Installation_storage(stor) + Linear_capital_costs_storage(stor) * Storage_capacity(stor)) * CRF_stor(stor);\n\t\t}';
        else
            variable_capital_cost_per_storage = '\n\t\tVariable Capital_cost_per_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum(h,Fixed_capital_costs_storage(stor) * Installation_storage(stor,h) + Linear_capital_costs_storage(stor) * Storage_capacity(stor,h)) * CRF_stor(stor);\n\t\t}';
        end
    end
    
    variable_total_cost_per_storage = '';
    if create_variable_total_cost_per_storage == 1
        variable_total_cost_per_storage = '\n\t\tVariable Total_cost_per_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tRange: free;\n\t\t\tDefinition: Capital_cost_per_storage(stor);\n\t\t}';
    end

else
    
    %variable denoting the storage charging rate
    variable_storage_charge_rate = '';
    if create_variable_storage_charge_rate == 1
        if multiple_hubs == 0
            variable_storage_charge_rate = '\n\t\tVariable Storage_input_energy {\n\t\t\tIndexDomain: (t,x);\n\t\t\tRange: nonnegative;\n\t\t}';
        else
            variable_storage_charge_rate = '\n\t\tVariable Storage_input_energy {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tRange: nonnegative;\n\t\t}';
        end
    end

    %variable denoting the storage discharging rate
    variable_storage_discharge_rate = '';
    if create_variable_storage_discharge_rate == 1
        if multiple_hubs == 0
            variable_storage_discharge_rate = '\n\t\tVariable Storage_output_energy {\n\t\t\tIndexDomain: (t,x);\n\t\t\tRange: nonnegative;\n\t\t}';
        else
            variable_storage_discharge_rate = '\n\t\tVariable Storage_output_energy {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tRange: nonnegative;\n\t\t}';
        end
    end

    %variable denoting the state of charge of a storage
    variable_storage_soc = '';
    if create_variable_storage_soc == 1
        if multiple_hubs == 0
            variable_storage_soc = '\n\t\tVariable Storage_SOC {\n\t\t\tIndexDomain: (t,x);\n\t\t\tRange: nonnegative;\n\t\t}';
        else
            variable_storage_soc = '\n\t\tVariable Storage_SOC {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tRange: nonnegative;\n\t\t}';
        end
    end

    %variable denoting the capacity of a storage
    variable_storage_capacity = '';
    if create_variable_storage_capacity == 1
        if multiple_hubs == 0
            variable_storage_capacity = '\n\t\tVariable Storage_capacity {\n\t\t\tIndexDomain: x;\n\t\t\tRange: nonnegative;\n\t\t}';
        else
            variable_storage_capacity = '\n\t\tVariable Storage_capacity {\n\t\t\tIndexDomain: (x,h);\n\t\t\tRange: nonnegative;\n\t\t}';
        end
    end

    %binary variable denoting the intallation of a storage
    variable_storage_installation = '';
    if create_variable_storage_installation == 1
        if multiple_hubs == 0
            variable_storage_installation = '\n\t\tVariable Installation_storage {\n\t\t\tIndexDomain: x;\n\t\t\tRange: binary;\n\t\t}';
        else
            variable_storage_installation = '\n\t\tVariable Installation_storage {\n\t\t\tIndexDomain: (x,h);\n\t\t\tRange: binary;\n\t\t}';
        end
    end
    
    %variable denoting the temperature of a thermal storage
    variable_storage_temperature = '';
    if create_variable_storage_temperature == 1
        storage_types_with_temperature_constraints = unique_technologies.storage_techs_types(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        index_domain_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storage_types_with_temperature_constraints(t)),'''');
            if t < length(storage_types_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR x = '); 
            end
        end
        if multiple_hubs == 0
            variable_storage_temperature = strcat('\n\t\tVariable Temperature_thermal_storage {\n\t\t\tIndexDomain: (t,x) | x = ',index_domain_string,';\n\t\t\tRange: free;\n\t\t}');
        else
            variable_storage_temperature = strcat('\n\t\tVariable Temperature_thermal_storage {\n\t\t\tIndexDomain: (t,x,h) | x = ',index_domain_string,';\n\t\t\tRange: free;\n\t\t}');
        end
    end
    
    variable_capital_cost_per_storage = '';
    if create_variable_capital_cost_per_storage == 1
        if multiple_hubs == 0
            variable_capital_cost_per_storage = '\n\t\tVariable Capital_cost_per_storage {\n\t\t\tIndexDomain: x;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: (Fixed_capital_costs_storage(x) * Installation_storage(x) + Linear_capital_costs_storage(x) * Storage_capacity(x)) * CRF_stor(x);\n\t\t}';
        else
            variable_capital_cost_per_storage = '\n\t\tVariable Capital_cost_per_storage {\n\t\t\tIndexDomain: x;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum(h, Fixed_capital_costs_storage(x) * Installation_storage(x,h) + Linear_capital_costs_storage(x) * Storage_capacity(x,h)) * CRF_stor(x);\n\t\t}';
        end
    end
    
    variable_total_cost_per_storage = '';
	if create_variable_total_cost_per_storage == 1
        variable_total_cost_per_storage = '\n\t\tVariable Total_cost_per_storage {\n\t\t\tIndexDomain: x;\n\t\t\tRange: free;\n\t\t\tDefinition: Capital_cost_per_storage(x);\n\t\t}';
	end
end

variables_section = strcat(variables_section,variable_storage_charge_rate,variable_storage_discharge_rate,variable_storage_soc,variable_storage_capacity,...
    variable_storage_installation,variable_capital_cost_per_storage,variable_total_cost_per_storage);