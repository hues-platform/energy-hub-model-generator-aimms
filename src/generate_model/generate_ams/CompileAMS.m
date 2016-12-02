%% GENERATE THE AMS FILE COMPONENTS

GenerateSets
GenerateParams
GenerateVariables
GenerateConstraints
GenerateMathematicalProgram
GenerateProcedures

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
template_AMS = 'generate_model\generate_ams\energy_hub_template.ams';
new_AMS_path = '';
new_AMS_name = 'aimms_model\energy_hub\MainProject\energy_hub.ams';
new_AMS = [new_AMS_path new_AMS_name];
copyfile(template_AMS,new_AMS);

%write to the file
fileID = fopen(new_AMS,'a');
fprintf(fileID,ams_string);
fclose(fileID);
