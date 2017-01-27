%% ENERGY CONVERSION TECHNOLOGY VARIABLES

%variable denoting input energy streams of energy conversion devices
%refers to the quantity of the primary input stream being used
variable_input_streams = '';
if create_variable_input_streams == 1
    if multiple_hubs == 0
        variable_input_streams = '\n\t\tVariable Input_energy {\n\t\t\tIndexDomain: (t,conv);\n\t\t\tRange: nonnegative;\n\t\t}';
    else
        variable_input_streams = '\n\t\tVariable Input_energy {\n\t\t\tIndexDomain: (t,conv,h);\n\t\t\tRange: nonnegative;\n\t\t}';
    end
        
end

%variable denoting exported energy nonrenewable
variable_exported_energy_nonrenewable = '';
if create_variable_exported_energy_nonrenewable == 1
    if multiple_hubs == 0
        variable_exported_energy_nonrenewable = '\n\t\tVariable Exported_energy_nonrenewable {\n\t\t\tIndexDomain: (t,x) | x = "Elec";\n\t\t\tRange: nonnegative;\n\t\t}';
    else
        variable_exported_energy_nonrenewable = '\n\t\tVariable Exported_energy_nonrenewable {\n\t\t\tIndexDomain: (t,x,h) | x = "Elec";\n\t\t\tRange: nonnegative;\n\t\t}';
    end
end

%variable denoting exported energy renewable
variable_exported_energy_renewable = '';
if create_variable_exported_energy_renewable == 1
    if multiple_hubs == 0
        variable_exported_energy_renewable = '\n\t\tVariable Exported_energy_renewable {\n\t\t\tIndexDomain: (t,x) | x = "Elec";\n\t\t\tRange: nonnegative;\n\t\t}';
    else
        variable_exported_energy_renewable = '\n\t\tVariable Exported_energy_renewable {\n\t\t\tIndexDomain: (t,x,h) | x = "Elec";\n\t\t\tRange: nonnegative;\n\t\t}';
    end
end

%binary variable denoting the installation of a technology
variable_technology_installation = '';
if create_variable_technology_installation == 1
    if multiple_hubs == 0
        variable_technology_installation = '\n\t\tVariable Installation {\n\t\t\tIndexDomain: (conv);\n\t\t\tRange: binary;\n\t\t}';
    else
        variable_technology_installation = '\n\t\tVariable Installation {\n\t\t\tIndexDomain: (conv,h);\n\t\t\tRange: binary;\n\t\t}';
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
        variable_technology_capacity = '\n\t\tVariable Capacity {\n\t\t\tIndexDomain: conv | conv <> ''Grid'';\n\t\t\tRange: nonnegative;\n\t\t}';
    else
        variable_technology_capacity = '\n\t\tVariable Capacity {\n\t\t\tIndexDomain: (conv,h) | conv <> ''Grid'';\n\t\t\tRange: nonnegative;\n\t\t}';
    end
end

%variable denoting the capacity of the grid connection
variable_grid_capacity = '';
if create_variable_grid_capacity == 1
    variable_grid_capacity = '\n\t\tVariable Capacity_grid {\n\t\t\tRange: nonnegative;\n\t\t}';
end

%variable denoting the output energy of a technology
variable_energy_output = '';
if create_variable_energy_output == 1
    if multiple_hubs == 0
        variable_energy_output = '\n\t\tVariable Output_energy  {\n\t\t\tIndexDomain: (t,x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv) * Cmatrix(x,conv);\n\t\t}';
    else
        variable_energy_output = '\n\t\tVariable Output_energy  {\n\t\t\tIndexDomain: (t,x,conv,h) | Cmatrix(x,conv) > 0;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Input_energy(t,conv,h) * Cmatrix(x,conv);\n\t\t}';
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
        variable_capital_cost_per_technology = '\n\t\tVariable Capital_cost_per_technology {\n\t\t\tIndexDomain: conv;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum(x, (Fixed_capital_costs(x,conv) * Installation(x,conv) + Linear_capital_costs(x,conv) * Capacity(conv)) * CRF_tech(conv));\n\t\t}';
    else
        variable_capital_cost_per_technology = '\n\t\tVariable Capital_cost_per_technology {\n\t\t\tIndexDomain: conv;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum((x,h), (Fixed_capital_costs(x,conv) * Installation(x,conv,h) + Linear_capital_costs(x,conv) * Capacity(conv,h)) * CRF_tech(conv));\n\t\t}';
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

variables_section = strcat(variables_section,variable_input_streams,variable_exported_energy_nonrenewable,variable_exported_energy_renewable,variable_technology_installation,variable_technology_operation,...
    variable_technology_capacity,variable_grid_capacity,variable_energy_output,variable_operating_cost_per_technology,variable_maintenance_cost_per_technology,variable_capital_cost_per_technology,...
    variable_total_cost_per_technology,variable_total_cost_per_technology_without_capital_costs,variable_total_cost_grid,variable_total_cost_grid_without_capital_costs);
