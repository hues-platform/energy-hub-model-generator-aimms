%% GENERATE COST PARAMS FOR ENERGY CONVERSION TECHNOLOGIES

%operating costs
param_operating_costs = '';
if create_param_operating_costs == 1
    definition_string = '';
    technologies_excluding_grid = unique_technologies.conversion_techs_names(find(~strcmp(unique_technologies.conversion_techs_names,'Grid')));
    operating_costs_excluding_grid = unique_technologies.conversion_techs_operating_costs(find(~strcmp(unique_technologies.conversion_techs_names,'Grid')));
    for t=1:length(technologies_excluding_grid)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(technologies_excluding_grid(t)),':',num2str(operating_costs_excluding_grid(t)));
    end
    param_operating_costs = strcat('\n\t\tParameter Operating_costs {\n\t\t\tIndexDomain: conv | conv <> ''Grid'';\n\t\t\tDefinition: data {',definition_string,'};\n\t\t}');
end

%operating costs of grid
param_operating_costs_grid = '';
if create_param_operating_costs_grid == 1
    if length(grid_electricity_price) > 1
        param_operating_costs_grid = '\n\t\tParameter Operating_costs_grid {\n\t\t\tIndexDomain: t;\n\t\t}';
    else 
        param_operating_costs_grid = strcat('\n\t\tParameter Operating_costs_grid {\n\t\t\tDefinition: ',num2str(grid_electricity_price),';\n\t\t}');
    end
end

