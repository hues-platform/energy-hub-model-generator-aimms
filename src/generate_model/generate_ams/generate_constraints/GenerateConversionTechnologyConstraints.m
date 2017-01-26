%% GENERATE CONVERSION TECHNOLOGY CONSTRAINTS

%% GENERAL CONSTRAINTS

%energy balance constraint
constraint_energy_balance = '';
if apply_constraint_energy_balance == 1
    if multiple_hubs == 0
        if simplified_storage_representation == 0
            constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv) * Cmatrix(x,conv)) + sum(stor, (Storage_output_energy(t,stor) - Storage_input_energy(t,stor)) * Smatrix(x,stor)) = Loads(t,x) + Exported_energy_renewable(t,x) + Exported_energy_nonrenewable(t,x);\n\t\t}';
        else
            constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv) * Cmatrix(x,conv)) + Storage_output_energy(t,x) - Storage_input_energy(t,x) = Loads(t,x) + Exported_energy_renewable(t,x) + Exported_energy_nonrenewable(t,x);\n\t\t}';
        end
    else
        if simplified_storage_representation == 0
            constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv,h) * Cmatrix(x,conv)) + sum(stor, (Storage_output_energy(t,stor,h) - Storage_input_energy(t,stor,h)) * Smatrix(x,stor)) = Loads(t,x,h) + Exported_energy_renewable(t,x,h) + Exported_energy_nonrenewable(t,x,h) + sum(hh, Link_flow(t,x,hh,h) - Link_losses(t,x,hh,h) - Link_flow(t,x,h,hh));\n\t\t}';
        else
            constraint_energy_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x,h);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv,h) * Cmatrix(x,conv)) + Storage_output_energy(t,x,h) - Storage_input_energy(t,x,h) = Loads(t,x,h) + Exported_energy_renewable(t,x,h) + Exported_energy_nonrenewable(t,x,h) + sum(hh, Link_flow(t,x,hh,h) - Link_losses(t,x,hh,h) - Link_flow(t,x,h,hh));\n\t\t}';
        end
    end
end

