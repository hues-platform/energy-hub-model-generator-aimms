%% GENERATE THE AMS FILE COMPONENTS

%initialize the strings for the code sections
sets_section = '';
params_section = '';
variables_section = '';
objective_functions_section = '';
constraints_section = '';
main_execution_procedure = '';
data_inputs_procedure = '';
data_outputs_procedure = '';
main_termination_procedure = '';

%add functionalities to the base model
if balancing_market_participation == 1
    AddBalancingMarketElements
end

%compile the base model
GenerateSets
GenerateParams
GenerateVariables
GenerateConstraints
GenerateMathematicalProgram
GenerateProcedures

%add headers and footers
header_sets = '\n\tDeclarationSection Sets {';
header_params = '\n\tDeclarationSection Parameters {';
header_variables = '\n\tDeclarationSection Variables {';
header_objective_functions = '\n\tDeclarationSection Objective_functions {';
header_constraints = '\n\tDeclarationSection Constraints {';
header_mathematical_program = '\n\tDeclarationSection Mathematical_programs {';
header_main_execution = '\n\tProcedure Main_Execution {';
header_data_inputs = '\n\tProcedure Load_Input_Data {';
header_data_outputs = '\n\tProcedure Write_Output_Data {';
header_main_termination = '\n\tProcedure Main_Termination {';
footer = '\n\t}';
header_body = '\n\t\tBody: {';
footer_body = '\n\t\t}';

sets_section = strcat(header_sets,sets_section,footer);
params_section = strcat(header_params,params_section,footer);
variables_section = strcat(header_variables,variables_section,footer);
objective_functions_section = strcat(header_objective_functions,objective_functions_section,footer);
constraints_section = strcat(header_constraints,constraints_section,footer);
mathematical_program_section = strcat(header_mathematical_program,mathematical_program_section,footer);
main_execution_procedure = strcat(header_main_execution,header_body,main_execution_procedure,footer_body,footer);
data_inputs_procedure = strcat(header_data_inputs,header_body,data_inputs_procedure,footer_body,footer);
data_outputs_procedure = strcat(header_data_outputs,header_body,data_outputs_procedure,footer_body,footer);
main_termination_procedure = strcat(header_main_termination,header_body,main_termination_procedure,footer_body,footer);

%% COMPILE THE COMPLETE STRING FOR AMS FILE

%define some headers and footers for the main sections of the model
header_model = 'Model Energy_Hub_Model {';
footer_model = '\n}';

%compile the complete string
ams_string = strcat(header_model,...
    sets_section,...
    params_section,...
    variables_section,...
    objective_functions_section,...
    constraints_section,...
    mathematical_program_section,...
    main_execution_procedure,...
    data_inputs_procedure,...
    data_outputs_procedure,...
    main_termination_procedure,...
    footer_model);


%% GENERATE THE AMS FILE

%initialize new AMS file based on the template
template_AMS = 'src\generate_model\generate_ams\energy_hub_template.ams';
new_AMS_path = '';
new_AMS_name = 'aimms_model\energy_hub\MainProject\energy_hub.ams';
new_AMS = [new_AMS_path new_AMS_name];
copyfile(template_AMS,new_AMS);

%write to the file
fileID = fopen(new_AMS,'a');
fprintf(fileID,ams_string);
fclose(fileID);