%OMV costs
param_OMV_costs = '';
if create_param_OMV_costs == 1
    definition_string = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(energy_conversion_technologies(t)),':',num2str(unique_technologies.conversion_techs_OM_cost_variable(t)));
    end
    param_OMV_costs = strcat('\n\t\tParameter OMV_costs {\n\t\t\tIndexDomain: conv;\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%linear capital costs
param_linear_capital_costs = '';
technology_linear_capital_costs = unique_technologies.conversion_techs_capital_cost_variable;
technology_types = unique_technologies.conversion_techs_outputs_1;
if create_param_linear_capital_costs == 1
    linear_capital_costs = '\n\t\tParameter Linear_capital_costs {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: {\n\t\t\tdata { ';
    definition_string = '';
    for t=1:length(unique_technologies.conversion_techs_names)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(',char(technology_types(t)),',',char(unique_technologies.conversion_techs_names(t)),'):',num2str(technology_linear_capital_costs(t)));
    end
    param_linear_capital_costs = strcat(linear_capital_costs,definition_string,'}\n\t\t\t};\n\t\t}');
end

%fixed capital costs
param_fixed_capital_costs = '';
technology_fixed_capital_costs = unique_technologies.conversion_techs_capital_cost_fixed;
technology_types = unique_technologies.conversion_techs_outputs_1;
if create_param_fixed_capital_costs == 1
    fixed_capital_costs = '\n\t\tParameter Fixed_capital_costs {\n\t\t\tIndexDomain: (x,conv) | Cmatrix(x,conv) > 0;\n\t\t\tDefinition: {\n\t\t\tdata { ';
    definition_string = '';
    for t=1:length(unique_technologies.conversion_techs_names)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(',char(technology_types(t)),',',char(unique_technologies.conversion_techs_names(t)),'):',num2str(technology_fixed_capital_costs(t)));
    end
    param_fixed_capital_costs = strcat(fixed_capital_costs,definition_string,'}\n\t\t\t};\n\t\t}');
end

%electricity feed-in price renewables
param_electricity_feedin_price_renewables = '';
if create_param_electricity_feedin_price_renewables == 1
    if length(grid_electricity_feedin_price_renewables) > 1
        definition_string = strcat('Elec:',num2str(grid_electricity_feedin_price_renewables));
        param_electricity_feedin_price_renewables = strcat('\n\t\tParameter Electricity_feedin_price_renewables {\n\t\t\tIndexDomain: t;\n\t\t}');
    else
        definition_string = strcat('Elec:',num2str(grid_electricity_feedin_price_renewables));
        param_electricity_feedin_price_renewables = strcat('\n\t\tParameter Electricity_feedin_price_renewables {\n\t\t\tDefinition: ',num2str(grid_electricity_feedin_price_renewables),';\n\t\t}');
    end
end

%electricity feed-in price nonrenewables
param_electricity_feedin_price_nonrenewables = '';
if create_param_electricity_feedin_price_nonrenewables == 1
    if length(grid_electricity_feedin_price_nonrenewables) > 1
        definition_string = strcat('Elec:',num2str(grid_electricity_feedin_price_nonrenewables));
        param_electricity_feedin_price_nonrenewables = strcat('\n\t\tParameter Electricity_feedin_price_nonrenewables {\n\t\t\tIndexDomain: t;\n\t\t}');
    else
        definition_string = strcat('Elec:',num2str(grid_electricity_feedin_price_nonrenewables));
        param_electricity_feedin_price_nonrenewables = strcat('\n\t\tParameter Electricity_feedin_price_nonrenewables {\n\t\t\tDefinition: ',num2str(grid_electricity_feedin_price_nonrenewables),';\n\t\t}');
    end
end

%interest rate
param_int_rate = '';
if create_param_int_rate == 1
    param_int_rate = strcat('\n\t\tParameter Interest_rate {\n\t\t\tDefinition: ',num2str(interest_rate),';\n\t\t}');
end

%lifetimes
param_lifetimes = '';
if create_param_lifetimes == 1
    definition_string = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(energy_conversion_technologies(t)),':',num2str(unique_technologies.conversion_techs_lifetime(t)));
    end
    param_lifetimes = strcat('\n\t\tParameter Lifetime {\n\t\t\tIndexDomain: conv | conv <> "Grid";\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%capital recovery factor
%note: used to annualize investment costs
param_technology_CRF = '';
if create_param_technology_CRF == 1
    param_technology_CRF = '\n\t\tParameter CRF_tech {\n\t\t\tIndexDomain: conv | conv <> "Grid";\n\t\t\tDefinition: Interest_rate/(1-(1/((1+Interest_rate)^(Lifetime(conv)))));\n\t\t}';
end

%% GENERATE TECHNICAL PARAMS FOR AMS FILE FOR ENERGY CONVERSION TECHNOLOGIES

%C matrix
param_C_matrix = '';
if create_param_C_matrix == 1
    C_matrix = '\n\t\tParameter Cmatrix {\n\t\t\tIndexDomain: (x,conv);\n\t\t\tDefinition: { data { ';
    definition_string = '';
    
    outputs_of_conversion_technologies_with_single_output = unique_technologies.conversion_techs_outputs_1(find(isnan(unique_technologies.conversion_techs_outputs_2)));
    efficiency_of_conversion_technologies_with_single_output = unique_technologies.conversion_techs_efficiency(find(isnan(unique_technologies.conversion_techs_outputs_2)));
    output_1_of_conversion_technologies_with_multiple_outputs = unique_technologies.conversion_techs_outputs_1(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    output_2_of_conversion_technologies_with_multiple_outputs = unique_technologies.conversion_techs_outputs_2(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    efficiency_1_of_conversion_technologies_with_multiple_outputs = unique_technologies.conversion_techs_efficiency(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    output_ratio_of_conversion_techs_with_multiple_outputs = unique_technologies.conversion_techs_output_ratio(find(~isnan(unique_technologies.conversion_techs_outputs_2)));
    efficiency_2_of_conversion_technologies_with_multiple_outputs = efficiency_1_of_conversion_technologies_with_multiple_outputs .* output_ratio_of_conversion_techs_with_multiple_outputs;
    
    %add the single-output technologies to the C-matrix
    for t=1:length(energy_conversion_technologies_with_single_output)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(',char(outputs_of_conversion_technologies_with_single_output(t)),',',char(energy_conversion_technologies_with_single_output(t)),'):',num2str(efficiency_of_conversion_technologies_with_single_output(t)));
    end
    
    %add the multi-output technologies to the C-matrix
    for t=1:length(energy_conversion_technologies_with_multiple_outputs)
        definition_string = strcat(definition_string,',(',char(output_1_of_conversion_technologies_with_multiple_outputs(t)),',',char(energy_conversion_technologies_with_multiple_outputs(t)),'):',num2str(efficiency_1_of_conversion_technologies_with_multiple_outputs(t)));
        definition_string = strcat(definition_string,',(',char(output_2_of_conversion_technologies_with_multiple_outputs(t)),',',char(energy_conversion_technologies_with_multiple_outputs(t)),'):',num2str(efficiency_2_of_conversion_technologies_with_multiple_outputs(t)));
    end
    
    %add the inputs to the C-matrix where necessary (when the inputs correspond to the outputs of other technologies)
    for o=1:length(energy_outputs)
 
        %add for primary inputs of technologies
        technologies_with_this_as_main_input = unique_technologies.conversion_techs_names(find(strcmp(unique_technologies.conversion_techs_inputs_1,energy_outputs(o))));
        for t=1:length(technologies_with_this_as_main_input)
            definition_string = strcat(definition_string,',(',char(energy_outputs(o)),',',char(technologies_with_this_as_main_input(t)),'):',num2str(-1.0));
        end
        
        %add for secondary inputs of technologies (in cases of multiple inputs)
        technologies_with_this_as_secondary_input = unique_technologies.conversion_techs_names(find(strcmp(unique_technologies.conversion_techs_inputs_2,energy_outputs(o))));
        for t=1:length(technologies_with_this_as_secondary_input)
            input_ratio = unique_technologies.conversion_techs_input_ratio(find(strcmp(technologies_with_multiple_inputs,technologies_with_this_as_secondary_input(t)))); 
            definition_string = strcat(definition_string,',(',char(energy_outputs(o)),',',char(technologies_with_this_as_secondary_input(t)),'):',num2str(-1.0 * input_ratio));
        end
    end   
    param_C_matrix = strcat(C_matrix,definition_string,'}\n\t\t\t}\n\t\t}');
    
end

%param capacity
%only used if we're not doing technology selection and sizing; otherwise this is set by the capacity variable
param_capacity = '';
if create_param_capacity == 1
    definition_string = '';
    if multiple_hubs == 0
        index_domain_string = 'conv';
        for t=1:length(energy_conversion_technologies)
            if t>1
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,char(energy_conversion_technologies(t)),':',num2str(installed_technologies.conversion_techs_capacity(t)));
        end
    else
        index_domain_string = '(conv,h)';
        for t=1:length(energy_conversion_technologies)
            if t>1
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(',char(energy_conversion_technologies(t)),num2str(installed_technologies.conversion_techs_node(t)),'):',num2str(installed_technologies.conversion_techs_capacity(t)));
        end
    end
    
    param_capacity = strcat('\n\t\tParameter Capacity {\n\t\t\tIndexDomain: ',index_domain_string,';\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');
end

% %param capacity
% %only used if we're not doing technology selection and sizing; otherwise this is set by the capacity variable
% param_capacity = '';
% if create_param_capacity == 1
%     
%     installed_conversion_techs_with_single_output = installed_technologies.conversion_techs_names(find(isnan(installed_technologies.conversion_techs_outputs_2)));
%     installed_conversion_techs_with_multiple_outputs = installed_technologies.conversion_techs_names(find(~isnan(installed_technologies.conversion_techs_outputs_2)));
%     
%     outputs_of_installed_techs_with_single_output = installed_technologies.conversion_techs_outputs_1(find(isnan(installed_technologies.conversion_techs_outputs_2)));
%     capacity_of_installed_techs_with_single_output = installed_technologies.conversion_techs_capacity(find(isnan(installed_technologies.conversion_techs_outputs_2)));
%     node_of_installed_techs_with_single_output = installed_technologies.conversion_techs_node(find(isnan(installed_technologies.conversion_techs_outputs_2)));
%     
%     output_1_of_installed_techs_with_multiple_outputs = installed_technologies.conversion_techs_outputs_1(find(~isnan(installed_technologies.conversion_techs_outputs_2)));
%     output_2_of_installed_techs_with_multiple_outputs = installed_technologies.conversion_techs_outputs_2(find(~isnan(installed_technologies.conversion_techs_outputs_2)));
%     capacity_1_of_installed_techs_with_multiple_outputs = installed_technologies.conversion_techs_capacity(find(~isnan(installed_technologies.conversion_techs_outputs_2)));
%     output_ratio_of_installed_techs_with_multiple_outputs = installed_technologies.conversion_techs_output_ratio(find(~isnan(installed_technologies.conversion_techs_outputs_2)));
%     capacity_2_of_installed_techs_with_multiple_outputs = capacity_1_of_installed_techs_with_multiple_outputs .* output_ratio_of_installed_techs_with_multiple_outputs;
%     node_of_installed_techs_with_multiple_outputs = installed_technologies.conversion_techs_node(find(~isnan(installed_technologies.conversion_techs_outputs_2)));
%     
%     definition_string = '';
%     if multiple_hubs == 0
%         index_domain_string = '(x,conv)';
%         for t=1:length(energy_conversion_technologies_with_single_output)
%             if t>1
%                 definition_string = strcat(definition_string,', ');
%             end
%             definition_string = strcat(definition_string,'(',char(outputs_of_installed_techs_with_single_output(t)),',',char(energy_conversion_technologies_with_single_output(t)),'):',num2str(capacity_of_installed_techs_with_single_output(t)));
%         end
%         for t=1:length(energy_conversion_technologies_with_multiple_outputs)
%             definition_string = strcat(definition_string,',(',char(output_1_of_conversion_technologies_with_multiple_outputs(t)),',',char(energy_conversion_technologies_with_multiple_outputs(t)),'):',num2str(efficiency_1_of_conversion_technologies_with_multiple_outputs(t)));
%             definition_string = strcat(definition_string,',(',char(output_2_of_conversion_technologies_with_multiple_outputs(t)),',',char(energy_conversion_technologies_with_multiple_outputs(t)),'):',num2str(efficiency_2_of_conversion_technologies_with_multiple_outputs(t)));
%         end
%     else
%         index_domain_string = '(x,conv,h)';
%         for t=1:length(energy_conversion_technologies_with_single_output)
%             if t>1
%                 definition_string = strcat(definition_string,', ');
%             end
%             definition_string = strcat(definition_string,'(',char(outputs_of_installed_techs_with_single_output(t)),',',char(energy_conversion_technologies_with_single_output(t)),',',num2str(node_of_installed_techs_with_single_output(t)),'):',num2str(capacity_of_installed_techs_with_single_output(t)));
%         end
%         for t=1:length(energy_conversion_technologies_with_multiple_outputs)
%             definition_string = strcat(definition_string,',(',char(output_1_of_conversion_technologies_with_multiple_outputs(t)),',',char(energy_conversion_technologies_with_multiple_outputs(t)),',',num2str(node_of_installed_techs_with_multiple_outputs(t)),'):',num2str(efficiency_1_of_conversion_technologies_with_multiple_outputs(t)));
%             definition_string = strcat(definition_string,',(',char(output_2_of_conversion_technologies_with_multiple_outputs(t)),',',char(energy_conversion_technologies_with_multiple_outputs(t)),',',num2str(node_of_installed_techs_with_multiple_outputs(t)),'):',num2str(efficiency_2_of_conversion_technologies_with_multiple_outputs(t)));
%         end
%     end
%     
%     param_capacity = strcat('\n\t\tParameter Capacity {\n\t\t\tIndexDomain: ',index_domain_string,';\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');
% 
% end

%param capacity grid
%only used if we're not doing grid sizing; otherwise this is set by the capacity variable
param_capacity_grid = '';
if create_param_capacity_grid == 1
    definition_string = num2str(grid_connection_capacity);
    param_capacity_grid = strcat('\n\t\tParameter Capacity_grid {\n\t\t\tDefinition: ',definition_string,';\n\t\t}');
end

%minimum allowable capacities
param_minimum_capacities = '';
technology_min_capacities_non_solar = unique_technologies.conversion_techs_min_capacity(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))));
non_solar_energy_conversion_technologies = unique_technologies.conversion_techs_names(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))));
if create_param_minimum_capacities == 1
    definition_string = '';
    for t=1:length(non_solar_energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(non_solar_energy_conversion_technologies(t)),':',num2str(technology_min_capacities_non_solar(t)));
    end
    index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(non_solar_energy_conversion_technologies(t)),'''');
        if t < length(non_solar_energy_conversion_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end        
    minimum_capacities = strcat('\n\t\tParameter Min_allowable_capacity {\n\t\t\tIndexDomain: conv | conv = ',index_domain_string,';');
    param_minimum_capacities = strcat(minimum_capacities,'\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%maximum allowable capacities
param_maximum_capacities = '';
technology_max_capacities_non_solar = unique_technologies.conversion_techs_max_capacity(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))));
non_solar_energy_conversion_technologies = unique_technologies.conversion_techs_names(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))));
if create_param_maximum_capacities == 1
    definition_string = '';
    for t=1:length(non_solar_energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(non_solar_energy_conversion_technologies(t)),':',num2str(technology_max_capacities_non_solar(t)));
    end
    index_domain_string = '';
    for t=1:length(non_solar_energy_conversion_technologies)
        index_domain_string = strcat(index_domain_string,'''',char(non_solar_energy_conversion_technologies(t)),'''');
        if t < length(non_solar_energy_conversion_technologies)
             index_domain_string = strcat(index_domain_string,' OR conv = '); 
        end
    end        
    maximum_capacities = strcat('\n\t\tParameter Max_allowable_capacity {\n\t\t\tIndexDomain: conv | conv = ',index_domain_string,';');
    param_maximum_capacities = strcat(maximum_capacities,'\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%minimum allowable capacity grid
param_min_capacity_grid = '';
if create_param_min_capacity_grid == 1
   definition_string = num2str(unique_technologies.conversion_techs_min_capacity(find(strcmp(unique_technologies.conversion_techs_names,'Grid'))));
   param_min_capacity_grid = strcat('\n\t\tParameter Min_allowable_capacity_grid {\n\t\t\tDefinition:',definition_string,';\n\t\t}');
end

%maximum allowable capacity grid
param_max_capacity_grid = '';
if create_param_max_capacity_grid == 1
   definition_string = num2str(unique_technologies.conversion_techs_max_capacity(find(strcmp(unique_technologies.conversion_techs_names,'Grid'))));
   param_max_capacity_grid = strcat('\n\t\tParameter Max_allowable_capacity_grid {\n\t\t\tDefinition:',definition_string,';\n\t\t}');
end

%minimum part load
param_minimum_part_load = '';
if create_param_minimum_part_load == 1   
    conversion_techs_mininimum_part_load = unique_technologies.conversion_techs_min_part_load;
    definition_string = '';
    for t=1:length(energy_conversion_technologies)
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,char(energy_conversion_technologies(t)),':',num2str(unique_technologies.conversion_techs_min_part_load(t)));
    end
    param_minimum_part_load = strcat('\n\t\tParameter Minimum_part_load {\n\t\t\tIndexDomain: conv ;\n\t\t\tDefinition: { data { ',definition_string,'}\n\t\t\t;}\n\t\t}');
end

%installation (for pre-installed technologies)
param_installed_conversion_technologies = '';
if create_param_installed_conversion_technologies == 1
    number_of_installed_conversion_techs = length(installed_technologies.conversion_techs_names);
    definition_string = '';
    if multiple_hubs == 0
        index_domain_string = 'conv';
        for t=1:number_of_installed_conversion_techs
            if t>1
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,char(installed_technologies.conversion_techs_names(t)),' : 1');
        end      
    else
        index_domain_string = 'conv,h';
        for t=1:number_of_installed_conversion_techs
            if t>1
                definition_string = strcat(definition_string,', ');
            end
            definition_string = strcat(definition_string,'(',char(installed_technologies.conversion_techs_names(t)),',',num2str(installed_technologies.conversion_techs_node(t)),') : 1');
        end
    end
    param_installed_conversion_technologies = strcat('\n\t\tParameter Installed_conversion_techs {\n\t\t\tIndexDomain:(',index_domain_string,');\n\t\t\tDefinition: { data {',definition_string,'};\n\t\t\t}\n\t\t}');
end


params_section = strcat(params_section,param_operating_costs,param_operating_costs_grid,param_OMV_costs,param_linear_capital_costs,param_fixed_capital_costs,...
    param_electricity_feedin_price_renewables,param_electricity_feedin_price_nonrenewables,param_int_rate,param_lifetimes,param_technology_CRF,param_C_matrix,param_capacity,param_capacity_grid,param_minimum_capacities,param_maximum_capacities,...
    param_min_capacity_grid,param_max_capacity_grid,param_minimum_part_load,param_installed_conversion_technologies);
