%% NETWORK VARIABLES

% variable representing the energy flow through network links
variable_link_flows = '';
if create_variable_link_flows == 1
    variable_link_flows = '\n\t\tVariable Link_flow {\n\t\t\tIndexDomain: (t,x,h,hh);\n\t\t\tRange: nonnegative;\n\t\t}';
end

% variable representing the operation of a link
variable_link_operation = '';
if create_variable_link_operation == 1
    variable_link_operation = '\n\t\tVariable Link_operation {\n\t\t\tIndexDomain: (t,x,h,hh);\n\t\t\tRange: binary;\n\t\t}';
end

% variable representing the total energy losses from network links, in kWh
variable_link_losses = '';
if create_variable_link_losses == 1
    variable_link_losses = '\n\t\tVariable Link_losses {\n\t\t\tIndexDomain: (t,x,h,hh);\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: Link_flow(t,x,h,hh) * Link_losses_per_meter(x,h,hh) * Link_length(x,h,hh);\n\t\t}';
end

variables_section = strcat(variables_section,variable_link_flows,variable_link_operation,variable_link_losses);