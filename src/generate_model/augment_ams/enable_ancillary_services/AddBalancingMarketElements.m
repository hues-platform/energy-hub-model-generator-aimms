%% DESCRIPTION

%This file generates AMS code to enable bidding in electricity balancing
%markets in an energy hub model

%Author: Raphaela Tsaousi

%Insert description of the code and its functionality here

%% TODO

% Adding code to section lists won't work in many cases now because of the headers and footers in the sets section list

% Adjust the code in CompileAMS.m so the code below is included if necessary

% Certain of the elements below are not new, so need to replace or be
% integrated with existing elements.  This includes the load balance
% constraint and the last two objective functions.

% Make sure the index "s" is replaced with "z" for representing scenarios
% in the code below.

% Add relevant variables to the strings below so it works with different types of cases

% Modify the printing code so it works for different types of cases

% Create a variable in SetExperimentParams to set whether or not the below code should be included


%% GENERATE SETS

scenarios_set = '\n\t\tSet Scenarios {\n\t\t\tSubsetOf: Integers;\n\t\t\tIndex: z;\n\t\t\tDefinition: data{1};\n\t\t}';

%append to the sets list
sets_section = strcat(sets_section,scenarios_set);

%% GENERATE PARAMETERS

param_prob = '\n\t\tParameter Prob {\n\t\t\tIndexDomain: z;\n\t\t\tDefinition: 100\n\t\t}';

param_pr_P_W_TRLplus = '\n\t\tParameter pr_P_W_TRLplus {\n\t\t\tIndexDomain: t;\n\t\t\tRange: nonnegative;\n\t\t}';

param_pr_P_D_TRLplus = '\n\t\tParameter pr_P_D_TRLplus {\n\t\t\tIndexDomain: t;\n\t\t\tRange: nonnegative;\n\t\t}';

param_pr_E_W_TRLplus = '\n\t\tParameter pr_E_W_TRLplus {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: 0.06;\n\t\t}';

param_pr_E_D_TRLplus = '\n\t\tParameter pr_E_D_TRLplus {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: 0.06;\n\t\t}';

param_a_TRLplus = '\n\t\tParameter a_TRLplus {\n\t\t\tIndexDomain: (t,z);\n\t\t\tRange: binary;\n\t\t}';

%append to the parameters list
params_section = strcat(params_section,param_prob,param_pr_P_W_TRLplus,param_pr_P_D_TRLplus,param_pr_E_W_TRLplus,param_pr_E_D_TRLplus,param_a_TRLplus);

%% GENERATE VARIABLES

variable_Income_E_W_TRLplus = '\n\t\tVariable Income_E_W_TRLplus {\n\t\t\tIndexDomain: (t,x,s)| x=''Elec'';\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: pr_E_W_TRLplus*a_TRLplus(t,s)*P_W_TRLplus(t,x);\n\t\t}';

variable_Income_E_D_TRLplus = '\n\t\tVariable Income_E_D_TRLplus {\n\t\t\tIndexDomain: (t,x,s)| x=''Elec'';\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: pr_E_D_TRLplus*a_TRLplus(t,s)*P_D_TRLplus(t,x);\n\t\t}';

variable_Income_P_W_TRLplus = '\n\t\tVariable Income_P_W_TRLplus {\n\t\t\tIndexDomain: (t,x)| x=''Elec'';\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: pr_P_W_TRLplus(t)*P_W_TRLplus(t,x)/168;\n\t\t}';

variable_Income_P_D_TRLplus = '\n\t\tVariable Income_P_D_TRLplus {\n\t\t\tIndexDomain: (t,x)| x=''Elec'';\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: pr_P_D_TRLplus(t)*P_D_TRLplus(t,x)/4;\n\t\t}';

variable_P_TRLplus_storage = '\n\t\tVariable P_TRLplus_storage {\n\t\t\tIndexDomain: (t,x,s)| x=''Elec'';\n\t\t\tRange: nonnegative;\n\t\t}';

