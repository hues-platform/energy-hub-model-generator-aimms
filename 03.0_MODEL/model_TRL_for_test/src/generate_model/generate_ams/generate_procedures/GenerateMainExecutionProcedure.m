%% GENERATE MAIN EXECUTION/TERMINATION PROCEDURE FOR AMS FILE

%empty variables
execution_empty_variables = '\n\t\t\tempty AllVariables;';

%load the input data
execution_load_data = '\n\t\t\tLoad_Input_Data;';

%set the objective
if objective == 1
    execution_solve_problem = '\n\t\t\tsolve Cost_minimization;';
elseif objective == 2
    execution_solve_problem = '\n\t\t\tsolve Carbon_minimization;';
end

%write the output data
execution_write_data = '\n\t\t\tWrite_Output_Data;';

%compile problem solution to string
main_execution_procedure = strcat(main_execution_procedure,execution_empty_variables,execution_load_data,execution_solve_problem,execution_write_data);
