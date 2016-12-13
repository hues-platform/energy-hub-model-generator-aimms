%% GENERATE MAIN EXECUTION/TERMINATION PROCEDURE FOR AMS FILE

%empty variables
execution_empty_variables = '\n\t\t\tempty AllVariables;';

%relaxations
%TODO: not sure if this is necessary
relaxations_string = '';
if select_techs_and_do_sizing == 1
    non_solar_heat_generating_technologies_excluding_chp = unique_technologies.conversion_techs_names(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(strcmp(unique_technologies.conversion_techs_outputs,'Heat'))));
    non_solar_electricity_generating_technologies_excluding_chp = unique_technologies.conversion_techs_names(intersect(find(~strcmp(unique_technologies.conversion_techs_inputs,'Solar')),find(strcmp(unique_technologies.conversion_techs_outputs,'Elec'))));
    for t=1:length(non_solar_heat_generating_technologies_excluding_chp)
        if multiple_hubs == 0
            relaxations_string = strcat(relaxations_string,'\n\t\t\tCapacity(''Heat'',''',char(non_solar_heat_generating_technologies_excluding_chp(t)),''').relax := 1;');
        else
            relaxations_string = strcat(relaxations_string,'\n\t\t\tCapacity(''Heat'',''',char(non_solar_heat_generating_technologies_excluding_chp(t)),''',h).relax := 1;');
        end
    end
    for t=1:length(non_solar_electricity_generating_technologies_excluding_chp)
        if multiple_hubs == 0
            relaxations_string = strcat(relaxations_string,'\n\t\t\tCapacity(''Elec'',''',char(non_solar_electricity_generating_technologies_excluding_chp(t)),''').relax := 1;');
        else
            relaxations_string = strcat(relaxations_string,'\n\t\t\tCapacity(''Elec'',''',char(non_solar_electricity_generating_technologies_excluding_chp(t)),''',h).relax := 1;');
        end
    end
end
execution_relaxations = relaxations_string;

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
main_execution_procedure = strcat(main_execution_procedure,execution_empty_variables,execution_relaxations,execution_load_data,execution_solve_problem,execution_write_data);
