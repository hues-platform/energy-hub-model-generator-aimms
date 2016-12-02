%% ENERGY CONVERSION TECHNOLOGY VARIABLES

%variable denoting input energy streams of energy conversion devices
variable_input_streams = '';
if create_variable_input_streams == 1
    if multiple_hubs == 0
        variable_input_streams = '\n\t\tVariable Input_energy {\n\t\t\tIndexDomain: (t,conv);\n\t\t\tRange: nonnegative;\n\t\t}';
    else
        variable_input_streams = '\n\t\tVariable Input_energy {\n\t\t\tIndexDomain: (t,conv,h);\n\t\t\tRange: nonnegative;\n\t\t}';
    end
        
end

%variable denoting exported energy
variable_exported_energy = '';
if create_variable_exported_energy == 1
    if multiple_hubs == 0
        variable_exported_energy = '\n\t\tVariable Exported_energy {\n\t\t\tIndexDomain: (t,x) | x = "Elec";\n\t\t\tRange: nonnegative;\n\t\t}';
    else
        variable_exported_energy = '\n\t\tVariable Exported_energy {\n\t\t\tIndexDomain: (t,x,h) | x = "Elec";\n\t\t\tRange: nonnegative;\n\t\t}';
    end
end

%binary variable denoting the installation of a technology
variable_technology_installation = '';
if create_variable_technology_installation == 1
    if multiple_hubs == 0
        variable_technology_installation = '\n\t\tVariable Installation {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tRange: binary;\n\t\t}';
    else
        variable_technology_installation = '\n\t\tVariable Installation {\n\t\t\tIndexDomain: (x,conv,h) | Cmatrix(x,conv) > 0;\n\t\t\tRange: binary;\n\t\t}';
    end
end

%binary variable denoting the operation or not of a dispatchable technology
variable_technology_operation = '';
if create_variable_technology_operation == 1
    index_domain_string = '';
    for t=1:length(technologies_excluding_grid)
        index_domain_string = strcat(index_domain_string,'''',char(technologies_excluding_grid(t)),'''');
        if t < length(technologies_excluding_grid)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end
    if multiple_hubs == 0
        variable_technology_operation = strcat('\n\t\tVariable Operation {\n\t\t\tIndexDomain: (t,conv) | (conv = ',index_domain_string,');\n\t\t\tRange: binary;\n\t\t}');
    else
        variable_technology_operation = strcat('\n\t\tVariable Operation {\n\t\t\tIndexDomain: (t,conv,h) | (conv = ',index_domain_string,');\n\t\t\tRange: binary;\n\t\t}');
    end 
end

%variable denoting the generation capacity of a technology
variable_technology_capacity = '';
if create_variable_technology_capacity == 1
    if multiple_hubs == 0
        variable_technology_capacity = '\n\t\tVariable Capacity {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0 AND conv <> ''Grid'';\n\t\t\tRange: nonnegative;\n\t\t}';
    else
        variable_technology_capacity = '\n\t\tVariable Capacity {\n\t\t\tIndexDomain: (x,conv,h) | Cmatrix(x,conv) > 0 AND conv <> ''Grid'';\n\t\t\tRange: nonnegative;\n\t\t}';
    end
end

%variable denoting the capacity of the grid connection
variable_grid_capacity = '';
if create_variable_grid_capacity == 1
    variable_grid_capacity = '\n\t\tVariable Capacity_grid {\n\t\t\tRange: nonnegative;\n\t\t}';
end

%variable denoting the electricity output energy of a technology
variable_electricity_output = '';
if create_variable_electricity_output == 1
    if multiple_hubs == 0
        variable_electricity_output = '\n\t\tVariable Output_energy_electricity  {\n\t\t\tIndexDomain: (t,conv) | Cmatrix(''Elec'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(''Elec'',conv);\n\t\t}';
    else
        variable_electricity_output = '\n\t\tVariable Output_energy_electricity  {\n\t\t\tIndexDomain: (t,conv,h) | Cmatrix(''Elec'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(''Elec'',conv);\n\t\t}';
    end
end

%variable denoting the heat output energy of a technology
variable_heat_output = '';
if create_variable_heat_output == 1
    if multiple_hubs == 0
        variable_heat_output = '\n\t\tVariable Output_energy_heat {\n\t\t\tIndexDomain: (t,conv) | Cmatrix(''Heat'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(''Heat'',conv);\n\t\t}';
    else
        variable_heat_output = '\n\t\tVariable Output_energy_heat {\n\t\t\tIndexDomain: (t,conv,h) | Cmatrix(''Heat'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(''Heat'',conv);\n\t\t}';
    end
end

%variable denoting the cooling output energy of a technology
variable_cool_output = '';
if create_variable_cool_output == 1
    if multiple_hubs == 0
        variable_cool_output = '\n\t\tVariable Output_energy_cool {\n\t\t\tIndexDomain: (t,conv) | Cmatrix(''Cool'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(''Cool'',conv);\n\t\t}';
    else
        variable_cool_output = '\n\t\tVariable Output_energy_cool {\n\t\t\tIndexDomain: (t,conv,h) | Cmatrix(''Cool'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(''Cool'',conv);\n\t\t}';
    end
end

