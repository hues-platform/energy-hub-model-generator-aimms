%% GENERATE MATHEMATICAL PROGRAM FOR AMS FILE

header_mathematical_programs_section = '\n\tDeclarationSection Mathematical_programs {';

program_cost_minimization = '';
program_carbon_minimization = '';

if objective == 1
    program_cost_minimization = '\n\t\tMathematicalProgram Cost_minimization {\n\t\t\tObjective: Total_cost;\n\t\t\tDirection: minimize;\n\t\t\tConstraints: AllConstraints;\n\t\t\tVariables: AllVariables;\n\t\t\tType: Automatic;\n\t\t}';
elseif objective == 2
    program_carbon_minimization = '\n\t\tMathematicalProgram Carbon_minimization {\n\t\t\tObjective: Total_carbon;\n\t\t\tDirection: minimize;\n\t\t\tConstraints: AllConstraints;\n\t\t\tVariables: AllVariables;\n\t\t\tType: Automatic;\n\t\t}';
end

footer_mathematical_programs_section = '\n\t}';

%compile mathematical program to string
mathematical_program_section = strcat(header_mathematical_programs_section,program_cost_minimization,program_carbon_minimization,footer_mathematical_programs_section);