%% GENERATE CONVERSION TECHNOLOGY CONSTRAINTS

%% ENERGY BALANCE CONSTRAINT

%energy balance constraint
constraint_energy_balance = '';
if apply_constraint_energy_balance == 1
    if multiple_hubs == 0
        if simplified_storage_representation == 0
            constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv) * Cmatrix(x,conv)) + sum(stor, (Storage_output_energy(t,stor) - Storage_input_energy(t,stor)) * Smatrix(x,stor)) = Loads(t,x) + Exported_energy(t,x);\n\t\t}';
        else
            constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv) * Cmatrix(x,conv)) + Storage_output_energy(t,x) - Storage_input_energy(t,x) = Loads(t,x) + Exported_energy(t,x);\n\t\t}';
        end
    else
        if simplified_storage_representation == 0
            constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv,h) * Cmatrix(x,conv)) + sum(stor, (Storage_output_energy(t,stor,h) - Storage_input_energy(t,stor,h)) * Smatrix(x,stor)) = Loads(t,x,h) + Exported_energy(t,x,h) + sum(hh, Link_flow(t,x,hh,h) - Link_losses(t,x,hh,h) - Link_flow(t,x,h,hh));\n\t\t}';
        else
            constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv,h) * Cmatrix(x,conv)) + Storage_output_energy(t,x,h) - Storage_input_energy(t,x,h) = Loads(t,x,h) + Exported_energy(t,x,h) + sum(hh, Link_flow(t,x,hh,h) - Link_losses(t,x,hh,h) - Link_flow(t,x,h,hh));\n\t\t}';
        end
    end
end

%% CAPACITY AND OPERATION CONSTRAINTS