%capacity violation constraint
constraint_capacity = '';
if apply_constraint_capacity == 1
    nonsolar_technologies = unique_technologies.conversion_techs_names(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')));
    index_domain_string = '';
    for t=1:length(nonsolar_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(nonsolar_technologies(t)),'''');
        if t < length(nonsolar_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_capacity = strcat('\n\t\tConstraint Capacity_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) <= Capacity(x,conv);\n\t\t}');
    else
        constraint_capacity = strcat('\n\t\tConstraint Capacity_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(x,conv) <= Capacity(x,conv,h);\n\t\t}');
    end       
end

%operation constraint
constraint_dispatch = '';
if apply_constraint_dispatch == 1
    if multiple_hubs == 0
        constraint_dispatch = strcat('\n\t\tConstraint Dispatch_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) <= Big_M * Operation(t,conv);\n\t\t}');
    else
        constraint_dispatch = strcat('\n\t\tConstraint Dispatch_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(x,conv) <= Big_M * Operation(t,conv,h);\n\t\t}');        
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
        constraint_installed_conversion_techs = '\n\t\tConstraint Installed_conversion_techs_constraint {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: Installation(x,conv) = Installed_conversion_techs(conv);\n\t\t}';
    else
        constraint_installed_conversion_techs = '\n\t\tConstraint Installed_conversion_techs_constraint {\n\t\t\tIndexDomain: (x,conv,h) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: Installation(x,conv,h) = Installed_conversion_techs(conv,h);\n\t\t}';
    end
end

%operation constraint
constraint_operation = '';
if apply_constraint_operation == 1
    if multiple_hubs == 0
        constraint_operation = strcat('\n\t\tConstraint Operation_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: Operation(t,conv) <= Installation(x,conv);\n\t\t}');
    else
        constraint_operation = strcat('\n\t\tConstraint Operation_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: Operation(t,conv,h) <= Installation(x,conv,h);\n\t\t}');    
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
        constraint_solar_availability = strcat('\n\t\tConstraint Solar_input_constraint {\n\t\t\tIndexDomain: (t,conv,x) | Cmatrix(x, conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) <= Solar_radiation(t) * Capacity(x,conv) / 1000;\n\t\t}');
    else
        constraint_solar_availability = strcat('\n\t\tConstraint Solar_input_constraint {\n\t\t\tIndexDomain: (t,conv,x,h) | Cmatrix(x, conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv,h) <= Solar_radiation(t,h) * Capacity(x,conv,h) / 1000;\n\t\t}');
    end
end



%% GRID-ASSOCIATED CONSTRAINTS

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
        constraint_grid_capacity_violation2 = '\n\t\tConstraint Grid_capacity_violation_constraint_export {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: Exported_energy_renewable(t,x) + Exported_energy_nonrenewable(t,x) <= Capacity_grid;\n\t\t}';
    else
        constraint_grid_capacity_violation2 = '\n\t\tConstraint Grid_capacity_violation_constraint_export {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: sum(h,Exported_energy_renewable(t,x,h) + Exported_energy_nonrenewable(t,x,h)) <= Capacity_grid;\n\t\t}';
    end
end

%solar export constraint
constraint_solar_export = '';
if apply_constraint_solar_export == 1
    technologies_with_electrical_output = unique_technologies.conversion_techs_names(union(find(strcmp(unique_technologies.conversion_techs_output_1,'Elec')),find(strcmp(unique_technologies.conversion_techs_output_2,'Elec'))));
    solar_technologies = unique_technologies.conversion_techs_names(find(strcmp(unique_technologies.conversion_techs_inputs,'Solar')));
    included_techs = intersect(technologies_with_electrical_output,solar_technologies);
    definition_string = '';
    for t=1:length(included_techs)
        definition_string = strcat(definition_string,'''',char(included_techs(t)),'''');
        if t < length(included_techs)
             definition_string = strcat(definition_string,' OR conv = '); 
        end
    end   
    if multiple_hubs == 0
        constraint_solar_export = strcat('\n\t\tConstraint Electricity_export_solar_constraint {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: Exported_energy_renewable(t,x) <= sum(conv | (conv = ',definition_string,'), Input_energy(t,conv) * Cmatrix(x,conv));\n\t\t}');
    else
        constraint_solar_export = strcat('\n\t\tConstraint Electricity_export_solar_constraint {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: sum(h,Exported_energy_renewable(t,x,h)) <= sum((h,conv) | (conv = ',definition_string,'), Input_energy(t,conv,h) * Cmatrix(x,conv));\n\t\t}');
    end
end

%nonsolar export constraint
constraint_nonsolar_export = '';
if apply_constraint_nonsolar_export == 1
    technologies_with_electrical_output = unique_technologies.conversion_techs_names(union(find(strcmp(unique_technologies.conversion_techs_output_1,'Elec')),find(strcmp(unique_technologies.conversion_techs_output_2,'Elec'))));
    nonsolar_nongrid_technologies = unique_technologies.conversion_techs_names(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))));
    included_techs = intersect(technologies_with_electrical_output,nonsolar_nongrid_technologies);
    definition_string = '';
    for t=1:length(included_techs)
        definition_string = strcat(definition_string,'''',char(included_techs(t)),'''');
        if t < length(included_techs)
             definition_string = strcat(definition_string,' OR conv = '); 
        end
    end   
    if multiple_hubs == 0
        constraint_solar_export = strcat('\n\t\tConstraint Electricity_export_nonsolar_constraint {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: Exported_energy_nonrenewable(t,x) <= sum(conv | (conv = ',definition_string,'), Input_energy(t,conv) * Cmatrix(x,conv));\n\t\t}');
    else
        constraint_solar_export = strcat('\n\t\tConstraint Electricity_export_nonsolar_constraint {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: sum(h,Exported_energy_nonrenewable(t,x,h)) <= sum((h,conv) | (conv = ',definition_string,'), Input_energy(t,conv,h) * Cmatrix(x,conv));\n\t\t}');
    end
end

%solar export constraint with net metering
constraint_solar_export_with_net_metering = '';
if apply_constraint_solar_export_with_net_metering == 1
    technologies_with_electrical_output = unique_technologies.conversion_techs_names(union(find(strcmp(unique_technologies.conversion_techs_output_1,'Elec')),find(strcmp(unique_technologies.conversion_techs_output_2,'Elec'))));
    solar_technologies = unique_technologies.conversion_techs_names(find(strcmp(unique_technologies.conversion_techs_inputs,'Solar')));
    included_techs = intersect(technologies_with_electrical_output,solar_technologies);
    definition_string = '';
    for t=1:length(included_techs)
        definition_string = strcat(definition_string,'''',char(included_techs(t)),'''');
        if t < length(included_techs)
             definition_string = strcat(definition_string,' OR conv = '); 
        end
    end   
    if multiple_hubs == 0
        constraint_solar_export_with_net_metering = strcat('\n\t\tConstraint Electricity_export_solar_constraint {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: Exported_energy_renewable(t,x) + Storage_input_energy(t,''Net_meter'') <= sum(conv | (conv = ',definition_string,'), Input_energy(t,conv) * Cmatrix(x,conv));\n\t\t}');
    else
        constraint_solar_export_with_net_metering = strcat('\n\t\tConstraint Electricity_export_solar_constraint {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tDefinition: sum(h,Exported_energy_renewable(t,x,h) + Storage_input_energy(t,''Net_meter'',h)) <= sum((h,conv) | (conv = ',definition_string,'), Input_energy(t,conv,h) * Cmatrix(x,conv));\n\t\t}');
    end
end

%% SINGLE OUTPUT TECHNOLOGY CONSTRAINTS

%min allowable capacity constraint
constraint_min_capacity = '';
if apply_constraint_min_capacity == 1
    included_techs = unique_technologies.conversion_techs_names(intersect(...
        intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))),...
        find(isnan(unique_technologies.conversion_techs_outputs_2))));
    index_domain_string = '';
    for t=1:length(included_techs)
        index_domain_string = strcat(index_domain_string,'''',char(included_techs(t)),'''');
        if t < length(included_techs)
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
if apply_constraint_max_capacity == 1
    included_techs = unique_technologies.conversion_techs_names(intersect(...
        intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))),...
        find(isnan(unique_technologies.conversion_techs_outputs_2))));
    index_domain_string = '';
    for t=1:length(included_techs)
        index_domain_string = strcat(index_domain_string,'''',char(included_techs(t)),'''');
        if t < length(included_techs)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_max_capacity = strcat('\n\t\tConstraint Maximum_capacity_constraint {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv) <= Max_allowable_capacity(conv);\n\t\t}');
    else
        constraint_max_capacity = strcat('\n\t\tConstraint Maximum_capacity_constraint {\n\t\t\tIndexDomain: (x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv,h) <= Max_allowable_capacity(conv);\n\t\t}');
    end
end

%roof area constraint
constraint_roof_area = '';
if apply_constraint_roof_area == 1
    included_techs = unique_technologies.conversion_techs_names(intersect(find(strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(isnan(unique_technologies.conversion_techs_outputs_2))));  
    index_domain_string = '';
    for t=1:length(included_techs)
        index_domain_string = strcat(index_domain_string,'''',char(included_techs(t)),'''');
            if t < length(included_techs)
                index_domain_string = strcat(index_domain_string,' OR conv = '); 
            end
    end
    if multiple_hubs == 0
        constraint_roof_area = strcat('\n\t\tConstraint Roof_area_constraint {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv) <= Building_roof_area;\n\t\t}');
    else
        constraint_roof_area = strcat('\n\t\tConstraint Roof_area_constraint {\n\t\t\tIndexDomain: (x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Capacity(x,conv,h) <= Building_roof_area(h);\n\t\t}');
    end
end

%minimum part load constraint
constraint_min_part_load = '';
if apply_constraint_min_part_load == 1
    index_domain_string = '';
    for t=1:length(energy_conversion_technologies_with_single_output)
        index_domain_string = strcat(index_domain_string,'''',char(energy_conversion_technologies_with_single_output(t)),'''');
        if t < length(energy_conversion_technologies_with_single_output)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        constraint_min_part_load = strcat('\n\t\tConstraint Part_load_constraint {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) + Big_M * (1 - Operation(t,conv)) >= Minimum_part_load(x,conv) * Capacity(x,conv);\n\t\t}');    
    else
        constraint_min_part_load = strcat('\n\t\tConstraint Part_load_constraint {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ',index_domain_string,');\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(x,conv) + Big_M * (1 - Operation(t,conv,h)) >= Minimum_part_load(x,conv) * Capacity(x,conv,h);\n\t\t}');    
    end
end

%% MULTI-OUTPUT TECHNOLOGY CONSTRAINTS

%max capacity constraint for multi-output technologies
constraint_max_capacity_multi_output_tech = '';
if apply_constraint_max_capacity_multi_output_tech == 0
    output_1_of_multi_output_techs = unique_technologies.conversion_techs_output_1(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    output_2_of_multi_output_techs = unique_technologies.conversion_techs_output_2(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    for t=1:length(energy_conversion_technologies_with_multiple_outputs)
        if multiple_hubs == 0
            constraint_max_capacity_multi_output_tech = strcat('\n\t\tConstraint Multi_output_max_capacity_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: conv | (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''');\n\t\t\tDefinition: Capacity(''',char(output_1_of_multi_output_techs(t)),''',conv) <= Max_allowable_capacity(conv);\n\t\t}');
        else
            constraint_max_capacity_multi_output_tech = strcat('\n\t\tConstraint Multi_output_max_capacity_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: (conv,h) | (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''');\n\t\t\tDefinition: Capacity(''',char(output_1_of_multi_output_techs(t)),''',conv,h) <= Max_allowable_capacity(conv);\n\t\t}');
        end 
    end
