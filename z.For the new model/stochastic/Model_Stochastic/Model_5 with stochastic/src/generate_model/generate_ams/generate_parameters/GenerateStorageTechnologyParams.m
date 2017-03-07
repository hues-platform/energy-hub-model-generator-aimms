%% GENERATE COST PARAMS FOR ENERGY STORAGE TECHNOLOGIES

if simplified_storage_representation == 0

    %linear storage costs
    param_linear_storage_costs = '';
    if create_param_linear_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_capital_cost_variable(t)));
        end
        param_linear_storage_costs = strcat('\n\t\tParameter Linear_capital_costs_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %fixed storage costs
    param_fixed_storage_costs = '';
    if create_param_fixed_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_capital_cost_fixed(t)));
        end
        param_fixed_storage_costs = strcat('\n\t\tParameter Fixed_capital_costs_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage lifetimes
    param_storage_lifetimes = '';
    if create_param_storage_lifetimes == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_lifetime(t)));
        end
        param_storage_lifetimes = strcat('\n\t\tParameter Lifetime_storage {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    param_storage_CRF = '';
    if create_param_storage_CRF == 1
        param_storage_CRF = '\n\t\tParameter CRF_stor {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: Interest_rate/(1-(1/((1+Interest_rate)^(Lifetime_storage(stor)))));\n\t\t}';
    end

else
    
    %linear storage costs
    param_linear_storage_costs = '';
    if create_param_linear_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            technology_linear_storage_costs = unique_technologies.storage_techs_capital_cost_variable(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(technology_linear_storage_costs));
        end
        param_linear_storage_costs = strcat('\n\t\tParameter Linear_capital_costs_storage {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %fixed storage costs
    param_fixed_storage_costs = '';
    if create_param_fixed_storage_costs == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            technology_fixed_storage_costs2 = unique_technologies.storage_techs_capital_cost_fixed(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(technology_fixed_storage_costs2));
        end
        param_fixed_storage_costs = strcat('\n\t\tParameter Fixed_capital_costs_storage {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage lifetimes
    param_storage_lifetimes = '';
    if create_param_storage_lifetimes == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            energy_storage_technology_lifetimes = unique_technologies.storage_techs_lifetime(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(energy_storage_technology_lifetimes));
        end
        param_storage_lifetimes = strcat('\n\t\tParameter Lifetime_storage {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    param_storage_CRF = '';
    if create_param_storage_CRF == 1
        param_storage_CRF = '\n\t\tParameter CRF_stor {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: Interest_rate/(1-(1/((1+Interest_rate)^(Lifetime_storage(x)))));\n\t\t}';
    end
    
end

%% GENERATE TECHNICAL PARAMS FOR AMS FILE FOR ENERGY STORAGE TECHNOLOGIES

if simplified_storage_representation == 0

    %S matrix
    param_S_matrix = '';
    if create_param_S_matrix == 1
        S_matrix = '\n\t\tParameter Smatrix {\n\t\t\tIndexDomain: (x,stor);\n\t\t\tDefinition: { data { ';
        definition_string = '';
        for t=1:length(electricity_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(Elec,',char(electricity_storage_technologies(t)),'):1.0');
        end
        for t=1:length(heat_storage_technologies)
            definition_string = strcat(definition_string,',(Heat,',char(heat_storage_technologies(t)),'):1.0');
        end
        for t=1:length(cool_storage_technologies)
            definition_string = strcat(definition_string,',(Cool,',char(cool_storage_technologies(t)),'):1.0');
        end
        for t=1:length(dhw_storage_technologies)
            definition_string = strcat(definition_string,',(DHW,',char(dhw_storage_technologies(t)),'):1.0');
        end
        for t=1:length(anergy_storage_technologies)
            definition_string = strcat(definition_string,',(Anergy,',char(anergy_storage_technologies(t)),'):1.0');
        end
        param_S_matrix = strcat(S_matrix,definition_string,'}\n\t\t\t}\n\t\t}');
    end

    %storage maximum charging rate
    param_max_charge_rate = '';
    if create_param_max_charge_rate == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_max_charging_rate(t)));
        end
        param_max_charge_rate = strcat('\n\t\tParameter Storage_max_charge_rate {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum discharging rate
    param_max_discharge_rate = '';
    if create_param_max_discharge_rate == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_max_discharging_rate(t)));
        end
        param_max_discharge_rate = strcat('\n\t\tParameter Storage_max_discharge_rate {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage standing losses
    param_standing_losses = '';
    if create_param_standing_losses == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_decay(t)));
        end
        param_standing_losses = strcat('\n\t\tParameter Storage_standing_losses {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage charging efficiency
    param_charging_efficiency = '';
    if create_param_charging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_charging_efficiency(t)));
        end
        param_charging_efficiency = strcat('\n\t\tParameter Storage_charging_efficiency {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage discharging efficiency
    param_discharging_efficiency = '';
    if create_param_discharging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_discharging_efficiency(t)));
        end
        param_discharging_efficiency = strcat('\n\t\tParameter Storage_discharging_efficiency {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage minimum state of charge
    param_min_soc = '';
    if create_param_min_soc == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_min_state_of_charge(t)));
        end
        param_min_soc = strcat('\n\t\tParameter Storage_min_SOC {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage capacity
    %only used if we're not doing technology selection and sizing; otherwise this is set by the capacity variable
    param_storage_capacity = '';
    if create_param_storage_capacity == 1
        number_of_installed_storage_techs = length(installed_technologies.storage_techs_names);
        installed_electricity_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'Elec')));
        installed_heat_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'Heat')));
        installed_cool_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'Cool')));
        installed_dhw_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'DHW')));
        installed_anergy_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'Anergy')));
    
        installed_electricity_storage_capacity = installed_technologies.storage_techs_capacity(find(ismember(installed_technologies.storage_techs_types,{'Elec'})));
        installed_heat_storage_capacity = installed_technologies.storage_techs_capacity(find(ismember(installed_technologies.storage_techs_types,'Heat')));
        installed_cool_storage_capacity = installed_technologies.storage_techs_capacity(find(strcmp(installed_technologies.storage_techs_types,'Cool')));
        installed_dhw_storage_capacity = installed_technologies.storage_techs_capacity(find(strcmp(installed_technologies.storage_techs_types,'DHW')));
        installed_anergy_storage_capacity = installed_technologies.storage_techs_capacity(find(strcmp(installed_technologies.storage_techs_types,'Anergy')));

        installed_electricity_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Elec')));
        installed_heat_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Heat')));
        installed_cool_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Cool')));
        installed_dhw_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'DHW')));
        installed_anergy_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Anergy')));
    
        definition_string = '';
        if multiple_hubs == 0

            index_domain_string = '(stor)';
            i = 0;
            for t=1:length(installed_electricity_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Elec,',char(installed_electricity_storage_technologies(t)),'):',num2str(installed_electricity_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(installed_heat_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Heat,',char(installed_heat_storage_technologies(t)),'):',num2str(installed_heat_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(installed_cool_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Cool,',char(installed_cool_storage_technologies(t)),'):',num2str(installed_cool_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(installed_dhw_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(DHW,',char(installed_dhw_storage_technologies(t)),'):',num2str(installed_dhw_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(installed_anergy_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Anergy,',char(installed_anergy_storage_technologies(t)),'):',num2str(installed_anergy_storage_capacity(t)));
                i = 1 + 1;
            end

        else

            index_domain_string = '(stor,h)';
            i = 0;
            for t=1:length(installed_electricity_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Elec,',char(installed_electricity_storage_technologies(t)),',',num2str(installed_electricity_storage_node(t)),'):',num2str(installed_electricity_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(installed_heat_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Heat,',char(installed_heat_storage_technologies(t)),',',num2str(installed_heat_storage_node(t)),'):',num2str(installed_heat_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(installed_cool_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Cool,',char(installed_cool_storage_technologies(t)),',',num2str(installed_cool_storage_technology_node(t)),'):',num2str(installed_cool_storage_technology_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(installed_dhw_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(DHW,',char(installed_dhw_storage_technologies(t)),',',num2str(installed_dhw_storage_technology_node(t)),'):',num2str(installed_dhw_storage_technology_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(installed_anergy_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Anergy,',char(installed_anergy_storage_technologies(t)),',',num2str(installed_anergy_storage_technology_node(t)),'):',num2str(installed_anergy_storage_technology_capacity(t)));
                i = 1 + 1;
            end
        end
    
        param_storage_capacity = strcat('\n\t\tParameter Storage_capacity {\n\t\t\tIndexDomain: ',index_domain_string,';\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');

    end
    
    %storage minimum capacity
    param_min_capacity_storage = '';
    if create_param_min_capacity_storage == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_min_capacity(t)));
        end
        param_min_capacity_storage = strcat('\n\t\tParameter Storage_minimum_capacity {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum capacity
    param_max_capacity_storage = '';
    if create_param_max_capacity_storage == 1
        definition_string = '';
        for t=1:length(energy_storage_technologies)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_storage_technologies(t)),':',num2str(unique_technologies.storage_techs_max_capacity(t)));
        end
        param_max_capacity_storage = strcat('\n\t\tParameter Storage_maximum_capacity {\n\t\t\tIndexDomain: stor;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
    %thermal storage minimum temperature
    param_min_temperature_storage = '';
    if create_param_min_temperature_storage == 1
        min_temp_for_storages_with_temp_constraints = unique_technologies.storage_techs_min_temperature(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        definition_string = '';
        for t=1:length(storages_with_temperature_constraints)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(storages_with_temperature_constraints(t)),':',num2str(min_temp_for_storages_with_temp_constraints(t)));
        end
        index_domain_string = '';
        for t=1:length(storages_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storages_with_temperature_constraints(t)),'''');
            if t < length(storages_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR stor = '); 
            end
        end
        param_min_temperature_storage = strcat('\n\t\tParameter Min_temperature_thermal_storage {\n\t\t\tIndexDomain: stor | (stor = ',index_domain_string,');\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
    %thermal storage maximum temperature
    param_max_temperature_storage = '';
    if create_param_max_temperature_storage == 1
        max_temp_for_storages_with_temp_constraints = unique_technologies.storage_techs_max_temperature(find(~isnan(unique_technologies.storage_techs_max_temperature)));
        definition_string = '';
        for t=1:length(storages_with_temperature_constraints)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(storages_with_temperature_constraints(t)),':',num2str(max_temp_for_storages_with_temp_constraints(t)));
        end
        index_domain_string = '';
        for t=1:length(storages_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storages_with_temperature_constraints(t)),'''');
            if t < length(storages_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR stor = '); 
            end
        end
        param_max_temperature_storage = strcat('\n\t\tParameter Max_temperature_thermal_storage {\n\t\t\tIndexDomain: stor | (stor = ',index_domain_string,');\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
    %thermal storage specific heat
    param_thermal_storage_specific_heat = '';
    if create_param_thermal_storage_specific_heat == 1
        specific_heat_for_storages_with_temp_constraints = unique_technologies.storage_techs_specific_heat(find(~isnan(unique_technologies.storage_techs_specific_heat)));
        definition_string = '';
        for t=1:length(storages_with_temperature_constraints)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(storages_with_temperature_constraints(t)),':',num2str(specific_heat_for_storages_with_temp_constraints(t)));
        end
        index_domain_string = '';
        for t=1:length(storages_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storages_with_temperature_constraints(t)),'''');
            if t < length(storages_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR stor = '); 
            end
        end
        param_thermal_storage_specific_heat = strcat('\n\t\tParameter Thermal_storage_specific_heat {\n\t\t\tIndexDomain: stor | (stor = ',index_domain_string,');\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %installation (for pre-installed technologies)
    param_installed_storage_technologies = '';
    if create_param_installed_storage_technologies == 1
        number_of_installed_storage_techs = length(installed_technologies.storage_techs_names);
        definition_string = '';
        if multiple_hubs == 0
            index_domain_string = 'stor';
            for t=1:number_of_installed_storage_techs
                if t>1
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,char(installed_technologies.storage_techs_names(t)),' : 1');
            end      
        else
            index_domain_string = 'stor,h';
            for t=1:number_of_installed_storage_techs
                if t>1
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(',char(installed_technologies.storage_techs_names(t)),',',num2str(installed_technologies.storage_techs_node(t)),') : 1');
            end
        end
        param_installed_storage_technologies = strcat('\n\t\tParameter Installed_storage_techs {\n\t\t\tIndexDomain:(',index_domain_string,');\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');
    end

else
    
    %S matrix
    param_S_matrix = '';

    %storage maximum charging rate
    param_max_charge_rate = '';
    if create_param_max_charge_rate == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_max_charge_rate = unique_technologies.storage_techs_max_charging_rate(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_max_charge_rate));
        end
        param_max_charge_rate = strcat('\n\t\tParameter Storage_max_charge_rate {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage maximum discharging rate
    param_max_discharge_rate = '';
    if create_param_max_discharge_rate == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_max_discharge_rate = unique_technologies.storage_techs_max_discharging_rate(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_max_discharge_rate));
        end
        param_max_discharge_rate = strcat('\n\t\tParameter Storage_max_discharge_rate {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage standing losses
    param_standing_losses = '';
    if create_param_standing_losses == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_standing_losses = unique_technologies.storage_techs_decay(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_standing_losses));
        end
        param_standing_losses = strcat('\n\t\tParameter Storage_standing_losses {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage charging efficiency
    param_charging_efficiency = '';
    if create_param_charging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_charging_efficiency = unique_technologies.storage_techs_charging_efficiency(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_charging_efficiency));
        end
        param_charging_efficiency = strcat('\n\t\tParameter Storage_charging_efficiency {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage discharging efficiency
    param_discharging_efficiency = '';
    if create_param_discharging_efficiency == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_discharging_efficiency = unique_technologies.storage_techs_discharging_efficiency(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_discharging_efficiency));
        end
        param_discharging_efficiency = strcat('\n\t\tParameter Storage_discharging_efficiency {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %storage minimum state of charge
    param_min_soc = '';
    if create_param_min_soc == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_min_soc = unique_technologies.storage_techs_min_state_of_charge(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_min_soc));
        end
        param_min_soc = strcat('\n\t\tParameter Storage_min_SOC {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
    %storage capacity
    %only used if we're not doing technology selection and sizing; otherwise this is set by the capacity variable
    param_storage_capacity = '';
    if create_param_storage_capacity == 1
        number_of_installed_storage_techs = length(installed_technologies.storage_techs_names);
        electricity_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'Elec')));
        heat_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'Heat')));
        cool_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'Cool')));
        dhw_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'DHW')));
        anergy_storage_technologies = installed_technologies.storage_techs_names(find(strcmp(installed_technologies.storage_techs_types,'Anergy')));
    
        electricity_storage_capacity = installed_technologies.storage_techs_capacity(find(ismember(installed_technologies.storage_techs_types,{'Elec'})));
        heat_storage_capacity = installed_technologies.storage_techs_capacity(find(ismember(installed_technologies.storage_techs_types,'Heat')));
        cool_storage_capacity = installed_technologies.storage_techs_capacity(find(strcmp(installed_technologies.storage_techs_types,'Cool')));
        dhw_storage_capacity = installed_technologies.storage_techs_capacity(find(strcmp(installed_technologies.storage_techs_types,'DHW')));
        anergy_storage_capacity = installed_technologies.storage_techs_capacity(find(strcmp(installed_technologies.storage_techs_types,'Anergy')));

        electricity_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Elec')));
        heat_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Heat')));
        cool_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Cool')));
        dhw_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'DHW')));
        anergy_storage_node = installed_technologies.storage_techs_node(find(strcmp(installed_technologies.storage_techs_types,'Anergy')));
    
        definition_string = '';
        if multiple_hubs == 0

            index_domain_string = '(x)';
            i = 0;
            for t=1:length(electricity_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'Elec:',num2str(electricity_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(heat_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'Heat:',num2str(heat_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(cool_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'Cool:',num2str(cool_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(dhw_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'DHW:',num2str(dhw_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(anergy_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'Anergy:',num2str(anergy_storage_capacity(t)));
                i = 1 + 1;
            end

        else

            index_domain_string = '(x,h)';
            i = 0;
            for t=1:length(electricity_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Elec,',num2str(electricity_storage_node(t)),'):',num2str(electricity_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(heat_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Heat,',num2str(heat_storage_node(t)),'):',num2str(heat_storage_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(cool_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Cool,',num2str(cool_storage_technology_node(t)),'):',num2str(cool_storage_technology_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(dhw_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(DHW,',num2str(dhw_storage_technology_node(t)),'):',num2str(dhw_storage_technology_capacity(t)));
                i = 1 + 1;
            end
            for t=1:length(anergy_storage_technologies)
                if i > 0
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(Anergy,',num2str(anergy_storage_technology_node(t)),'):',num2str(anergy_storage_technology_capacity(t)));
                i = 1 + 1;
            end

        end
        param_storage_capacity = strcat('\n\t\tParameter Storage_capacity {\n\t\t\tIndexDomain: ',index_domain_string,';\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');

    end
    
    %storage minimum capacity
    param_min_capacity_storage = '';
    if create_param_min_capacity_storage == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_min_capacity = unique_technologies.storage_techs_min_capacity(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_min_capacity));
        end
        param_min_capacity_storage = strcat('\n\t\tParameter Storage_minimum_capacity {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
    %storage maximum capacity
    param_max_capacity_storage = '';
    if create_param_max_capacity_storage == 1
        definition_string = '';
        for t=1:length(energy_outputs)
            storage_max_capacity = unique_technologies.storage_techs_max_capacity(find(strcmp(unique_technologies.storage_techs_types,energy_outputs(t))));
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(energy_outputs(t)),':',num2str(storage_max_capacity));
        end
        param_max_capacity_storage = strcat('\n\t\tParameter Storage_maximum_capacity {\n\t\t\tIndexDomain: x;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
    %thermal storage minimum temperature
    param_min_temperature_storage = '';
    if create_param_min_temperature_storage == 1
        min_temp_for_storages_with_temp_constraints = unique_technologies.storage_techs_min_temperature(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        storage_types_with_temperature_constraints = unique_technologies.storage_techs_types(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        definition_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(storage_types_with_temperature_constraints(t)),':',num2str(min_temp_for_storages_with_temp_constraints(t)));
        end
        index_domain_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storage_types_with_temperature_constraints(t)),'''');
            if t < length(storage_types_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR x = '); 
            end
        end
        param_min_temperature_storage = strcat('\n\t\tParameter Min_temperature_thermal_storage {\n\t\t\tIndexDomain: x | (x = ',index_domain_string,');\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
    %thermal storage maximum temperature
    param_max_temperature_storage = '';
    if create_param_max_temperature_storage == 1
        max_temp_for_storages_with_temp_constraints = unique_technologies.storage_techs_max_temperature(find(~isnan(unique_technologies.storage_techs_max_temperature)));
        storage_types_with_temperature_constraints = unique_technologies.storage_techs_types(find(~isnan(unique_technologies.storage_techs_max_temperature)));
        definition_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(storage_types_with_temperature_constraints(t)),':',num2str(max_temp_for_storages_with_temp_constraints(t)));
        end
        index_domain_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storage_types_with_temperature_constraints(t)),'''');
            if t < length(storage_types_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR x = '); 
            end
        end
        param_max_temperature_storage = strcat('\n\t\tParameter Max_temperature_thermal_storage {\n\t\t\tIndexDomain: x | (x = ',index_domain_string,');\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end
    
    %thermal storage specific heat
    param_thermal_storage_specific_heat = '';
    if create_param_thermal_storage_specific_heat == 1
        specific_heat_for_storages_with_temp_constraints = unique_technologies.storage_techs_specific_heat(find(~isnan(unique_technologies.storage_techs_specific_heat)));
        storage_types_with_temperature_constraints = unique_technologies.storage_techs_types(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        definition_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            if t>1
                definition_string = strcat(definition_string,',');
            end
            definition_string = strcat(definition_string,char(storage_types_with_temperature_constraints(t)),':',num2str(specific_heat_for_storages_with_temp_constraints(t)));
        end
        index_domain_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storage_types_with_temperature_constraints(t)),'''');
            if t < length(storage_types_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR x = '); 
            end
        end
        param_thermal_storage_specific_heat = strcat('\n\t\tParameter Thermal_storage_specific_heat {\n\t\t\tIndexDomain: x | (x = ',index_domain_string,');\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
    end

    %installation (for pre-installed technologies)
    param_installed_storage_technologies = '';
    if create_param_installed_storage_technologies == 1
        number_of_installed_storage_techs = length(installed_technologies.storage_techs_names);
        definition_string = '';
        if multiple_hubs == 0
            index_domain_string = 'x';
            for t=1:number_of_installed_storage_techs
                if t>1
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,char(installed_technologies.storage_techs_types(t)),' : 1');
            end      
        else
            index_domain_string = 'x,h';
            for t=1:number_of_installed_storage_techs
                if t>1
                    definition_string = strcat(definition_string,', ');
                end
                definition_string = strcat(definition_string,'(',char(installed_technologies.storage_techs_types(t)),',',num2str(installed_technologies.storage_techs_node(t)),') : 1');
            end
        end
        param_installed_storage_technologies = strcat('\n\t\tParameter Installed_storage_techs {\n\t\t\tIndexDomain:(',index_domain_string,');\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');
    end
    
end

%compile technical parameters to string
params_section = strcat(params_section,param_linear_storage_costs,param_fixed_storage_costs,param_storage_lifetimes,param_storage_CRF,...
    param_S_matrix,param_max_charge_rate,param_max_discharge_rate,param_standing_losses,param_charging_efficiency,param_discharging_efficiency,param_min_soc,...
    param_storage_capacity,param_min_capacity_storage,param_max_capacity_storage,param_min_temperature_storage,param_max_temperature_storage,param_thermal_storage_specific_heat,param_installed_storage_technologies);
