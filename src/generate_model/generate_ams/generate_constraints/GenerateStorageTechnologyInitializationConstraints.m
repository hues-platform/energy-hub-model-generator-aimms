%% GENERATE STORAGE SOC INITIALIZATION CONSTRAINTS

if simplified_storage_representation == 0

    %initialize storage to min soc
    constraint_storage_initialization_to_min_soc = '';
    if apply_constraint_electrical_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time);\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
        else
            constraint_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_1 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time);\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_capacity(stor,h) * Storage_min_SOC(stor);\n\t\t}');
        end
    end

    %storage must have same starting and ending charges
    constraint_storage_initialization_cyclical = '';
    if apply_constraint_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time);\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
        else
            constraint_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_2 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time);\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_SOC(last(Time),stor,h);\n\t\t}');
        end
    end

    %constraint disallowing discharging from storage in the first hour of the year
    constraint_storage_1st_hour = '';
    if apply_constraint_electrical_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time);\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
        else
            constraint_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_3 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time);\n\t\t\tDefinition: Storage_output_energy(t,stor,h) = 0;\n\t\t}');
        end
    end

else
    
    %initialize storage to min soc
    constraint_storage_initialization_to_min_soc = '';
    if apply_constraint_electrical_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time);\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}');
        else
            constraint_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_1 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time);\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_capacity(x,h) * Storage_min_SOC(x);\n\t\t}');
        end
    end

    %storage must have same starting and ending charges
    constraint_storage_initialization_cyclical = '';
    if apply_constraint_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time);\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}');
        else
            constraint_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_2 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time);\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_SOC(last(Time),x,h);\n\t\t}');
        end
    end

    %constraint disallowing discharging from storage in the first hour of the year
    constraint_storage_1st_hour = '';
    if apply_constraint_electrical_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time);\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}');
        else
            constraint_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_3 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time);\n\t\t\tDefinition: Storage_output_energy(t,x,h) = 0;\n\t\t}');
        end
    end
    
end

%% GENERATE THERMAL STORAGE TEMPERATURE INITIALIZATION CONSTRAINTS


if simplified_storage_representation == 0
    
    %thermal storage temperature initialization constraint
    constraint_thermal_storage_temperature_intialization = '';
    if apply_constraint_thermal_storage_temperature_intialization == 1
        index_domain_string = '';
        for t=1:length(storages_with_temperature_constraints(t))
            index_domain_string = strcat(index_domain_string,'''',char(storages_with_temperature_constraints(t)),'''');
            if t < length(storages_with_temperature_constraints(t))
                index_domain_string = strcat(index_domain_string,' OR stor = '); 
            end
        end
        if  multiple_hubs == 0
            constraint_thermal_storage_temperature_intialization = strcat('\n\t\tConstraint Thermal_storage_temperature_initialization_constraint {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,';\n\t\t\tDefinition: Temperature_thermal_storage(t,stor) = Temperature_thermal_storage(last(Time),stor);\n\t\t}');
        else
            constraint_thermal_storage_temperature_intialization = strcat('\n\t\tConstraint Thermal_storage_temperature_initialization_constraint {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,';\n\t\t\tDefinition: Temperature_thermal_storage(t,stor,h) = Temperature_thermal_storage(last(Time),stor,h);\n\t\t}');
        end
    end
    
else
    
    %thermal storage temperature initialization constraint
    constraint_thermal_storage_temperature_intialization = '';
    if apply_constraint_thermal_storage_temperature_intialization == 1
        storage_types_with_temperature_constraints = unique_technologies.storage_techs_types(find(~isnan(unique_technologies.storage_techs_min_temperature)));
        index_domain_string = '';
        for t=1:length(storage_types_with_temperature_constraints)
            index_domain_string = strcat(index_domain_string,'''',char(storage_types_with_temperature_constraints(t)),'''');
            if t < length(storage_types_with_temperature_constraints)
                index_domain_string = strcat(index_domain_string,' OR x = '); 
            end
        end
        if  multiple_hubs == 0
            constraint_thermal_storage_temperature_intialization = strcat('\n\t\tConstraint Thermal_storage_temperature_initialization_constraint {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ',index_domain_string,';\n\t\t\tDefinition: Temperature_thermal_storage(t,x) = Temperature_thermal_storage(last(Time),x);\n\t\t}');
        else
            constraint_thermal_storage_temperature_intialization = strcat('\n\t\tConstraint Thermal_storage_temperature_initialization_constraint {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ',index_domain_string,';\n\t\t\tDefinition: Temperature_thermal_storage(t,x,h) = Temperature_thermal_storage(last(Time),x,h);\n\t\t}');
        end
    end
    
end


%% COMPILE THE STRING

%compile storage constraints to string
constraints_section = strcat(constraints_section,constraint_storage_initialization_to_min_soc,constraint_storage_initialization_cyclical,constraint_storage_1st_hour,...
    constraint_thermal_storage_temperature_intialization);