end

%min capacity constraint for multi-output technologies
constraint_min_capacity_multi_output_tech = '';
if apply_constraint_min_capacity_multi_output_tech == 0
    output_1_of_multi_output_techs = unique_technologies.conversion_techs_output_1(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    output_2_of_multi_output_techs = unique_technologies.conversion_techs_output_2(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    for t=1:length(energy_conversion_technologies_with_multiple_outputs)
        if multiple_hubs == 0
            constraint_min_capacity_multi_output_tech = strcat('\n\t\tConstraint Multi_output_min_capacity_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: conv | (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''');\n\t\t\tDefinition: Capacity(''',char(output_1_of_multi_output_techs(t)),''',conv) >= Min_allowable_capacity(conv);\n\t\t}');
        else
            constraint_min_capacity_multi_output_tech = strcat('\n\t\tConstraint Multi_output_min_capacity_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: (conv,h) | (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''');\n\t\t\tDefinition: Capacity(''',char(output_1_of_multi_output_techs(t)),''',conv,h) >= Min_allowable_capacity(conv);\n\t\t}');
        end 
    end
end

%output ratio constraint for multi-output technologies
constraint_output_ratio = '';
if apply_constraint_output_ratio == 0
    output_1_of_multi_output_techs = unique_technologies.conversion_techs_output_1(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    output_2_of_multi_output_techs = unique_technologies.conversion_techs_output_2(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    for t=1:length(energy_conversion_technologies_with_multiple_outputs)
        if multiple_hubs == 0
            constraint_output_ratio = strcat('\n\t\tConstraint Output_ratio_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: conv | (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''');\n\t\t\tDefinition: Capacity(''',char(output_2_of_multi_output_techs(t)),''',conv) = Cmatrix(''',char(output_2_of_multi_output_techs(t)),''', conv) / Cmatrix(''',char(output_1_of_multi_output_techs(t)),''', conv) * Capacity(''',char(output_1_of_multi_output_techs(t)),''',conv);\n\t\t}');
        else
            constraint_output_ratio = strcat('\n\t\tConstraint Output_ratio_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: (conv,h) | (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''');\n\t\t\tDefinition: Capacity(''',char(output_2_of_multi_output_techs(t)),''',conv,h) = Cmatrix(''',char(output_2_of_multi_output_techs(t)),''', conv) / Cmatrix(''',char(output_1_of_multi_output_techs(t)),''', conv) * Capacity(''',char(output_1_of_multi_output_techs(t)),''',conv,h);\n\t\t}');
        end 
    end