%variable denoting the dhw output energy of a technology
variable_dhw_output = '';
if create_variable_dhw_output == 1
    if multiple_hubs == 0
        variable_dhw_output = '\n\t\tVariable Output_energy_DHW {\n\t\t\tIndexDomain: (t,conv) | Cmatrix(''DHW'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(''DHW'',conv);\n\t\t}';
    else
        variable_dhw_output = '\n\t\tVariable Output_energy_DHW {\n\t\t\tIndexDomain: (t,conv,h) | Cmatrix(''DHW'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(''DHW'',conv);\n\t\t}';
    end
end

%variable denoting the anergy output energy of a technology
variable_anergy_output = '';
if create_variable_anergy_output == 1
    if multiple_hubs == 0
        variable_anergy_output = '\n\t\tVariable Output_energy_anergy {\n\t\t\tIndexDomain: (t,conv) | Cmatrix(''Anergy'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(''Anergy'',conv);\n\t\t}';
    else
        variable_anergy_output = '\n\t\tVariable Output_energy_anergy {\n\t\t\tIndexDomain: (t,conv,h) | Cmatrix(''Anergy'',conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(''Anergy'',conv);\n\t\t}';
    end
end

variable_operating_cost_per_technology = '';
if create_variable_operating_cost_per_technology
    if multiple_hubs == 0
        variable_operating_cost_per_technology = '\n\t\tVariable Operating_cost_per_technology {\n\t\t\tIndexDomain: conv | conv <> ''Grid'';\n\t\t\tRange: free;\n\t\t\tDefinition: Operating_costs(conv) * sum(t,Input_energy(t,conv));\n\t\t}';
    else
        variable_operating_cost_per_technology = '\n\t\tVariable Operating_cost_per_technology {\n\t\t\tIndexDomain: conv | conv <> ''Grid'';\n\t\t\tRange: free;\n\t\t\tDefinition: Operating_costs(conv) * sum((t,h),Input_energy(t,conv,h));\n\t\t}';
    end    
end

variable_maintenance_cost_per_technology = '';
if create_variable_maintenance_cost_per_technology
    if multiple_hubs == 0
        variable_maintenance_cost_per_technology = '\n\t\tVariable Maintenance_cost_per_technology {\n\t\t\tIndexDomain: conv;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((t,x), Maintenance_cost_per_timestep(t,conv,x));\n\t\t}';
    else
        variable_maintenance_cost_per_technology = '\n\t\tVariable Maintenance_cost_per_technology {\n\t\t\tIndexDomain: conv;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((t,x,h), Maintenance_cost_per_timestep(t,conv,x,h));\n\t\t}';
    end
end

variable_capital_cost_per_technology = '';
if create_variable_capital_cost_per_technology
    if multiple_hubs == 0
        variable_capital_cost_per_technology = '\n\t\tVariable Capital_cost_per_technology {\n\t\t\tIndexDomain: conv;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum(x, (Fixed_capital_costs(x,conv) * Installation(x,conv) + Linear_capital_costs(x,conv) * Capacity(x,conv)) * CRF_tech(conv));\n\t\t}';
    else
        variable_capital_cost_per_technology = '\n\t\tVariable Capital_cost_per_technology {\n\t\t\tIndexDomain: conv;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((x,h), (Fixed_capital_costs(x,conv) * Installation(x,conv,h) + Linear_capital_costs(x,conv) * Capacity(x,conv,h)) * CRF_tech(conv));\n\t\t}';
    end
end

variable_total_cost_per_technology = '';
if create_variable_total_cost_per_technology
    variable_total_cost_per_technology = '\n\t\tVariable Total_cost_per_technology {\n\t\t\tIndexDomain: conv | conv <> ''Grid'';\n\t\t\tRange: free;\n\t\t\tDefinition: Capital_cost_per_technology(conv) + Operating_cost_per_technology(conv) + Maintenance_cost_per_technology(conv);\n\t\t}';
end

variable_total_cost_per_technology_without_capital_costs = '';
if create_variable_total_cost_per_technology_without_capital_costs == 1
    variable_total_cost_per_technology_without_capital_costs = '\n\t\tVariable Total_cost_per_technology {\n\t\t\tIndexDomain: conv | conv <> ''Grid'';\n\t\t\tRange: free;\n\t\t\tDefinition: Operating_cost_per_technology(conv) + Maintenance_cost_per_technology(conv);\n\t\t}';
end

variable_total_cost_grid = '';
if create_variable_total_cost_grid
    variable_total_cost_grid = '\n\t\tVariable Total_cost_grid {\n\t\t\tRange: free;\n\t\t\tDefinition: sum(conv | conv = ''Grid'', Capital_cost_per_technology(conv) + Operating_cost_grid + Maintenance_cost_per_technology(conv));\n\t\t}';
end

variable_total_cost_grid_without_capital_costs = '';
if create_variable_total_cost_grid_without_capital_costs
    variable_total_cost_grid_without_capital_costs = '\n\t\tVariable Total_cost_grid {\n\t\t\tRange: free;\n\t\t\tDefinition: sum(conv | conv = ''Grid'', Operating_cost_grid + Maintenance_cost_per_technology(conv));\n\t\t}';
end

variables_section = strcat(variables_section,variable_input_streams,variable_exported_energy,variable_technology_installation,variable_technology_operation,...
    variable_technology_capacity,variable_grid_capacity,variable_electricity_output,variable_heat_output,variable_cool_output,variable_dhw_output,variable_anergy_output,...
    variable_operating_cost_per_technology,variable_maintenance_cost_per_technology,variable_capital_cost_per_technology,...
    variable_total_cost_per_technology,variable_total_cost_per_technology_without_capital_costs,variable_total_cost_grid,variable_total_cost_grid_without_capital_costs);
