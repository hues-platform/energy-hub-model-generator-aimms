
# DESCRIPTION OF THE SCRIPT: 
# This script generates plots from the results of an energy hub model, and saves the plots as PNG images.
# The script generates plots of technology capacities, carbon emissions, costs and production quantities.
# To use the script, the working directory and names of experiments need to be manually set.

# LIMITATIONS OF THE SCRIPT: 
# Works only for single-node systems
# Works only for systems with heat and electricity demand. The code may easily be extended to account for other types of demand.
# Heat and electricity storage and assumed to be named "Heat" and "Elec", respectively, in the results files.


# load the necessary libraries
library(openxlsx)
library(reshape2)
library(ggplot2)
library(sqldf)

# no strings as factors
options(stringsAsFactors = FALSE)

# set the working directory - the path to the directory where the results are stored
setwd("C:\\Users\\boa\\Documents\\Repositories_Github\\energy-hub-model-generator-aimms\\aimms_model\\energy_hub\\results")

#set the experiments - list the names of the directories containing the XLSX results files from AIMMS
experiments = c("Generic_energy_hub_experiment_with_sizing")

#create some dataframes for saving data
results_capacity_heat <- data.frame(value=numeric(),technology=character(),experiment=character())
results_capacity_electricity <- data.frame(value=numeric(),technology=character(),experiment=character())
results_storage_capacity <- data.frame(value=numeric(),technology=character(),experiment=character())
results_production_elec <- data.frame(week=numeric(),technology=character(),value=numeric(),experiment=character())
results_production_heat <- data.frame(week=numeric(),technology=character(),value=numeric(),experiment=character())
results_total_production_elec <- data.frame(technology=character(),value=numeric(),experiment=character())
results_total_production_heat <- data.frame(technology=character(),value=numeric(),experiment=character())
results_total_cost <- data.frame(technology=character(),total_cost=numeric(),experiment=character())
results_emissions <- data.frame(technology=character(),total_cost=numeric(),experiment=character())