variable_P_W_TRLplus = '\n\t\tVariable P_W_TRLplus {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tRange: nonnegative;\n\t\t}';

variable_P_D_TRLplus = '\n\t\tVariable P_D_TRLplus {\n\t\t\tIndexDomain: (t,x) | x=''Elec'';\n\t\t\tRange: nonnegative;\n\t\t}';

%append to the variables list
variables_section = strcat(variables_section,variable_Income_E_W_TRLplus,variable_Income_E_D_TRLplus,variable_Income_P_W_TRLplus,variable_Income_P_D_TRLplus,variable_P_TRLplus_storage,variable_P_W_TRLplus,variable_P_D_TRLplus);

%% GENERATE OBJECTIVE FUNCTIONS

objectivefn_IncomeAvail = '\n\t\tVariable IncomeAvail {\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum(t, pr_P_W_TRLplus(t)*P_W_TRLplus(t,''Elec''))/168 +  sum(t, pr_P_D_TRLplus(t)*P_D_TRLplus(t,''Elec''))/4;\n\t\t}';

objectivefn_income_via_exports = '\n\t\tVariable Income_via_exports {\n\t\t\tIndexDomain: z;\n\t\t\tRange: nonnegative;\n\t\t\tDefinition: sum(x | x = ''Elec'', Electricity_feedin_price_renewables * sum(t, Exported_energy_renewable(t,x)) + Electricity_feedin_price_nonrenewables * sum(t, Exported_energy_nonrenewable(t,x))) + pr_E_W_TRLplus*sum(t,a_TRLplus(t,s)*P_W_TRLplus(t,''Elec''))*4/4 +  pr_E_D_TRLplus*sum(t,a_TRLplus(t,s)*P_D_TRLplus(t,''Elec''))*4/4;\n\t\t}';

objectivefn_total_cost = '\n\t\tVariable Total_cost {\n\t\t\tRange: free;\n\t\t\tDefinition: {\n\t\t\t\t-IncomeAvail + sum(z,Prob(z)*(Operating_cost(z) + Operating_cost_grid(z) + Maintenance_cost(z) - Income_via_exports(z)))/1\n\t\t\t}\n\t\t}';

%append to the objective functions list
objective_functions_section = strcat(objective_functions_section,objectivefn_IncomeAvail,objectivefn_income_via_exports,objectivefn_total_cost);

%% GENERATE CONSTRAINTS

constraint_P_TRLplus_bid = '\n\t\tConstraint P_TRLplus_bid_constraint {\n\t\t\tIndexDomain: (t,x,s);\n\t\t\tDefinition: P_W_TRLplus(t,x) + P_D_TRLplus(t,x) <= sum(conv, Capacity(''Elec'',conv)) - Loads(t,x) - Exported_energy_renewable(t,''Elec'') - Exported_energy_nonrenewable(t,''Elec'') + P_TRLplus_storage(t,''Elec'',s);\n\t\t}';

constraint_P_W_TRLplus_week = '\n\t\tConstraint P_W_TRLplus_week_constraint {\n\t\t\tIndexDomain: (t,x) | mod(t,168) <> 0 AND t<>first(Time) AND x="Elec";\n\t\t\tDefinition: P_W_TRLplus(t,x) = P_W_TRLplus(t-1,x);\n\t\t}';

constraint_P_D_TRLplus_4h = '\n\t\tConstraint P_D_TRLplus_4h_constraint {\n\t\t\tIndexDomain: (t,x) | mod(mod(t,24),4) <> 0 AND x="Elec";\n\t\t\tDefinition: P_D_TRLplus(t,x) = P_D_TRLplus(t+1,x);\n\t\t}';

constraint_Pstorage_TRLplus_energy = '\n\t\tConstraint Pstorage_TRLplus_energy_constraint {\n\t\t\tIndexDomain: (t,x,s) | x="Elec";\n\t\t\tDefinition: P_TRLplus_storage(t,x,s) <= Storage_SOC(t,x,s) - (Storage_capacity(x) * Storage_min_SOC(x));\n\t\t}';

