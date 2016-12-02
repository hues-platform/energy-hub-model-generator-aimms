%% GENERATE PROCEDURES FOR AMS FILE

%GENERATE MAIN EXECUTION PROCEDURE
main_execution_procedure = '';
header_procedure = '\n\tProcedure Main_Execution {';
header_body = '\n\t\tBody: {';

GenerateMainExecutionProcedure;

footer_body = '\n\t\t}';
footer_procedure = '\n\t}';

main_execution_procedure = strcat(header_procedure,header_body,main_execution_procedure,footer_body,footer_procedure);

%GENERATE DATA INPUTS PROCEDURE
data_inputs_procedure = '';
header_procedure = '\n\tProcedure Load_Input_Data {';
header_body = '\n\t\tBody: {';

GenerateDataInputsProcedure;

footer_body = '\n\t\t}';
footer_procedure = '\n\t}';

data_inputs_procedure = strcat(header_procedure,header_body,data_inputs_procedure,footer_body,footer_procedure);

%GENERATE DATA OUTPUTS PROCEDURE
data_outputs_procedure = '';
header_procedure = '\n\tProcedure Write_Output_Data {';
header_body = '\n\t\tBody: {';

GenerateDataOutputsProcedure;

footer_body = '\n\t\t}';
footer_procedure = '\n\t}';

data_outputs_procedure = strcat(header_procedure,header_body,data_outputs_procedure,footer_body,footer_procedure);

%GENERATE MAIN TERMINATION PROCEDURE
main_termination_procedure = '';
header_procedure = '\n\tProcedure Main_Termination {';
header_body = '\n\t\tBody: {';

GenerateMainTerminationProcedure;

footer_body = '\n\t\t}';
footer_procedure = '\n\t}';

main_termination_procedure = strcat(header_procedure,header_body,main_termination_procedure,footer_body,footer_procedure);