for(experiment in experiments) {
  
  ##### EXTRACT PRODUCTION CAPACITY DATA #####
  
  filename = paste(experiment,"\\results_capacities.xlsx",sep='')
  data = read.xlsx(filename,"Capacity")
  
  row.names(data) <- data$X1
  data$X1 <- NULL 
  data <- data.frame(t(data))
  data_elec <- data.frame(data$Elec)
  data_elec[,2] = rownames(data)
  
  newcol <- rep(experiment,length(data_elec[,1]))
  data_elec <- cbind(data_elec,newcol)
  colnames(data_elec) <- c("value","technology","experiment")
  
  results_capacity_electricity = rbind(results_capacity_electricity,data_elec)
  
  data_heat <- data.frame(data$Heat)
  data_heat[,2] <- row.names(data)
  
  newcol <- rep(experiment,length(data_heat[,1]))
  data_heat <- cbind(data_heat,newcol)
  colnames(data_heat) <- c("value","technology","experiment")
  results_capacity_heat = rbind(results_capacity_heat,data_heat)
  
  ##### EXTRACT STORAGE CAPACITY DATA #####
  
  filename = paste(experiment,"\\results_capacities.xlsx",sep='')
  data = read.xlsx(filename,"Storage_capacity",colNames=FALSE,rowNames=FALSE)
  
  if (experiment == "NetMetering") {
    data$X1 <- gsub("Battery","Elec",data$X1)
    data$X1 <- gsub("Hot_water_tank","Heat",data$X1)
    data <- data[-grep("Net_meter",data$X1),]
  }
  
  newcol <- rep(experiment,length(data[,1]))
  data <- cbind(data,newcol)
  colnames(data) <- c("technology","value","experiment")
  results_storage_capacity = rbind(results_storage_capacity,data)
  
  ##### EXTRACT PRODUCTION DATA #####
  
  #electricity production
  filename = paste(experiment,"\\results_conversion.xlsx",sep='')
  data = read.xlsx(filename,"Output_energy_electricity")
  
  filename = paste(experiment,"\\results_storage.xlsx",sep='')
  data_stor = read.xlsx(filename,"Storage_output_energy")
  
  data_stor <- data.frame(data_stor$Elec)
  colnames(data_stor) <- c("Storage")
  data <- cbind(data,data_stor)
  
  hrs_in_wk = 7 * 24
  wks_in_yr = round((8760 / (24 * 7)))
  t <- data.frame()
  for(i in 1:wks_in_yr) {
    j = list(rep(i,hrs_in_wk))
    t <- rbind(t,j)
  }
  t[8737:8760,] = 53
  row.names(t) = NULL
  colnames(t) = c('weeks')
  data <- cbind(t,data)
  
  data_melted <- melt(data, id=c("weeks","X1"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","technology","value","experiment")
  results_production_elec <- rbind(results_production_elec,data_summed)
  
  data_total_summed <- sqldf('select variable, sum(value) as value from data_melted group by variable')
  newcol <- rep(experiment,length(data_total_summed[,1]))
  data_total_summed <- data.frame(cbind(data_total_summed,newcol))
  colnames(data_total_summed) <- c("technology","value","experiment")
  results_total_production_elec <- rbind(results_total_production_elec,data_total_summed)
  
  #heat production
  filename = paste(experiment,"\\results_conversion.xlsx",sep='')
  data = read.xlsx(filename,"Output_energy_heat")
  
  filename = paste(experiment,"\\results_storage.xlsx",sep='')
  data_stor = read.xlsx(filename,"Storage_output_energy")
  
  data_stor <- data.frame(data_stor$Heat)

  colnames(data_stor) <- c("Storage")
  data <- cbind(data,data_stor)
  data <- cbind(t,data)
  
  data_melted <- melt(data, id=c("weeks","X1"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","technology","value","experiment")
  results_production_heat <- rbind(results_production_heat,data_summed)
  
  data_total_summed <- sqldf('select variable, sum(value) as value from data_melted group by variable')
  newcol <- rep(experiment,length(data_total_summed[,1]))
  data_total_summed <- data.frame(cbind(data_total_summed,newcol))
  colnames(data_total_summed) <- c("technology","value","experiment")
  results_total_production_heat <- rbind(results_total_production_heat,data_total_summed)
  
  ##### EXTRACT COST DATA #####
  
  filename = paste(experiment,"\\results_costs.xlsx",sep='')
  data1 = read.xlsx(filename,"Total_cost_per_technology",colNames=FALSE)
  data2 = read.xlsx(filename,"Total_cost_grid",colNames=FALSE)
  data3 = read.xlsx(filename,"Total_cost_per_storage",colNames=FALSE)
  data4 = read.xlsx(filename,"Income_via_exports",colNames=FALSE)
  
  data2[1,1] = data2[1,1] - data4[1,1]
  
  data2b <- data.frame()
  data2b[1,1] = 'Grid'
  data2b[1,2] = data2[1,1]
  colnames(data2b) <- c('X1','X2')
  data <- rbind(data1,data2b,data3)
  data <- sqldf('select X1, sum(X2) as X2 from data group by X1 order by X1')
  total_cost <- sum(data$X2)
  
  newcol <- rep(experiment,length(data[,1]))
  data5 <- data.frame(cbind(data,newcol))
  colnames(data5) <- c("technology","value","experiment")
  results_total_cost <- rbind(results_total_cost,data5)
  
  total_income = as.numeric(data4$X1)
  total_income2 <- data.frame(cbind(total_income,experiment))
  colnames(total_income2) <- c("value","experiment")
  results_total_income <- rbind(results_total_income,total_income2)
  results_total_income$value <- as.numeric(results_total_income$value) 
  
  #EXTRACT THE CARBON EMISSIONS
  filename = paste(experiment,"\\results_emissions.xlsx",sep='')
  data = read.xlsx(filename,"Total_carbon_per_technology",colNames=FALSE)
  
  emissions <- data.frame(cbind(data,experiment))
  colnames(emissions) <- c("technology","value","experiment")
  results_emissions <- rbind(results_emissions,emissions)
  results_emissions$value <- as.numeric(results_emissions$value)
}

# CREATE THE PLOTS
ggplot(results_capacity_electricity,aes(x=experiment,y=value,fill=technology)) + geom_bar(stat="identity") +
  labs(title="Electricity output capacity of conversion technologies",x="Experiment", y="Capacity (kW)")
ggsave("comparison_electricity_production_capacity.png")

ggplot(results_capacity_heat,aes(x=experiment,y=value,fill=technology)) + geom_bar(stat="identity") +
  labs(title="Heat output capacity of conversion technologies",x="Experiment", y="Capacity (kW)")
ggsave("comparison_heat_production_capacity.png")

ggplot(results_storage_capacity,aes(x=experiment,y=value,fill=technology)) + geom_bar(stat="identity") +
  labs(title="Capacity of storage technologies",x="Experiment", y="Capacity (kW)")
ggsave("comparison_storage_capacity.png")

ggplot(results_total_cost,aes(x=experiment,y=value,fill=technology)) + geom_bar(stat="identity") +
  labs(title="Total cost",x="Experiment", y="Cost (CHF)")
ggsave("comparison_total_cost.png")

ggplot(results_total_income,aes(x=experiment,y=value)) + geom_bar(stat="identity") +
  labs(title="Total income",x="Experiment", y="Cost (CHF)")
ggsave("comparison_total_income.png")

ggplot(results_emissions,aes(x=experiment,y=value,fill=technology)) + geom_bar(stat="identity") +
  labs(title="Total emissions",x="Experiment", y="Emissions (CO2-eq)")
ggsave("comparison_total_emissions.png")

ggplot(results_production_elec,aes(x=week,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Electricity supplied per technology (weekly)",x="Week", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank()) + facet_grid(experiment ~ .)
ggsave("comparison_weekly_electricity_production.png")

ggplot(results_production_heat,aes(x=week,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Heat supplied per technology (weekly)",x="Week", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank()) + facet_grid(experiment ~ .)
ggsave("comparison_weekly_heat_production.png")

ggplot(results_total_production_elec,aes(x=experiment,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Total electricity supplied",x="Experiment", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())
ggsave("comparison_total_electricity_production.png")

ggplot(results_total_production_heat,aes(x=experiment,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Total heat supplied",x="Experiment", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())
ggsave("comparison_total_heat_production.png")