constraint_Pstorage_TRLplus_discharge = '\n\t\tConstraint Pstorage_TRLplus_discharge_constraint {\n\t\t\tIndexDomain: (t,x,s) | x="Elec";\n\t\t\tDefinition: P_TRLplus_storage(t,x,s) <= Storage_max_discharge_rate(x)*Storage_capacity(x);\n\t\t}';

constraint_Load_balance = '\n\t\tConstraint Load_balance_constraint {\n\t\t\tIndexDomain: (t,x,s);\n\t\t\tDefinition: sum(conv, Input_energy(t,conv,s) * Cmatrix(x,conv)) + Storage_output_energy(t,x) - Storage_input_energy(t,x,s) = Loads(t,x) + Exported_energy_renewable(t,x) + Exported_energy_nonrenewable(t,x)+ a_TRLplus(t,s)*P_W_TRLplus(t,x) + a_TRLplus(t,s)*P_D_TRLplus(t,x);\n\t\t}';

%append to the constraints list
constraints_section = strcat(constraints_section,constraint_P_TRLplus_bid,constraint_P_W_TRLplus_week,constraint_P_D_TRLplus_4h,constraint_Pstorage_TRLplus_energy,constraint_Pstorage_TRLplus_discharge,constraint_Load_balance);

%% LOAD INPUT DATA

load_activation_hours = '\n\t\t\tSpreadsheet::RetrieveParameter( "Hourly TRLplus activation 2016 binary.xlsx", a_TRLplus(t,s),"A1:A168","hour of activation");';

load_trl_week_price = '\n\t\t\tSpreadsheet::RetrieveParameter( "TRL+ weekly prices over hour.xlsx", pr_P_W_TRLplus(t),"A1:A168","TRL+week price");';

load_trl_p_4h_price = '\n\t\t\tSpreadsheet::RetrieveParameter( "TRL+ 4h capacity prices over hour.xlsx", pr_P_D_TRLplus(t),"A1:A168","TRL+ P_4h price");';

%append to the inputs procedure list
data_inputs_procedure = strcat(data_inputs_procedure,load_activation_hours,load_trl_week_price,load_trl_p_4h_price);

%% WRITE OUTPUT DATA

trl_plus_data_for_printing = '';

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::CreateWorkbook("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx","P_TRLplus");');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx",P_W_TRLplus,"B2:C8761","A2:A8761","B1:C1","P_TRLplus",0,1,1);');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx",P_D_TRLplus,"E2:F8761","D2:D8761","E1:F1","P_TRLplus",0,1,1);');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx","P_TRLplus_storage");');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx",P_TRLplus_storage,"B2:C8761","A2:A8761","B1:C1","P_TRLplus_storage",0,1,1);');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx","Income_E_TRLplus");');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx",Income_E_W_TRLplus,"B2:C8761","A2:A8761","B1:C1","Income_E_TRLplus",0,1,1);');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx",Income_E_D_TRLplus,"E2:F8761","D2:D8761","E1:F1","Income_E_TRLplus",0,1,1);');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AddNewSheet("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx","Income_P_TRLplus");');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx",Income_P_W_TRLplus,"B2:C8761","A2:A8761","B1:C1","Income_P_TRLplus",0,1,1);');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::AssignTable("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx",Income_P_D_TRLplus,"E2:F8761","D2:D8761","E1:F1","Income_P_TRLplus",0,1,1);');

trl_plus_data_for_printing = strcat(trl_plus_data_for_printing,'\n\t\t\tSpreadsheet::CloseWorkbook("results/Generic_energy_hub_experiment_without_sizing/results_TRLplus.xlsx",1);');

%append to the outputs procedure list
data_outputs_procedure = strcat(data_outputs_procedure,trl_plus_data_for_printing);