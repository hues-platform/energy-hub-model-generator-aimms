%% GENERATE CONSTRAINTS FOR NETWORK LINKS

% link installation constraint
constraint_link_installation = '';
if apply_constraint_link_installation == 1
    constraint_link_installation = '\n\t\tConstraint Link_installation_constraint {\n\t\t\tIndexDomain: (x,h,hh);\n\t\t\tDefinition: Link_capacity(x,h,hh) <= Big_M * Link_installation(x,h,hh);\n\t\t}';
end

% link operation constraint
constraint_link_operation = '';
if apply_constraint_link_operation == 1
    constraint_link_operation = '\n\t\tConstraint Link_operation_constraint {\n\t\t\tIndexDomain: (t,x,h,hh);\n\t\t\tDefinition: Link_flow(t,x,h,hh) <= Big_M * Link_operation(t,x,h,hh);\n\t\t}';
end

% link capacity constraint
constraint_link_capacity = '';
if apply_constraint_link_capacity == 1
    constraint_link_capacity = '\n\t\tConstraint Link_capacity_constraint {\n\t\t\tIndexDomain: (t,x,h,hh);\n\t\t\tDefinition: Link_flow(t,x,h,hh) <= Link_capacity(x,h,hh);\n\t\t}';
end

% link flow direction constraint
constraint_link_flow_direction = '';
if apply_constraint_link_flow_direction == 1
    constraint_link_flow_direction = '\n\t\tConstraint Link_flow_direction_constraint {\n\t\t\tIndexDomain: (t,x,h,hh) | val(h) > val(hh);\n\t\t\tDefinition: Link_operation(t,x,h,hh) + Link_operation(t,x,hh,h) <= 1;\n\t\t}';
end

constraints_section = strcat(constraints_section,constraint_link_installation,constraint_link_operation,constraint_link_capacity,constraint_link_flow_direction);