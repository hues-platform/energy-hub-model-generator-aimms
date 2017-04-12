%% DESCRIPTION

% This script executes an experiment defined in SetupExperiments.m

tic

%% SET SOME DATA OUTPUT OPTIONS

SetDataOutputOptions

%% GENERATE THE ENERGY HUB MODEL CODE

GenerateModel

disp('EHM generated successfully!');

%% EXECUTE THE ENERGY HUB MODEL IN AIMMS

if execute_energy_hub_model == 1
    %fprintf('Running AIMMS \n');
    [status.run,out] = system(['"',aimms_executable_path,'" -m --run-only Main_Execution "aimms_model\\energy_hub\\energy_hub.aimms"']);
    disp('EHM executed successfully!');
end

%% VISUALIZE THE RESULTS

if visualize_model_results == 1
    
    path_for_r = [analysis_scripts_path,experiment_name];
    copyfile(strcat('aimms_model\energy_hub\results\',experiment_name),path_for_r);
    path_for_r = strrep(path_for_r,'\','//');
    [status.run,out] = system(['Rscript ',analysis_scripts_path,'generate_plots.R ',path_for_r]);
    
    if select_techs_and_do_sizing == 1
        [status.run,out] = system(['Rscript ',analysis_scripts_path,'generate_capacity_plots.R']);
    end
    disp('EHM results visualized successfully!');
end

fprintf(' Done (%g seconds).\n',toc); % report