%capacity violation constraint
constraint_capacity = '';
if apply_constraint_capacity == 1
    index_domain_string = '';
    for t=1:length(dispatchable_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_technologies(t)),'''');
        if t < length(dispatchable_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_capacity = strcat('\n\t\tConstraint Capacity_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) <= Capacity(x,conv);\n\t\t}');
    else
        constraint_capacity = strcat('\n\t\tConstraint Capacity_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(x,conv) <= Capacity(x,conv,h);\n\t\t}');
    end       
end

%min allowable capacity constraint
constraint_min_capacity = '';
non_solar_energy_conversion_technologies_excluding_chp = unique_technologies.conversion_techs_names(intersect(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),...
    find(~ismember(unique_technologies.conversion_techs_outputs,{'"Heat,Elec"','"Elec,Heat"','"DHW,Elec"','"Elec,DHW"','"Anergy,Elec"','"Elec,Anergy"'}))),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))));
if apply_constraint_min_capacity == 1
    index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies_excluding_chp)
        index_domain_string = strcat(index_domain_string,'''',char(non_solar_energy_conversion_technologies_excluding_chp(t)),'''');
        if t < length(non_solar_energy_conversion_technologies_excluding_chp)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_min_capacity = strcat('\n\t\tConstraint Minimum_capacity_constraint {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv) >= Min_allowable_capacity(conv);\n\t\t}');
    else
        constraint_min_capacity = strcat('\n\t\tConstraint Minimum_capacity_constraint {\n\t\t\tIndexDomain: (x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv,h) >= Min_allowable_capacity(conv);\n\t\t}');
    end
end

%max allowable capacity constraint
constraint_max_capacity = '';
non_solar_energy_conversion_technologies_excluding_chp = unique_technologies.conversion_techs_names(intersect(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),...
    find(~ismember(unique_technologies.conversion_techs_outputs,{'"Heat,Elec"','"Elec,Heat"','"DHW,Elec"','"Elec,DHW"','"Anergy,Elec"','"Elec,Anergy"'}))),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))));
if apply_constraint_max_capacity == 1
    index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies_excluding_chp)
        index_domain_string = strcat(index_domain_string,'''',char(non_solar_energy_conversion_technologies_excluding_chp(t)),'''');
        if t < length(non_solar_energy_conversion_technologies_excluding_chp)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_max_capacity = strcat('\n\t\tConstraint Maximum_capacity_constraint {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv) <= Max_allowable_capacity(conv);\n\t\t}');
    else
        constraint_max_capacity = strcat('\n\t\tConstraint Maximum_capacity_constraint {\n\t\t\tIndexDomain: (x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv,h) <= Max_allowable_capacity(conv);\n\t\t}');
    end
end

%min allowable capacity contraint grid
constraint_min_capacity_grid = '';
if apply_constraint_min_capacity_grid == 1
    constraint_min_capacity_grid = strcat('\n\t\tConstraint Minimum_capacity_grid_constraint {\n\t\t\tDefinition: Capacity_grid >= Min_allowable_capacity_grid');
end

%max allowable capacity constraint grid
constraint_max_capacity_grid = '';
if apply_constraint_max_capacity_grid == 1
    constraint_max_capacity_grid = strcat('\n\t\tConstraint Maximum_capacity_grid_constraint {\n\t\t\tDefinition: Capacity_grid <= Max_allowable_capacity_grid');
end

%dispatch constraint
constraint_dispatch = '';
if apply_constraint_dispatch == 1
    index_domain_string = '';
    for t=1:length(technologies_excluding_grid)
        index_domain_string = strcat(index_domain_string,'''',char(technologies_excluding_grid(t)),'''');
        if t < length(technologies_excluding_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_dispatch = strcat('\n\t\tConstraint Dispatch_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) <= Big_M * Operation(t,conv);\n\t\t}');
    else
        constraint_dispatch = strcat('\n\t\tConstraint Dispatch_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(x,conv) <= Big_M * Operation(t,conv,h);\n\t\t}');        
    end
end

%minimum part load constraint
constraint_min_part_load = '';
if apply_constraint_min_part_load == 1
    index_domain_string = '';
    for t=1:length(technologies_excluding_grid)
        index_domain_string = strcat(index_domain_string,'''',char(technologies_excluding_grid(t)),'''');
        if t < length(technologies_excluding_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_min_part_load = strcat('\n\t\tConstraint Part_load_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) + Big_M * (1 - Operation(t,conv)) >= Minimum_part_load(x,conv) * Capacity(x,conv);\n\t\t}');    
    else
        constraint_min_part_load = strcat('\n\t\tConstraint Part_load_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(x,conv) + Big_M * (1 - Operation(t,conv,h)) >= Minimum_part_load(x,conv) * Capacity(x,conv,h);\n\t\t}');    
    end
end

%solar availability constraint
constraint_solar_availability = '';
if apply_constraint_solar_availability == 1
    index_domain_string = '';
    for t=1:length(solar_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(solar_technologies(t)),'''');
        if t < length(solar_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_solar_availability = strcat('\n\t\tConstraint Solar_input_constraint {\n\t\t\tIndexDomain: (t,conv,x) | Cmatrix(x, conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) = Solar_radiation(t) * Capacity(x,conv) / 1000;\n\t\t}');
    else
        constraint_solar_availability = strcat('\n\t\tConstraint Solar_input_constraint {\n\t\t\tIndexDomain: (t,conv,x,h) | Cmatrix(x, conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv,h) = Solar_radiation(t,h) * Capacity(x,conv,h) / 1000;\n\t\t}');
    end
end

%roof area constraint
constraint_roof_area = '';
solar_technologies_with_electrical_output = unique_technologies.conversion_techs_names(intersect(find(strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(ismember(unique_technologies.conversion_techs_outputs,{'Elec','"Heat,Elec"','"Elec,Heat"'}))));
solar_technologies_with_heat_output = unique_technologies.conversion_techs_names(intersect(find(ismember(unique_technologies.conversion_techs_inputs,'Solar')),find(ismember(unique_technologies.conversion_techs_outputs,{'Heat','"Heat,Elec"','"Elec,Heat"'}))));
solar_technologies_with_dhw_output = unique_technologies.conversion_techs_names(intersect(find(ismember(unique_technologies.conversion_techs_inputs,'Solar')),find(ismember(unique_technologies.conversion_techs_outputs,{'DHW','"DHW,Elec"','"Elec,DHW"'}))));
solar_technologies_with_anergy_output = unique_technologies.conversion_techs_names(intersect(find(ismember(unique_technologies.conversion_techs_inputs,'Solar')),find(ismember(unique_technologies.conversion_techs_outputs,{'Anergy','"Anergy,Elec"','"Elec,Anergy"'}))));
if apply_constraint_roof_area == 1
    definition_string = '';
        
    if multiple_hubs == 0
        for t = 1:length(solar_technologies_with_electrical_output)
            if t > 1
                definition_string = strcat(definition_string,'+');
            end
            definition_string = strcat(definition_string,'Capacity(''Elec'',''',char(solar_technologies_with_electrical_output(t)),''')');        
        end
        for t = 1:length(solar_technologies_with_heat_output)
            definition_string = strcat(definition_string,'+');
            definition_string = strcat(definition_string,'Capacity(''Heat'',''',char(solar_technologies_with_heat_output(t)),''')');
        end
        for t = 1:length(solar_technologies_with_dhw_output)
            definition_string = strcat(definition_string,'+');
            definition_string = strcat(definition_string,'Capacity(''DHW'',''',char(solar_technologies_with_dhw_output(t)),''')');
        end
        for t = 1:length(solar_technologies_with_anergy_output)
            definition_string = strcat(definition_string,'+');
            definition_string = strcat(definition_string,'Capacity(''Anergy'',''',char(solar_technologies_with_anergy_output(t)),''')');
        end
        constraint_roof_area = strcat('\n\t\tConstraint Roof_area_constraint {\n\t\t\tDefinition: ',definition_string,' <= Building_roof_area;\n\t\t}');
    else
        for t = 1:length(solar_technologies_with_electrical_output)
            if t > 1
                definition_string = strcat(definition_string,'+');
            end
            definition_string = strcat(definition_string,'Capacity(''Elec'',''',char(solar_technologies_with_electrical_output(t)),''',h)');        
        end
        for t = 1:length(solar_technologies_with_heat_output)
            definition_string = strcat(definition_string,'+');
            definition_string = strcat(definition_string,'Capacity(''Heat'',''',char(solar_technologies_with_heat_output(t)),''',h)');
        end
        for t = 1:length(solar_technologies_with_dhw_output)
            definition_string = strcat(definition_string,'+');
            definition_string = strcat(definition_string,'Capacity(''DHW'',''',char(solar_technologies_with_dhw_output(t)),''',h)');
        end
        for t = 1:length(solar_technologies_with_anergy_output)
            definition_string = strcat(definition_string,'+');
            definition_string = strcat(definition_string,'Capacity(''Anergy'',''',char(solar_technologies_with_anergy_output(t)),''',h)');
        end
        constraint_roof_area = strcat('\n\t\tConstraint Roof_area_constraint {\n\t\t\tIndexDomain: h;\n\t\t\tDefinition: ',definition_string,' <= Building_roof_area(h);\n\t\t}');
    end
end

%installation constraint
constraint_installation = '';
if apply_constraint_installation == 1
    if multiple_hubs == 0
        constraint_installation = '\n\t\tConstraint Installation_constraint {\n\t\t\tIndexDomain: (x,conv);\n\t\t\tDefinition: Capacity(x,conv) <= Big_M * Installation(x,conv);\n\t\t}';
    else
        constraint_installation = '\n\t\tConstraint Installation_constraint {\n\t\t\tIndexDomain: (x,conv,h);\n\t\t\tDefinition: Capacity(x,conv,h) <= Big_M * Installation(x,conv,h);\n\t\t}';
    end
end

%installed techs constraint
constraint_installed_conversion_techs = '';
if apply_constraint_installed_conversion_techs == 1
    if multiple_hubs == 0
        constraint_installed_conversion_techs = '\n\t\tConstraint Installed_conversion_techs_constraint {\n\t\t\tIndexDomain: (x,conv);\n\t\t\tDefinition: Installation(x,conv) = Installed_conversion_techs(conv);\n\t\t}';
    else
        constraint_installed_conversion_techs = '\n\t\tConstraint Installed_conversion_techs_constraint {\n\t\t\tIndexDomain: (x,conv,h);\n\t\t\tDefinition: Installation(x,conv,h) = Installed_conversion_techs(conv,h);\n\t\t}';
    end
end

%operation constraint
constraint_operation = '';
if apply_constraint_operation == 1
    dispatchable_techs_including_grid = unique_technologies.conversion_techs_names(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')));
    index_domain_string = '';
    for t=1:length(dispatchable_techs_including_grid)
        index_domain_string = strcat(index_domain_string,'''',char(dispatchable_techs_including_grid(t)),'''');
        if t < length(dispatchable_techs_including_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_operation = strcat('\n\t\tConstraint Operation_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Operation(t,conv) <= Installation(x,conv);\n\t\t}');
    else
        constraint_operation = strcat('\n\t\tConstraint Operation_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Operation(t,conv,h) <= Installation(x,conv,h);\n\t\t}');    
    end
end

%I don't think this is necessary
%electricity export constraint
% constraint_electricity_export = '';
% if apply_constraint_electricity_export == 1
%     if multiple_hubs == 0
%         constraint_electricity_export = '\n\t\tConstraint Electricity_export_constraint {\n\t\t\tIndexDomain: (t,x,conv) | x=''Elec'' AND conv=''Grid'';\n\t\t\tDefinition: Exported_energy(t,x) <= Big_M * (1 - Operation(t,conv));\n\t\t}';
%     else
%         constraint_electricity_export = '\n\t\tConstraint Electricity_export_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | x=''Elec'' AND conv=''Grid'';\n\t\t\tDefinition: Exported_energy(t,x,h) <= Big_M * (1 - Operation(t,conv,h));\n\t\t}';
%     end
% end

%grid capacity violation constraint 1 (electricity imports)
constraint_grid_capacity_violation1 = '';
if apply_constraint_grid_capacity_violation1 == 1
    if multiple_hubs == 0
        constraint_grid_capacity_violation1 = '\n\t\tConstraint Grid_capacity_violation_constraint_import {\n\t\t\tIndexDomain: (t,conv) | conv=''Grid'';\n\t\t\tDefinition: Input_energy(t,conv) <= Capacity_grid;\n\t\t}';
    else
        constraint_grid_capacity_violation1 = '\n\t\tConstraint Grid_capacity_violation_constraint_import {\n\t\t\tIndexDomain: (t,conv) | conv=''Grid'';\n\t\t\tDefinition: sum(h,Input_energy(t,conv,h)) <= Capacity_grid;\n\t\t}';
    end
end

%grid capacity violation constraint 2 (electricity exports)
constraint_grid_capacity_violation2 = '';
if apply_constraint_grid_capacity_violation2 == 1
    if multiple_hubs == 0
        constraint_grid_capacity_violation2 = '\n\t\tConstraint Grid_capacity_violation_constraint_export {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: Exported_energy(t,x) <= Capacity_grid;\n\t\t}';
    else
        constraint_grid_capacity_violation2 = '\n\t\tConstraint Grid_capacity_violation_constraint_export {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: sum(h,Exported_energy(t,x,h)) <= Capacity_grid;\n\t\t}';
    end
end

%% CHP CONSTRAINTS

%heat-to-power ratio constraint for heat generating CHP technologies
constraint_htp_ratio_heat = '';
if apply_constraint_htp_ratio_heat == 1
    index_domain_string = '';
    for t=1:length(chp_heat_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_heat_technologies(t)),'''');
        if t < length(chp_heat_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_htp_ratio_heat = strcat('\n\t\tConstraint Heat_CHP_HTP_constraint {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Heat'',conv) = Cmatrix(''Heat'', conv) / Cmatrix(''Elec'', conv) * Capacity(''Elec'',conv);\n\t\t}');
    else
        constraint_htp_ratio_heat = strcat('\n\t\tConstraint Heat_CHP_HTP_constraint {\n\t\t\tIndexDomain: (conv,h) | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Heat'',conv,h) = Cmatrix(''Heat'', conv) / Cmatrix(''Elec'', conv) * Capacity(''Elec'',conv,h);\n\t\t}');
    end
end

%heat-to-power ratio constraint for DHW generating CHP technologies
constraint_htp_ratio_dhw = '';
if apply_constraint_htp_ratio_dhw == 1
    index_domain_string = '';
    for t=1:length(chp_dhw_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_dhw_technologies(t)),'''');
        if t < length(chp_dhw_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_htp_ratio_dhw = strcat('\n\t\tConstraint DHW_CHP_HTP_constraint {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''DHW'',conv) = Cmatrix(''DHW'', conv) / Cmatrix(''Elec'', conv) * Capacity(''Elec'',conv);\n\t\t}');
    else
        constraint_htp_ratio_dhw = strcat('\n\t\tConstraint DHW_CHP_HTP_constraint {\n\t\t\tIndexDomain: (conv,h) | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''DHW'',conv,h) = Cmatrix(''DHW'', conv) / Cmatrix(''Elec'', conv) * Capacity(''Elec'',conv,h);\n\t\t}');
    end
end

%heat-to-power ratio constraint for anergy generating CHP technologies
constraint_htp_ratio_anergy = '';
if apply_constraint_htp_ratio_anergy == 1
    index_domain_string = '';
    for t=1:length(chp_anergy_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_anergy_technologies(t)),'''');
        if t < length(chp_anergy_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_htp_ratio_anergy = strcat('\n\t\tConstraint Anergy_CHP_HTP_constraint {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Anergy'',conv) = Cmatrix(''Anergy'', conv) / Cmatrix(''Elec'', conv) * Capacity(''Elec'',conv);\n\t\t}');
    else
        constraint_htp_ratio_anergy = strcat('\n\t\tConstraint Anergy_CHP_HTP_constraint {\n\t\t\tIndexDomain: (conv,h) | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Anergy'',conv,h) = Cmatrix(''Anergy'', conv) / Cmatrix(''Elec'', conv) * Capacity(''Elec'',conv,h);\n\t\t}');
    end
end

%heat chp constraint
constraint_chp_heat = '';
if apply_constraint_chp_heat == 1
    index_domain_string = '';
    for t=1:length(chp_heat_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_heat_technologies(t)),'''');
        if t < length(chp_heat_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_chp_heat = strcat('\n\t\tConstraint Heat_CHP_HTP_constraint2 {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Installation(''Elec'',conv) = Installation(''Heat'',conv);\n\t\t}');
    else
        constraint_chp_heat = strcat('\n\t\tConstraint Heat_CHP_HTP_constraint2 {\n\t\t\tIndexDomain: (conv,h) | (conv = ',index_domain_string,');\n\t\t\tDefinition: Installation(''Elec'',conv,h) = Installation(''Heat'',conv,h);\n\t\t}');
    end
end

%dhw chp constraint
constraint_chp_dhw = '';
if apply_constraint_chp_dhw == 1
    index_domain_string = '';
    for t=1:length(chp_dhw_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_dhw_technologies(t)),'''');
        if t < length(chp_dhw_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_chp_dhw = strcat('\n\t\tConstraint DHW_CHP_HTP_constraint2 {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Installation(''Elec'',conv) = Installation(''DHW'',conv);\n\t\t}');
    else
        constraint_chp_dhw = strcat('\n\t\tConstraint DHW_CHP_HTP_constraint2 {\n\t\t\tIndexDomain: (conv,h) | (conv = ',index_domain_string,');\n\t\t\tDefinition: Installation(''Elec'',conv,h) = Installation(''DHW'',conv,h);\n\t\t}');
    end
end

%anergy chp constraint
constraint_chp_anergy = '';
if apply_constraint_chp_anergy == 1
    index_domain_string = '';
    for t=1:length(chp_anergy_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_anergy_technologies(t)),'''');
        if t < length(chp_anergy_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_chp_anergy = strcat('\n\t\tConstraint Anergy_CHP_HTP_constraint2 {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Installation(''Elec'',conv) = Installation(''Anergy'',conv);\n\t\t}');
    else
        constraint_chp_anergy = strcat('\n\t\tConstraint Anergy_CHP_HTP_constraint2 {\n\t\t\tIndexDomain: (conv,h) | (conv = ',index_domain_string,');\n\t\t\tDefinition: Installation(''Elec'',conv,h) = Installation(''Anergy'',conv,h);\n\t\t}');
    end
end

%electrical capacity constraint
constraint_chp2 = '';
if apply_constraint_chp2 == 1
    index_domain_string = '';
    for t=1:length(chp_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(chp_technologies(t)),'''');
        if t < length(chp_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_chp2 = strcat('\n\t\tConstraint CHP_installation_constraint {\n\t\t\tIndexDomain: conv | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Elec'',conv) <= Max_allowable_capacity(conv) * Installation(''Elec'',conv);\n\t\t}');
    else
        constraint_chp2 = strcat('\n\t\tConstraint CHP_installation_constraint {\n\t\t\tIndexDomain: (conv,h) | (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(''Elec'',conv,h) <= Max_allowable_capacity(conv) * Installation(''Elec'',conv,h);\n\t\t}');
    end
end

%% COMPILE CONSTRAINTS

constraints_section = strcat(constraints_section,constraint_energy_balance,constraint_capacity,constraint_min_capacity,constraint_max_capacity,constraint_dispatch,constraint_min_part_load,...
    constraint_solar_availability,constraint_roof_area,constraint_installation,constraint_installed_conversion_techs,constraint_operation,...
    constraint_grid_capacity_violation1,constraint_grid_capacity_violation2,constraint_htp_ratio_heat,constraint_htp_ratio_dhw,constraint_htp_ratio_anergy,...
    constraint_chp_heat,constraint_chp_dhw,constraint_chp_anergy,constraint_chp2);
