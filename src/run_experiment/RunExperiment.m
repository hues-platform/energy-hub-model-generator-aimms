%% DESCRIPTION

% This script executes an experiment defined in SetupExperiments.m

%% SET SOME DATA OUTPUT OPTIONS

SetDataOutputOptions

%% GENERATE THE ENERGY HUB MODEL CODE

GenerateModel

disp('EHM generated successfully!');

%% EXECUTE THE ENERGY HUB MODEL IN AIMMS

if execute_energy_hub_model == 1
    fprintf('Running AIMMS \n');
    tic
    [status.run,out] = system('"C:\Program Files\AIMMS\AIMMS 4\Bin\aimms.exe" -m --run-only Main_Execution "aimms_model\\energy_hub\\energy_hub.aimms"');
    fprintf(' Done (%g seconds).\n',toc); % report
    
    disp('EHM executed successfully!');
end

%% VISUALIZE THE RESULTS

%not yet completed