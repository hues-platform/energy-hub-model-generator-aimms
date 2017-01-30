%% LOAD INPUT DATA

load_demand_data = '';
load_solar_data = '';

if multiple_hubs == 0

    for d = demand_types
        load_demand_data = strcat(load_demand_data,'\n\t\t\tSpreadsheet::RetrieveParameter( "input_data/',char(d),'_demand.xlsx", Loads(t,''',char(d),'''),"A1:A',num2str(number_of_timesteps),'","demand");');
    end

    if isempty(solar_technologies) == 0
        load_solar_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "input_data/solar_inputs.xlsx", Solar_radiation(t),"A1:A',num2str(number_of_timesteps),'","solar");');
    end
    
else
    
    for d = demand_types
        load_demand_data = strcat(load_demand_data,'\n\t\t\tSpreadsheet::RetrieveParameter( "input_data/',char(d),'_demand.xlsx", Loads(t,''',char(d),''',h),"A1:',char('A' + number_of_hubs - 1),num2str(number_of_timesteps),'","demand");');
    end
    
    if isempty(solar_technologies) == 0
        load_solar_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "input_data/solar_inputs.xlsx", Solar_radiation(t,h),"A1:',char('A' + number_of_hubs - 1),num2str(number_of_timesteps),'","solar");');
    end
    
end

load_electricity_price_data = '';
if length(grid_electricity_price) > 1
    load_electricity_price_data = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "input_data/electricity_costs.xlsx", Operating_costs_grid(t),"A1:A',num2str(number_of_timesteps),'","electricity_costs");');
end

load_electricity_feedin_price_data_renewables = '';
if length(grid_electricity_feedin_price_renewables) > 1
    load_electricity_feedin_price_data_renewables = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "input_data/electricity_feed_in_price_renewables.xlsx", Electricity_feedin_price_renewables(t),"A1:A',num2str(number_of_timesteps),'","price");');
end

load_electricity_feedin_price_data_nonrenewables = '';
if length(grid_electricity_feedin_price_nonrenewables) > 1
    load_electricity_feedin_price_data_nonrenewables = strcat('\n\t\t\tSpreadsheet::RetrieveParameter( "input_data/electricity_feed_in_price_nonrenewables.xlsx", Electricity_feedin_price_nonrenewables(t),"A1:A',num2str(number_of_timesteps),'","price");');
end

data_inputs_procedure = strcat(load_demand_data,load_solar_data,load_electricity_price_data,load_electricity_feedin_price_data_renewables,load_electricity_feedin_price_data_nonrenewables);
