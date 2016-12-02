%% LOAD INPUT DATA

load_electricity_demand_data = '';
load_heating_demand_data = '';
load_cooling_demand_data = '';
load_dhw_demand_data = '';
load_anergy_demand_data = '';
load_solar_data = '';

if multiple_hubs == 0

    if consider_electricity_demand == 1
        load_electricity_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "electricity_demand.xlsx", Loads(t,''Elec''),"A1:A',num2str(number_of_timesteps),'","electricity_demand");');
    end
    if consider_heating_demand == 1
        load_heating_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "heating_demand.xlsx", Loads(t,''Heat''),"A1:A',num2str(number_of_timesteps),'","heating_demand");');
    end
    if consider_cooling_demand == 1
        load_cooling_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "cooling_demand.xlsx", Loads(t,''Cool''),"A1:A',num2str(number_of_timesteps),'","cooling_demand");');
    end
    if consider_dhw_demand == 1
        load_dhw_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "dhw_demand.xlsx", Loads(t,''DHW''),"A1:A',num2str(number_of_timesteps),'","dhw_demand");');
    end
    if consider_anergy_demand == 1
        load_anergy_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "anergy_demand.xlsx", Loads(t,''Anergy''),"A1:A',num2str(number_of_timesteps),'","anergy_demand");');
    end
    if isempty(solar_technologies) == 0
        load_solar_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "solar_inputs.xlsx", Solar_radiation(t),"A1:A',num2str(number_of_timesteps),'","solar");');
    end
    
else
    
    if consider_electricity_demand == 1
        load_electricity_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "electricity_demand.xlsx", Loads(t,''Elec'',h),"A1:',char('A' + number_of_hubs - 1),num2str(number_of_timesteps),'","electricity_demand");');
    end
    if consider_heating_demand == 1
        load_heating_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "heating_demand.xlsx", Loads(t,''Heat'',h),"A1:',char('A' + number_of_hubs - 1),num2str(number_of_timesteps),'","heating_demand");');
    end
    if consider_cooling_demand == 1
        load_cooling_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "cooling_demand.xlsx", Loads(t,''Cool'',h),"A1:',char('A' + number_of_hubs - 1),num2str(number_of_timesteps),'","cooling_demand");');
    end
    if consider_dhw_demand == 1
        load_dhw_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "dhw_demand.xlsx", Loads(t,''DHW'',h),"A1:',char('A' + number_of_hubs - 1),num2str(number_of_timesteps),'","dhw_demand");');
    end
    if consider_anergy_demand == 1
        load_anergy_demand_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "anergy_demand.xlsx", Loads(t,''Anergy'',h),"A1:',char('A' + number_of_hubs - 1),num2str(number_of_timesteps),'","anergy_demand");');
    end
    if isempty(solar_technologies) == 0
        load_solar_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "solar_inputs.xlsx", Solar_radiation(t,h),"A1:',char('A' + number_of_hubs - 1),num2str(number_of_timesteps),'","solar");');
    end
    
end

load_electricity_price_data = '';
if length(grid_electricity_price) > 1
    load_electricity_price_data = strcat('Spreadsheet::RetrieveParameter( "electricity_costs.xlsx", Operating_costs_grid(t),"A1:A',num2str(number_of_timesteps),'","electricity_costs");');
end

data_inputs_procedure = strcat(load_electricity_demand_data,load_heating_demand_data,load_cooling_demand_data,load_dhw_demand_data,load_anergy_demand_data,load_solar_data,load_electricity_price_data);
