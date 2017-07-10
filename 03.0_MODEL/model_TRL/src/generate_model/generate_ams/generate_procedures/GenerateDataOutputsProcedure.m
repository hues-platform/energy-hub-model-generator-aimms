%% CLEAN UP THE OUTPUT FILES AND CREATE RESULTS DIRECTORY

if exist(strcat('aimms_model\energy_hub\results\',experiment_name),'dir')==7
    if exist(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_demands.xlsx'),'file')==2
      delete(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_demands.xlsx'));
    end
    if exist(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_conversion.xlsx'),'file')==2
      delete(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_conversion.xlsx'));
    end
    if exist(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_storage.xlsx'),'file')==2
      delete(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_storage.xlsx'));
    end
    if exist(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_network.xlsx'),'file')==2
      delete(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_network.xlsx'));
    end
    if exist(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_capacities.xlsx'),'file')==2
      delete(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_capacities.xlsx'));
    end
    if exist(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_costs.xlsx'),'file')==2
      delete(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_costs.xlsx'));
    end
    if exist(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_emissions.xlsx'),'file')==2
      delete(strcat('aimms_model\energy_hub\results\',experiment_name,'\results_emissions.xlsx'));
    end
else
    mkdir(strcat('aimms_model\energy_hub\results\',experiment_name));
end

%% WRITE OUTPUT DATA

%calculate some variables for printing the results
if isempty(unique_technologies.conversion_techs_names) == 0
    number_of_conversion_techs = length(unique_technologies.conversion_techs_names);
    number_of_conversion_techs_excluding_grid = length(unique_technologies.conversion_techs_names(find(~strcmp(unique_technologies.conversion_techs_names,'Grid'))));
end
if isempty(unique_technologies.storage_techs_names) == 0
    number_of_storage_techs = length(unique_technologies.storage_techs_names);
end
if multiple_hubs == 1
    number_of_links = length(links);
end
number_of_timesteps = length(timesteps);

%print the demand data
demand_data_for_printing = '';
if print_demand_data == 1
    demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results/',experiment_name,'/results_demands.xlsx","Energy_demands");');
    if multiple_hubs == 0
        demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_demands.xlsx",Energy_demands,"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Energy_demands",0,1,1);');
    else
        for h = 1:number_of_hubs
            demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_demands.xlsx","Energy_demands',num2str(h),'");');
            demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_demands.xlsx",Energy_demands(t,x,''',num2str(h),'''),"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Energy_demands',num2str(h),'",0,1,1);');
        end
    end
    demand_data_for_printing = strcat(demand_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results/',experiment_name,'/results_demands.xlsx",1);');
end

%print the conversion technology data
conversion_data_for_printing = '';
if print_conversion_data == 1 && isempty(unique_technologies.conversion_techs_names) == 0
    conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results/',experiment_name,'/results_conversion.xlsx","Input_energy");');
    if multiple_hubs == 0
        conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_conversion.xlsx",Input_energy,"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Input_energy",0,1,1);');
        conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_conversion.xlsx","Exported_energy_renewable");');
        conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_conversion.xlsx",Exported_energy_renewable,"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Exported_energy_renewable",0,1,1);');
        conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_conversion.xlsx","Exported_energy_nonrenewable");');
        conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_conversion.xlsx",Exported_energy_nonrenewable,"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Exported_energy_nonrenewable",0,1,1);');
        for o = energy_outputs
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_conversion.xlsx","Output_energy_',char(o),'");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_conversion.xlsx",Output_energy(t,''',char(o),''',conv),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Output_energy_',char(o),'",0,1,1);');
        end
    else
        for h = 1:number_of_hubs
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_conversion.xlsx","Input_energy',num2str(h),'");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_conversion.xlsx",Input_energy(t,conv,''',num2str(h),'''),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Input_energy',num2str(h),'",0,1,1);');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_conversion.xlsx","Exported_energy_renewable',num2str(h),'");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_conversion.xlsx",Exported_energy_renewable(t,x,''',num2str(h),'''),"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Exported_energy_renewable',num2str(h),'",0,1,1);');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_conversion.xlsx","Exported_energy_nonrenewable',num2str(h),'");');
            conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_conversion.xlsx",Exported_energy_nonrenewable(t,x,''',num2str(h),'''),"B2:',char('A' + length(energy_outputs) - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + length(energy_outputs) - 1 + 1),'1","Exported_energy_nonrenewable',num2str(h),'",0,1,1);');
            for o = energy_outputs
                conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_conversion.xlsx","Output_energy_',char(o),num2str(h),'");');
                conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_conversion.xlsx",Output_energy(t,''',char(o),''',conv,''',num2str(h),'''),"B2:',char('A' + number_of_conversion_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_conversion_techs - 1 + 1),'1","Output_energy_',char(o),num2str(h),'",0,1,1);');
            end
        end
    end
    conversion_data_for_printing = strcat(conversion_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results/',experiment_name,'/results_conversion.xlsx",1);');
end

%print the storage technology data
storage_data_for_printing = '';
if print_storage_data == 1 && isempty(unique_technologies.storage_techs_names) == 0
	storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results/',experiment_name,'/results_storage.xlsx","Storage_input_energy");');
    if multiple_hubs == 0
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_storage.xlsx","Storage_output_energy");');
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_storage.xlsx","Storage_SOC");');
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_input_energy,"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_input_energy",0,1,1);');
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_output_energy,"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_output_energy",0,1,1);');
        storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_SOC,"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_SOC",0,1,1);');
    else
        for h = 1:number_of_hubs
            storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_storage.xlsx","Storage_input_energy',num2str(h),'");');
            storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_storage.xlsx","Storage_output_energy',num2str(h),'");');
            storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_storage.xlsx","Storage_SOC',num2str(h),'");');
            if simplified_storage_representation == 1
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_input_energy(t,x,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_input_energy',num2str(h),'",0,1,1);');
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_output_energy(t,x,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_output_energy',num2str(h),'",0,1,1);');
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_SOC(t,x,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_SOC',num2str(h),'",0,1,1);');
            else
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_input_energy(t,stor,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_input_energy',num2str(h),'",0,1,1);');
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_output_energy(t,stor,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_output_energy',num2str(h),'",0,1,1);');
                storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_storage.xlsx",Storage_SOC(t,stor,''',num2str(h),'''),"B2:',char('A' + number_of_storage_techs - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_storage_techs - 1 + 1),'1","Storage_SOC',num2str(h),'",0,1,1);');
            end
        end
    end
    storage_data_for_printing = strcat(storage_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results/',experiment_name,'/results_storage.xlsx",1);');
end

%print the network data
network_data_for_printing = '';
if print_network_data == 1 && multiple_hubs == 1
    for t=1:length(installed_technologies.network_techs_names)
        node1 = links_node1(find(links == installed_technologies.network_techs_links(t)));
        node2 = links_node2(find(links == installed_technologies.network_techs_links(t)));
        energy_type = installed_technologies.network_techs_types(t);
        network_data_for_printing = strcat(network_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results/',experiment_name,'/results_network.xlsx","Link_operation_',char(energy_type),'_',num2str(node1),'_',num2str(node2),'");');
        network_data_for_printing = strcat(network_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_network.xlsx","Link_flow_',char(energy_type),'_',num2str(node1),'_',num2str(node2),'");');
        network_data_for_printing = strcat(network_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_network.xlsx","Link_losses_',char(energy_type),'_',num2str(node1),'_',num2str(node2),'");');
        network_data_for_printing = strcat(network_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_network.xlsx",Link_operation(t,''',char(energy_type),''',''',num2str(node1),''',''',num2str(node2),'''),"B2:',char('A' + number_of_links - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_links - 1 + 1),'1","Link_operation_',char(energy_type),'_',num2str(node1),'_',num2str(node2),'",0,1,3);');
        network_data_for_printing = strcat(network_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_network.xlsx",Link_flow(t,''',char(energy_type),''',''',num2str(node1),''',''',num2str(node2),'''),"B2:',char('A' + number_of_links - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_links - 1 + 1),'1","Link_flow_',char(energy_type),'_',num2str(node1),'_',num2str(node2),'",0,1,3);');
        network_data_for_printing = strcat(network_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_network.xlsx",Link_losses(t,''',char(energy_type),''',''',num2str(node1),''',''',num2str(node2),'''),"B2:',char('A' + number_of_links - 1 + 1),num2str(number_of_timesteps + 1),'","A2:A',num2str(number_of_timesteps + 1),'","B1:',char('A' + number_of_links - 1 + 1),'1","Link_losses_',char(energy_type),'_',num2str(node1),'_',num2str(node2),'",0,1,3);');
    end
    network_data_for_printing = strcat(network_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results/',experiment_name,'/results_network.xlsx",1);');
end

%print the installation/capacity data
installation_data_for_printing = '';
if print_installation_data == 1 && select_techs_and_do_sizing == 1
	installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results/',experiment_name,'/results_capacities.xlsx","Installation");');
    if multiple_hubs == 0
        installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_capacities.xlsx","Capacity");');
        installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_capacities.xlsx","Storage_capacity");');
        installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_capacities.xlsx","Installation_storage");');
        if conversion_techs_for_selection_and_sizing == 1
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Installation,"B1:B',num2str(number_of_conversion_techs),'","A1:A',num2str(number_of_conversion_techs),'","","Installation",0,1,3);');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Capacity,"B1:B',num2str(number_of_conversion_techs_excluding_grid),'","A1:A',num2str(number_of_conversion_techs_excluding_grid),'","","Capacity",0,1,3);');
        end
        if storage_techs_for_selection_and_sizing == 1
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Storage_capacity,"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Storage_capacity",0,1,3);');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Installation_storage,"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Installation_storage",0,1,3);');
        end    
    else
        for h = 1:number_of_hubs
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_capacities.xlsx","Installation',num2str(h),'");');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_capacities.xlsx","Capacity',num2str(h),'");');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_capacities.xlsx","Storage_capacity',num2str(h),'");');
            installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_capacities.xlsx","Installation_storage',num2str(h),'");');
            if conversion_techs_for_selection_and_sizing == 1
                installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Installation(conv,''',num2str(h),'''),"B1:B',num2str(number_of_conversion_techs),'","A1:A',num2str(number_of_conversion_techs),'","","Installation',num2str(h),'",0,1,3);');
                installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Capacity(conv,''',num2str(h),'''),"B1:B',num2str(number_of_conversion_techs_excluding_grid),'","A1:A',num2str(number_of_conversion_techs_excluding_grid),'","","Capacity',num2str(h),'",0,1,3);');
            end
            if storage_techs_for_selection_and_sizing == 1
                if simplified_storage_representation == 1
                    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Storage_capacity(x,''',num2str(h),'''),"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Storage_capacity',num2str(h),'",0,1,3);');
                    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Installation_storage(x,''',num2str(h),'''),"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Installation_storage',num2str(h),'",0,1,3);');
                else
                    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Storage_capacity(stor,''',num2str(h),'''),"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Storage_capacity',num2str(h),'",0,1,3);');
                    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_capacities.xlsx",Installation_storage(stor,''',num2str(h),'''),"B1:B',num2str(number_of_storage_techs),'","A1:A',num2str(number_of_storage_techs),'","","Installation_storage',num2str(h),'",0,1,3);');
                end
            end  
        end
    end
    installation_data_for_printing = strcat(installation_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results/',experiment_name,'/results_capacities.xlsx",1);');
end

%print the cost data
cost_data_for_printing = '';
if print_cost_data == 1
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results/',experiment_name,'/results_costs.xlsx","Operating_cost_per_technology");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_costs.xlsx","Maintenance_cost_per_technology");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_costs.xlsx","Capital_cost_per_technology");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_costs.xlsx","Total_cost_per_technology");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_costs.xlsx","Operating_cost_grid");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_costs.xlsx","Total_cost_grid");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_costs.xlsx","Capital_cost_per_storage");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_costs.xlsx","Total_cost_per_storage");');
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_costs.xlsx","Income_via_exports");');
	if isempty(unique_technologies.conversion_techs_names) == 0
    	if conversion_techs_for_selection_and_sizing == 1
            cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_costs.xlsx",Capital_cost_per_technology,"B1:B',num2str(number_of_conversion_techs + 1),'","A1:A',num2str(number_of_conversion_techs + 1),'","","Capital_cost_per_technology",0,1,3);');
        end
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_costs.xlsx",Maintenance_cost_per_technology,"B1:B',num2str(number_of_conversion_techs + 1),'","A1:A',num2str(number_of_conversion_techs + 1),'","","Maintenance_cost_per_technology",0,1,3);');
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_costs.xlsx",Operating_cost_per_technology,"B1:B7","A1:A7","","Operating_cost_per_technology",0,1,3);');
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_costs.xlsx",Total_cost_per_technology,"B1:B',num2str(number_of_conversion_techs + 1),'","A1:A',num2str(number_of_conversion_techs + 1),'","","Total_cost_per_technology",0,1,3);');
	end
	if grid_connected_system == 1
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignValue("results/',experiment_name,'/results_costs.xlsx",Operating_cost_grid,"A1:A1","Operating_cost_grid");');
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignValue("results/',experiment_name,'/results_costs.xlsx",Total_cost_grid,"A1:A1","Total_cost_grid");');
        cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignValue("results/',experiment_name,'/results_costs.xlsx",Income_via_exports,"A1:A1","Income_via_exports");');
	end
    if isempty(unique_technologies.storage_techs_names) == 0
        if storage_techs_for_selection_and_sizing == 1
            cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_costs.xlsx",Capital_cost_per_storage,"B1:B',num2str(number_of_storage_techs + 1),'","A1:A',num2str(number_of_storage_techs + 1),'","","Capital_cost_per_storage",0,1,3);');
            cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_costs.xlsx",Total_cost_per_storage,"B1:B',num2str(number_of_storage_techs + 1),'","A1:A',num2str(number_of_storage_techs + 1),'","","Total_cost_per_storage",0,1,3);');
        end
    end
	cost_data_for_printing = strcat(cost_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results/',experiment_name,'/results_costs.xlsx",1);');
end

%print the emissions data
emissions_data_for_printing = '';
if print_emissions_data == 1
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results/',experiment_name,'/results_emissions.xlsx","Total_carbon_per_technology");');
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/',experiment_name,'/results_emissions.xlsx","Total_carbon_per_timestep");');
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_emissions.xlsx",Total_carbon_per_technology,"B1:B',num2str(number_of_conversion_techs),'","A1:A',num2str(number_of_conversion_techs),'","","Total_carbon_per_technology",0,1,3);');
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/',experiment_name,'/results_emissions.xlsx",Total_carbon_per_timestep,"B1:B',num2str(number_of_timesteps),'","A1:A',num2str(number_of_timesteps),'","","Total_carbon_per_timestep",0,1,3);');
	emissions_data_for_printing = strcat(emissions_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results/',experiment_name,'/results_emissions.xlsx",1);');
end

%compile the printing string
data_outputs_procedure = strcat(data_outputs_procedure,demand_data_for_printing,conversion_data_for_printing,storage_data_for_printing,network_data_for_printing,installation_data_for_printing,cost_data_for_printing,emissions_data_for_printing);


