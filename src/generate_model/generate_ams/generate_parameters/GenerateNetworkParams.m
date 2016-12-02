
%% GENERATE PARAMS FOR NETWORK LINKS

%link installation parameter
param_link_installation = '';
if create_param_link_installation == 1
    definition_string = '';
    for t=1:length(installed_technologies.network_techs_names)
        node1 = links_node1(find(links == installed_technologies.network_techs_links(t)));
        node2 = links_node2(find(links == installed_technologies.network_techs_links(t)));
        energy_type = installed_technologies.network_techs_types(t);
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(',char(energy_type),',',num2str(node1),',',num2str(node2),') : 1');
    end
    param_link_installation = strcat('\n\t\tParameter Link_installation  {\n\t\t\tIndexDomain: (x,h,hh);\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%link lengths parameter
param_link_lengths = '';
if create_param_link_lengths == 1
    definition_string = '';
    for t=1:length(installed_technologies.network_techs_names)
        node1 = links_node1(find(links == installed_technologies.network_techs_links(t)));
        node2 = links_node2(find(links == installed_technologies.network_techs_links(t)));
        energy_type = installed_technologies.network_techs_types(t);
        distance = links_length(find(links == installed_technologies.network_techs_links(t)));
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(',char(energy_type),',',num2str(node1),',',num2str(node2),'):',num2str(distance));
    end
    param_link_lengths = strcat('\n\t\tParameter Link_length  {\n\t\t\tIndexDomain: (x,h,hh);\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%link losses parameter (per m)
param_link_losses = '';
if create_param_link_losses == 1
    definition_string = '';
    for t=1:length(installed_technologies.network_techs_names)
        node1 = links_node1(find(links == installed_technologies.network_techs_links(t)));
        node2 = links_node2(find(links == installed_technologies.network_techs_links(t)));
        energy_type = installed_technologies.network_techs_types(t);
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(',char(energy_type),',',num2str(node1),',',num2str(node2),'):',num2str(installed_technologies.network_techs_losses(t)));
    end
    param_link_losses = strcat('\n\t\tParameter Link_losses_per_meter  {\n\t\t\tIndexDomain: (x,h,hh);\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

%link capacity parameter
param_link_capacity = '';
if create_param_link_capacity == 1
    definition_string = '';
    for t=1:length(installed_technologies.network_techs_names)
        node1 = links_node1(find(links == installed_technologies.network_techs_links(t)));
        node2 = links_node2(find(links == installed_technologies.network_techs_links(t)));
        energy_type = installed_technologies.network_techs_types(t);
        if t>1
            definition_string = strcat(definition_string,', ');
        end
        definition_string = strcat(definition_string,'(',char(energy_type),',',num2str(node1),',',num2str(node2),'):',num2str(installed_technologies.network_techs_capacities(t)));
    end
    param_link_capacity = strcat('\n\t\tParameter Link_capacity  {\n\t\t\tIndexDomain: (x,h,hh);\n\t\t\tDefinition: data { ',definition_string,' };\n\t\t}');
end

params_section = strcat(params_section,param_link_installation,param_link_lengths,param_link_losses,param_link_capacity);