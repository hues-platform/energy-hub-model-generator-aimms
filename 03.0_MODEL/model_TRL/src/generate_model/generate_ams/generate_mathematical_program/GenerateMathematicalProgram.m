%% GENERATE MATHEMATICAL PROGRAM FOR AMS FILE

program_cost_minimization = '';
program_carbon_minimization = '';

if objective == 1
    program_cost_minimization = '\n\t\tMathematicalProgram Cost_minimization {\n\t\t\tObjective: Total_cost;\n\t\t\tDirection: minimize;\n\t\t\tConstraints: AllConstraints;\n\t\t\tVariables: AllVariables;\n\t\t\tType: Automatic;\n\t\t}';
elseif objective == 2
    program_carbon_minimization = '\n\t\tMathematicalProgram Carbon_minimization {\n\t\t\tObjective: Total_carbon;\n\t\t\tDirection: minimize;\n\t\t\tConstraints: AllConstraints;\n\t\t\tVariables: AllVariables;\n\t\t\tType: Automatic;\n\t\t}';
end

%compile mathematical program to string
mathematical_program_section = strcat(program_cost_minimization,program_carbon_minimization);