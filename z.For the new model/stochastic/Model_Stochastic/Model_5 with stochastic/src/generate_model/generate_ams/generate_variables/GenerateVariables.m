%% GENERATE VARIABLES FOR AMS FILE

% GENERATE VARIABLES
variables_section = '';
section_header = '\n\tDeclarationSection Variables {';

GenerateConversionTechnologyVariables
GenerateStorageTechnologyVariables
GenerateNetworkVariables
GenerateOtherVariables

section_footer = '\n\t}';

variables_section = strcat(section_header,variables_section,section_footer);

% GENERATE OBJECTIVE FUNCTIONS
objective_functions_section = '';
objective_functions_header = '\n\tDeclarationSection Objective_functions {';

GenerateObjectiveFunctions

objective_functions_footer = '\n\t}';

objective_functions_section = strcat(objective_functions_header,objective_functions_section,objective_functions_footer);
