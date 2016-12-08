

%% SET THE SCENARIO

Scenario_PricePolicyExperiments

%% SET SOME OPTIONS

SetDataOutputOptions

%% GENERATE MODEL

GenerateModel

disp('EHM generated successfully!');

%% EXECUTE AIMMS MODEL

execute_energy_hub_model = 1;

if execute_energy_hub_model == 1
    fprintf('Running AIMMS \n');
    tic
    [status.run,out] = system('"C:\Program Files\AIMMS\AIMMS 4\Bin\aimms.exe" -m --run-only Main_Execution "aimms_model\\energy_hub\\energy_hub.aimms"');
    fprintf(' Done (%g seconds).\n',toc); % report
    
    disp('EHM executed successfully!');
end

%%