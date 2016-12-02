%% GENERATE STORAGE SOC INITIALIZATION CONSTRAINTS

if simplified_storage_representation == 0

    % ELECTRICAL STORAGE INITIALIZATION CONSTRAINTS

    %helper code for electrical storage initialization
    index_domain_string = '';
    for t=1:length(electricity_storage_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(electricity_storage_technologies(t)),'''');
        if t < length(electricity_storage_technologies)
             index_domain_string = strcat(index_domain_string,' OR stor = '); 
        end
    end

    %initialize electrical storage to min soc
    constraint_electrical_storage_initialization_to_min_soc = '';
    if apply_constraint_electrical_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_electrical_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
        else
            constraint_electrical_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity1 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_capacity(stor,h) * Storage_min_SOC(stor);\n\t\t}');
        end
    end

    %electrical storage must have same starting and ending charges
    constraint_electrical_storage_initialization_cyclical = '';
    if apply_constraint_electrical_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_electrical_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
        else
            constraint_electrical_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity2 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_SOC(last(Time),stor,h);\n\t\t}');
        end
    end

    %constraint disallowing discharging from electrical storage in the first hour of the year
    constraint_electrical_storage_1st_hour = '';
    if apply_constraint_electrical_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_electrical_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
        else
            constraint_electrical_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_electricity3 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor,h) = 0;\n\t\t}');
        end
    end

    % HEAT STORAGE INITIALIZATION CONSTRAINTS

    %helper code for heat storage initialization
    index_domain_string = '';
    for t=1:length(heat_storage_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(heat_storage_technologies(t)),'''');
        if t < length(heat_storage_technologies)
             index_domain_string = strcat(index_domain_string,' OR stor = '); 
        end
    end

    %initialize heat storage to min soc
    constraint_heat_storage_initialization_to_min_soc = '';
    if apply_constraint_heat_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_heat_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_heat1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
        else
            constraint_heat_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_heat1 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_capacity(stor,h) * Storage_min_SOC(stor);\n\t\t}');
        end
    end

    %heat storage must have same starting and ending charges
    constraint_heat_storage_initialization_cyclical = '';
    if apply_constraint_heat_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_heat_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_heat2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
        else
            constraint_heat_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_heat2 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_SOC(last(Time),stor,h);\n\t\t}');
        end
    end

    %constraint disallowing discharging from heat storage in the first hour of the year
    constraint_heat_storage_1st_hour = '';
    if apply_constraint_heat_storage_1st_hour == 1 
        if multiple_hubs == 0
            constraint_heat_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_heat3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
        else
            constraint_heat_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_heat3 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor,h) = 0;\n\t\t}');
        end
    end

    % COOL STORAGE INITIALIZATION CONSTRAINTS

    %helper code for cool storage initialization
    index_domain_string = '';
    for t=1:length(cool_storage_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(cool_storage_technologies(t)),'''');
        if t < length(cool_storage_technologies)
             index_domain_string = strcat(index_domain_string,' OR stor = '); 
        end
    end

    %initialize cool storage to min soc
    constraint_cool_storage_initialization_to_min_soc = '';
    if apply_constraint_cool_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_cool_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_cool1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
        else
            constraint_cool_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_cool1 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_capacity(stor,h) * Storage_min_SOC(stor);\n\t\t}');
        end
    end

    %cool storage must have same starting and ending charges
    constraint_cool_storage_initialization_cyclical = '';
    if apply_constraint_cool_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_cool_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_cool2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
        else
            constraint_cool_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_cool2 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_SOC(last(Time),stor,h);\n\t\t}');
        end
    end

    %constraint disallowing discharging from cool storage in the first hour of the year
    constraint_cool_storage_1st_hour = '';
    if apply_constraint_cool_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_cool_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_cool3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
        else
            constraint_cool_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_cool3 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor,h) = 0;\n\t\t}');
        end
    end

    % DHW STORAGE INITIALIZATION CONSTRAINTS

    %helper code for DHW storage initialization
    index_domain_string = '';
    for t=1:length(dhw_storage_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(dhw_storage_technologies(t)),'''');
        if t < length(dhw_storage_technologies)
             index_domain_string = strcat(index_domain_string,' OR stor = '); 
        end
    end

    %initialize DHW storage to min soc
    constraint_dhw_storage_initialization_to_min_soc = '';
    if apply_constraint_dhw_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_dhw_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_dhw1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
        else
            constraint_dhw_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_dhw1 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_capacity(stor,h) * Storage_min_SOC(stor);\n\t\t}');
        end
    end

    %DHW storage must have same starting and ending charges
    constraint_dhw_storage_initialization_cyclical = '';
    if apply_constraint_dhw_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_dhw_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_dhw2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
        else
            constraint_dhw_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_dhw2 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_SOC(last(Time),stor,h);\n\t\t}');
        end
    end

    %constraint disallowing discharging from DHW storage in the first hour of the year
    constraint_dhw_storage_1st_hour = '';
    if apply_constraint_dhw_storage_1st_hour == 1 
        if multiple_hubs == 0
            constraint_dhw_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_dhw3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
        else
            constraint_dhw_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_dhw3 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor,h) = 0;\n\t\t}');
        end
    end
    
    % ANERGY STORAGE INITIALIZATION CONSTRAINTS

    %helper code for Anergy storage initialization
    index_domain_string = '';
    for t=1:length(anergy_storage_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(anergy_storage_technologies(t)),'''');
        if t < length(anergy_storage_technologies)
             index_domain_string = strcat(index_domain_string,' OR stor = '); 
        end
    end

    %initialize Anergy storage to min soc
    constraint_anergy_storage_initialization_to_min_soc = '';
    if apply_constraint_anergy_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_anergy_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_anergy1 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_capacity(stor) * Storage_min_SOC(stor);\n\t\t}');
        else
            constraint_anergy_storage_initialization_to_min_soc = strcat('\n\t\tConstraint Storage_initialization_constraint_anergy1 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_capacity(stor,h) * Storage_min_SOC(stor);\n\t\t}');
        end
    end

    %Anergy storage must have same starting and ending charges
    constraint_anergy_storage_initialization_cyclical = '';
    if apply_constraint_anergy_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_anergy_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_anergy2 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor) = Storage_SOC(last(Time),stor);\n\t\t}');
        else
            constraint_anergy_storage_initialization_cyclical = strcat('\n\t\tConstraint Storage_initialization_constrain_anergy2 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_SOC(t,stor,h) = Storage_SOC(last(Time),stor,h);\n\t\t}');
        end
    end

    %constraint disallowing discharging from Anergy storage in the first hour of the year
    constraint_anergy_storage_1st_hour = '';
    if apply_constraint_anergy_storage_1st_hour == 1 
        if multiple_hubs == 0
            constraint_anergy_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_anergy3 {\n\t\t\tIndexDomain: (t,stor) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor) = 0;\n\t\t}');
        else
            constraint_anergy_storage_1st_hour = strcat('\n\t\tConstraint Storage_initialization_constraint_anergy3 {\n\t\t\tIndexDomain: (t,stor,h) | t = first(Time) AND (stor = ',index_domain_string,');\n\t\t\tDefinition: Storage_output_energy(t,stor,h) = 0;\n\t\t}');
        end
    end

else
    
    % ELECTRICAL STORAGE INITIALIZATION CONSTRAINTS

    %initialize electrical storage to min soc
    constraint_electrical_storage_initialization_to_min_soc = '';
    if apply_constraint_electrical_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_electrical_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_electricity1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
        else
            constraint_electrical_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_electricity1 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_capacity(x,h) * Storage_min_SOC(x);\n\t\t}';
        end
    end

    %electrical storage must have same starting and ending charges
    constraint_electrical_storage_initialization_cyclical = '';
    if apply_constraint_electrical_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_electrical_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constraint_electricity2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}';
        else
            constraint_electrical_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constraint_electricity2 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_SOC(last(Time),x,h);\n\t\t}';
        end
    end

    %constraint disallowing discharging from electrical storage in the first hour of the year
    constraint_electrical_storage_1st_hour = '';
    if apply_constraint_electrical_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_electrical_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_electricity3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}';
        else
            constraint_electrical_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_electricity3 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Elec'');\n\t\t\tDefinition: Storage_output_energy(t,x,h) = 0;\n\t\t}';
        end
    end

    % HEAT STORAGE INITIALIZATION CONSTRAINTS

    %initialize heat storage to min soc
    constraint_heat_storage_initialization_to_min_soc = '';
    if apply_constraint_heat_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_heat_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_heat1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time (x = ''Heat'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
        else
            constraint_heat_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_heat1 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time (x = ''Heat'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x,h) * Storage_min_SOC(x);\n\t\t}';
        end
    end

    %heat storage must have same starting and ending charges
    constraint_heat_storage_initialization_cyclical = '';
    if apply_constraint_heat_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_heat_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_heat2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Heat'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}';
        else
            constraint_heat_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_heat2 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Heat'');\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_SOC(last(Time),x,h);\n\t\t}';
        end
    end

    %constraint disallowing discharging from heat storage in the first hour of the year
    constraint_heat_storage_1st_hour = '';
    if apply_constraint_heat_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_heat_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_heat3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Heat'');\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}';
        else
            constraint_heat_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_heat3 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Heat'');\n\t\t\tDefinition: Storage_output_energy(t,x,h) = 0;\n\t\t}';
        end
    end

    % COOL STORAGE INITIALIZATION CONSTRAINTS

    %initialize cool storage to min soc
    constraint_cool_storage_initialization_to_min_soc = '';
    if apply_constraint_cool_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_cool_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_cool1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time (x = ''Cool'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
        else
            constraint_cool_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_cool1 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time (x = ''Cool'');\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_capacity(x,h) * Storage_min_SOC(x);\n\t\t}';
        end
    end

    %cool storage must have same starting and ending charges
    constraint_cool_storage_initialization_cyclical = '';
    if apply_constraint_cool_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_cool_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_cool2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Cool'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}';
        else
            constraint_cool_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_cool2 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Cool'');\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_SOC(last(Time),x,h);\n\t\t}';
        end
    end

    %constraint disallowing discharging from cool storage in the first hour of the year
    constraint_cool_storage_1st_hour = '';
    if apply_constraint_cool_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_cool_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_cool3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Cool'');\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}';
        else
            constraint_cool_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_cool3 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Cool'');\n\t\t\tDefinition: Storage_output_energy(t,x,h) = 0;\n\t\t}';
        end
    end

    % DHW STORAGE INITIALIZATION CONSTRAINTS

    %initialize DHW storage to min soc
    constraint_dhw_storage_initialization_to_min_soc = '';
    if apply_constraint_dhw_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_dhw_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_dhw1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time (x = ''dhw'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
        else
            constraint_dhw_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_dhw1 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time (x = ''DHW'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x,h) * Storage_min_SOC(x);\n\t\t}';
        end
    end

    %DHW storage must have same starting and ending charges
    constraint_dhw_storage_initialization_cyclical = '';
    if apply_constraint_dhw_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_dhw_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_dhw2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''DHW'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}';
        else
            constraint_dhw_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_dhw2 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''DHW'');\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_SOC(last(Time),x,h);\n\t\t}';
        end
    end

    %constraint disallowing discharging from DHW storage in the first hour of the year
    constraint_dhw_storage_1st_hour = '';
    if apply_constraint_dhw_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_dhw_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_dhw3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''DHW'');\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}';
        else
            constraint_dhw_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_dhw3 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''DHW'');\n\t\t\tDefinition: Storage_output_energy(t,x,h) = 0;\n\t\t}';
        end
    end
    
    % ANERGY STORAGE INITIALIZATION CONSTRAINTS

    %initialize Anergy storage to min soc
    constraint_anergy_storage_initialization_to_min_soc = '';
    if apply_constraint_anergy_storage_initialization_to_min_soc == 1
        if multiple_hubs == 0
            constraint_anergy_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_anergy1 {\n\t\t\tIndexDomain: (t,x) | t = first(Time (x = ''anergy'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x) * Storage_min_SOC(x);\n\t\t}';
        else
            constraint_anergy_storage_initialization_to_min_soc = '\n\t\tConstraint Storage_initialization_constraint_anergy1 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time (x = ''Anergy'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_capacity(x,h) * Storage_min_SOC(x);\n\t\t}';
        end
    end

    %Anergy storage must have same starting and ending charges
    constraint_anergy_storage_initialization_cyclical = '';
    if apply_constraint_anergy_storage_initialization_cyclical == 1
        if multiple_hubs == 0
            constraint_anergy_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_anergy2 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Anergy'');\n\t\t\tDefinition: Storage_SOC(t,x) = Storage_SOC(last(Time),x);\n\t\t}';
        else
            constraint_anergy_storage_initialization_cyclical = '\n\t\tConstraint Storage_initialization_constrain_anergy2 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Anergy'');\n\t\t\tDefinition: Storage_SOC(t,x,h) = Storage_SOC(last(Time),x,h);\n\t\t}';
        end
    end

    %constraint disallowing discharging from Anergy storage in the first hour of the year
    constraint_anergy_storage_1st_hour = '';
    if apply_constraint_anergy_storage_1st_hour == 1
        if multiple_hubs == 0
            constraint_anergy_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_anergy3 {\n\t\t\tIndexDomain: (t,x) | t = first(Time) AND (x = ''Anergy'');\n\t\t\tDefinition: Storage_output_energy(t,x) = 0;\n\t\t}';
        else
            constraint_anergy_storage_1st_hour = '\n\t\tConstraint Storage_initialization_constraint_anergy3 {\n\t\t\tIndexDomain: (t,x,h) | t = first(Time) AND (x = ''Anergy'');\n\t\t\tDefinition: Storage_output_energy(t,x,h) = 0;\n\t\t}';
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
constraints_section = strcat(constraints_section,constraint_electrical_storage_initialization_to_min_soc,constraint_electrical_storage_initialization_cyclical,...
    constraint_electrical_storage_1st_hour,constraint_heat_storage_initialization_to_min_soc,constraint_heat_storage_initialization_cyclical,constraint_heat_storage_1st_hour,...
    constraint_cool_storage_initialization_to_min_soc,constraint_cool_storage_initialization_cyclical,constraint_cool_storage_1st_hour,...
    constraint_dhw_storage_initialization_to_min_soc,constraint_dhw_storage_initialization_cyclical,constraint_dhw_storage_1st_hour,...
    constraint_anergy_storage_initialization_to_min_soc,constraint_anergy_storage_initialization_cyclical,constraint_anergy_storage_1st_hour,...
    constraint_thermal_storage_temperature_intialization);
