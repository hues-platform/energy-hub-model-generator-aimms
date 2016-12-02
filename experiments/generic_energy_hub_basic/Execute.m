%% CLEAR THE WORKSPACE

clear
clc

%% SET THE PATH

%set this path to the root of the project
addpath(genpath('H:\projects\ModularEnergyHub\module_EHM_generation'));

%% SET THE SCENARIO

%load the default scenario data - this shouldn't be changed
LoadDefaultScenarioData

%set this to the name of the scenario script
TestScenario_SingleHubNoSizing

%% SET SOME OPTIONS

SetDataOutputOptions

%% GENERATE MODEL

GenerateModel

disp('EHM generated successfully!');

%% EXECUTE AIMMS MODEL

execute_energy_hub_model = 0;

if execute_energy_hub_model == 1
    fprintf('Running AIMMS \n');
    tic
    [status.run,out] = system('"C:\Program Files\AIMMS\AIMMS 4\Bin\aimms.exe" -m --run-only MainExecution "aimms_model\\energy_hub\\energy_hub.aimms"');
    fprintf(' Done (%g seconds).\n',toc); % report
    
    disp('EHM executed successfully!');
end

%% VISUALIZE RESULTS
%not yet implemented