end

%installation constraint for multi-output technologies
constraint_multi_output_installation = '';
if apply_constraint_multi_output_installation == 1
    output_1_of_multi_output_techs = unique_technologies.conversion_techs_output_1(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    output_2_of_multi_output_techs = unique_technologies.conversion_techs_output_2(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    for t=1:length(energy_conversion_technologies_with_multiple_outputs)
        if multiple_hubs == 0
            constraint_multi_output_installation = strcat('\n\t\tConstraint Multi_output_installation_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: conv | (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''');\n\t\t\tDefinition: Installation(''',char(output_2_of_multi_output_techs(t)),''',conv) = Installation(''',char(output_1_of_multi_output_techs(t)),''',conv);\n\t\t}');
        else
            constraint_multi_output_installation = strcat('\n\t\tConstraint Multi_output_installation_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: (conv,h) | (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''');\n\t\t\tDefinition: Installation(''',char(output_2_of_multi_output_techs(t)),''',conv,h) = Installation(''',char(output_1_of_multi_output_techs(t)),''',conv,h);\n\t\t}');
        end 
    end
end

%minimum part load constraint
constraint_multi_output_min_part_load = '';
if apply_constraint_min_part_load == 1
    output_1_of_multi_output_techs = unique_technologies.conversion_techs_output_1(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    for t=1:length(energy_conversion_technologies_with_multiple_outputs)
        if multiple_hubs == 0
            constraint_multi_output_min_part_load = strcat('\n\t\tConstraint Multi_output_part_load_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0 AND (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''') AND (x = ''',char(output_1_of_multi_output_techs(t)),''');\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv) + Big_M * (1 - Operation(t,conv)) >= Minimum_part_load(x,conv) * Capacity(x,conv);\n\t\t}');    
        else
            constraint_multi_output_min_part_load = strcat('\n\t\tConstraint Multi_output_part_load_constraint_',char(energy_conversion_technologies_with_multiple_outputs(t)),' {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0 AND (conv = ''',char(energy_conversion_technologies_with_multiple_outputs(t)),''') AND (x = ''',char(output_1_of_multi_output_techs(t)),''');\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(x,conv) + Big_M * (1 - Operation(t,conv,h)) >= Minimum_part_load(x,conv) * Capacity(x,conv,h);\n\t\t}');    
        end
    end
end

%% COMPILE CONSTRAINTS

constraints_section = strcat(constraints_section,constraint_energy_balance,constraint_capacity,constraint_min_capacity,constraint_max_capacity,constraint_dispatch,constraint_min_part_load,...
    constraint_solar_availability,constraint_roof_area,constraint_installation,constraint_installed_conversion_techs,constraint_operation,...
    constraint_grid_capacity_violation1,constraint_grid_capacity_violation2,constraint_solar_export,constraint_nonsolar_export,constraint_solar_export_with_net_metering,...
    constraint_htp_ratio_heat,constraint_htp_ratio_dhw,constraint_htp_ratio_anergy,constraint_chp_heat,constraint_chp_dhw,constraint_chp_anergy,constraint_chp2);
