
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
setwd("C:\\Users\\Raphaela\\Dropbox\\MASTER THESIS\\Model Design\\Model Option5 (historic prices for everything)\\Model Option5\\aimms_model\\energy_hub\\results")

#set the experiments - list the names of the directories containing the XLSX results files from AIMMS
experiments = c("Generic_energy_hub_experiment_without_sizing")

#create some dataframes for saving data
results_production_elec <- data.frame(week=numeric(),technology=character(),value=numeric(),experiment=character())
results_production_heat <- data.frame(week=numeric(),technology=character(),value=numeric(),experiment=character())
results_total_production_elec <- data.frame(technology=character(),value=numeric(),experiment=character())
results_total_production_heat <- data.frame(technology=character(),value=numeric(),experiment=character())
results_total_cost <- data.frame(technology=character(),total_cost=numeric(),experiment=character())
results_emissions <- data.frame(technology=character(),total_cost=numeric(),experiment=character())
#results_production_trlplus  <- data.frame(bid=character(),value=numeric(),experiment=character())
results_weekly_production_trlplus  <- data.frame(bid=character(),value=numeric(),experiment=character())
results_total_production_trlplus  <- data.frame(bid=character(),value=numeric(),experiment=character())
#results_income_trlplus  <- data.frame(bid=character(),value=numeric(),experiment=character())
results_weekly_income_trlplus <- data.frame(bid=character(),value=numeric(),experiment=character())
results_total_income_trlplus <- data.frame(bid=character(),value=numeric(),experiment=character())

results_demand <- data.frame(week=numeric(),value=numeric(),experiment=character())
results_input_energy <- data.frame(week=numeric(),value=numeric(),experiment=character())
results_total_input_energy<- data.frame(technology=character(),value=numeric(),experiment=character())
results_storage_elec <- data.frame(week=numeric(),value=numeric(),experiment=character())
results_storage_heat<- data.frame(week=numeric(),value=numeric(),experiment=character())
results_weekly_activation_trlplus <- data.frame(week=numeric(),activation=character(),value=numeric(),experiment=character())


for(experiment in experiments) {
  ##### EXTRACT DATA #####
  filenameD = paste(experiment,"\\results_demands.xlsx",sep='')
  datadem =  read.xlsx(filenameD,"Energy_demands")
  
  
  filenameC = paste(experiment,"\\results_conversion.xlsx",sep='')
  dataOut_E = read.xlsx(filenameC,"Output_energy_electricity")
  dataOut_H = read.xlsx(filenameC,"Output_energy_heat")
  dataIn = read.xlsx(filenameC,"Input_energy")
  dataHour <- data.frame(dataOut_E[,1])
  
  
  
  filenameS = paste(experiment,"\\results_storage.xlsx",sep='')
  data_storO = read.xlsx(filenameS,"Storage_output_energy")
  data_storI = read.xlsx(filenameS,"Storage_input_energy")
  data_storsoc = read.xlsx(filenameS,"Storage_SOC")
  data_storOut_E <- data.frame(data_storO$Elec)
  data_storIn_E <- data.frame(data_storI$Elec)
  #data_storSOC_E <- data.frame(data_storsoc$Elec)
  data_storOut_H <- data.frame(data_storO$Heat)
  data_storIn_H <- (-1)*(data.frame(data_storI$Heat))
  # data_storSOC_H <- data.frame(data_storsoc$Heat)
  
  
  colnames(data_storOut_E) <- c("Storage Out")
  colnames(data_storIn_E) <- c("Storage In")
  #colnames(data_storSOC_E) <- c("Storage SOC")
  colnames(data_storOut_H) <- c("Storage Out H")
  colnames(data_storIn_H) <- c("Storage In H")
 # colnames(data_storSOC_H) <- c("Storage SOC")
  colnames(dataHour) <- c("hour")
  
  #TRL plus
  filename = paste(experiment,"\\results_TRLplus.xlsx",sep='')
  data1 = read.xlsx(filename,"P_TRLplus")
  data2= read.xlsx(filename,"P_TRLplus_storage")
  data3 = read.xlsx(filename,"Income_E_TRLplus")
  data4 = read.xlsx(filename,"Income_P_TRLplus")
  
  #this should change according to the activation scheme
  filename = paste(experiment,"\\binary activation.xlsx",sep='')
  data5 = read.xlsx(filename,"hour of activation")
  
  
  dataPw <- data.frame(data1[,2])
  dataPd <- data.frame(data1[,5])
  dataElm <- data.frame(data1[,8])
  dataHour <- data.frame(data1[,1])
  dataPStor <- data.frame(data2[,2])
  dataIncEw <- data.frame(data3[,2])
  dataIncEd <- data.frame(data3[,5])
  dataIncElm <- data.frame(data3[,8])
  dataIncPw <- data.frame(data4[,2])
  dataIncPd <- data.frame(data4[,5])
  dataAtrl <- data.frame(data5$a)
  
  colnames(dataPw) <- c("Pw")
  colnames(dataPd) <- c("Pd")
  colnames(dataElm) <- c("Elm")
  colnames(dataHour) <- c("hour")
  colnames(dataPStor) <- c("Pstorage")
  colnames(dataIncEw) <- c("Inc_Ew")
  colnames(dataIncEd) <- c("Inc_Ed")
  colnames(dataIncElm) <- c("Inc_Elm")
  colnames(dataIncPw) <- c("Inc_Pw")
  colnames(dataIncPd) <- c("Inc_Pd")
  colnames(dataAtrl) <- c("a_trlplus")
  
  
  
  
  #Weekly electricity output 
  dataOutALL_E <- cbind(dataOut_E,data_storOut_E,dataPStor)
  
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
  dataOutALL_E <- cbind(t,dataOutALL_E)
  
  data_melted <- melt(dataOutALL_E, id=c("weeks","X1"))
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
  
  #Weekly production of heat
  dataOutALL_H <- cbind(dataOut_H,data_storOut_H)
  dataOutALL_H <- cbind(t,dataOutALL_H)
  
  data_melted <- melt(dataOutALL_H, id=c("weeks","X1"))
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
  
  
  #input energy graph
  dataInALL <- cbind(t,dataIn)
  
  data_melted <- melt(dataInALL, id=c("weeks","X1"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","technology","value","experiment")
  results_input_energy <- rbind(results_input_energy,data_summed)
  
  data_total_summed <- sqldf('select variable, sum(value) as value from data_melted group by variable')
  newcol <- rep(experiment,length(data_total_summed[,1]))
  data_total_summed <- data.frame(cbind(data_total_summed,newcol))
  colnames(data_total_summed) <- c("technology","value","experiment")
  results_total_input_energy <- rbind(results_total_input_energy,data_total_summed)
  
  
  
  #weekly total demand
  data_DemALL <- cbind(t,datadem)
  
  data_melted <- melt(data_DemALL, id=c("weeks","X1"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","Output","value","experiment")
  results_demand <- rbind(results_demand,data_summed)
  
  
  
  #heat storage graph
  
  #weekly
  dataStorage <- cbind(t,data_storOut_H,data_storIn_H)
  data_melted <- melt(dataStorage, id=c("weeks"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","State","value","experiment")
  results_storage_heat <- rbind(results_storage_heat,data_summed)
  
  
  #elec storage
  #weekly
  dataStorage <- cbind(t,data_storOut_E,(-1)*data_storIn_E,dataPStor)
  data_melted <- melt(dataStorage, id=c("weeks"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","State","value","experiment")
  results_storage_elec <- rbind(results_storage_elec,data_summed)
  
  
  
  #bidding
  #Power supplied for bidding weekly
  dataPtrlplusALL <- cbind(t,dataPw,dataPd,dataElm)
  data_melted <- melt(dataPtrlplusALL, id=c("weeks"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","bid","value","experiment")
  results_weekly_production_trlplus <- rbind(results_weekly_production_trlplus,data_summed)
  
  #total power supplied per bid
  data_total_summed <- sqldf('select variable, sum(value) as value from data_melted group by variable')
  newcol <- rep(experiment,length(data_total_summed[,1]))
  data_total_summed <- data.frame(cbind(data_total_summed,newcol))
  colnames(data_total_summed) <- c("bid","value","experiment")
  results_total_production_trlplus <- rbind(results_total_production_trlplus,data_total_summed)
  
  
  #Weekly income from bidding
  data_Inc_PtrlplusALL <- cbind(t,dataIncEw,dataIncEd,dataIncElm,dataIncPw,dataIncPd)
  data_melted <- melt(data_Inc_PtrlplusALL, id=c("weeks"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","bid","value","experiment")
  results_weekly_income_trlplus <- rbind(results_weekly_income_trlplus,data_summed)
  
  data_total_summed <- sqldf('select variable, sum(value) as value from data_melted group by variable')
  newcol <- rep(experiment,length(data_total_summed[,1]))
  data_total_summed <- data.frame(cbind(data_total_summed,newcol))
  colnames(data_total_summed) <- c("bid","value","experiment")
  results_total_income_trlplus <- rbind(results_total_income_trlplus,data_total_summed)
  
  #activation graph
  
  dataAtrl <- cbind(t,dataAtrl)
  data_melted <- melt(dataAtrl, id=c("weeks"))
  data_summed <- sqldf('select weeks, variable, sum(value) as value from data_melted group by weeks,variable order by weeks')
  newcol <- rep(experiment,length(data_summed[,1]))
  data_summed <- data.frame(cbind(data_summed,newcol))
  colnames(data_summed) <- c("week","bid","value","experiment")
  results_weekly_activation_trlplus <- rbind(results_weekly_activation_trlplus,data_summed)
  
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
  
  
  
  #EXTRACT THE CARBON EMISSIONS
  filename = paste(experiment,"\\results_emissions.xlsx",sep='')
  data = read.xlsx(filename,"Total_carbon_per_technology",colNames=FALSE)
  
  emissions <- data.frame(cbind(data,experiment))
  colnames(emissions) <- c("technology","value","experiment")
  results_emissions <- rbind(results_emissions,emissions)
  results_emissions$value <- as.numeric(results_emissions$value)
  
}


# CREATE THE PLOTS
ggplot(results_total_cost,aes(x=technology,y=value,fill=technology)) + geom_bar(stat="identity") +
  labs(title="Total cost",x="Experiment", y="Cost (CHF)")
ggsave("comparison_total_cost.png", width = 25, height = 20, units = "cm")


ggplot(results_emissions,aes(x=technology,y=value,fill=technology)) + geom_bar(stat="identity") +
  labs(title="Total emissions",x="Experiment", y="Emissions (CO2-eq)")
ggsave("comparison_total_emissions.png", width = 25, height = 20, units = "cm")

ggplot(results_production_elec,aes(x=week,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Electricity supplied per technology (weekly)",x="Week", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank()) + facet_grid(experiment ~ .)
ggsave("comparison_weekly_electricity_production.png", width = 25, height = 20, units = "cm")

ggplot(results_production_heat,aes(x=week,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Heat supplied per technology (weekly)",x="Week", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank()) + facet_grid(experiment ~ .)
ggsave("comparison_weekly_heat_production.png", width = 25, height = 20, units = "cm")

ggplot(results_total_production_elec,aes(x=technology,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Total electricity supplied",x="Experiment", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())
ggsave("comparison_total_electricity_production.png", width = 25, height = 20, units = "cm")

ggplot(results_total_production_heat,aes(x=technology,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Total heat supplied",x="Experiment", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())
ggsave("comparison_total_heat_production.png", width = 25, height = 20, units = "cm")

ggplot(results_weekly_production_trlplus,aes(x=week,y=value,fill=bid)) + geom_bar(stat = "identity") +
  labs(title="Weekly TRLplus bid ",x="Week", y="Power supplied (kW)")
ggsave("comparison_weekly_electricity_bid.png", width = 25, height = 20, units = "cm")

ggplot(results_total_production_trlplus,aes(x=bid,y=value,fill=bid)) + geom_bar(stat = "identity") +
  labs(title="Total TRLplus bids",x="bid", y="Power supplied (kW)")
ggsave("total bids.png", width = 25, height = 20, units = "cm")


ggplot(results_weekly_income_trlplus,aes(x=week,y=value,fill=bid)) + geom_bar(stat = "identity") +
  labs(title="Weekly Income from TRLplus bidding",x="Week", y="Income (chf)")
ggsave("comparison_weekly_electricity_bid_income.png", width = 25, height = 20, units = "cm")

ggplot(results_total_income_trlplus,aes(x=bid,y=value,fill=bid)) + geom_bar(stat = "identity") +
  labs(title="Income from TRLplus bids",x="bid", y="Income (chf)")
ggsave("total bids_income.png", width = 25, height = 20, units = "cm")



ggplot(results_storage_elec,aes(x=week,y=value,fill=State)) + geom_bar(stat = "identity") +
  labs(title="Weekly Electricity in and out of the storage",x="Week", y="Energy supplied (kW)") +
  theme(legend.title = element_blank()) + facet_grid(experiment ~ .)
ggsave("Weekly_Electricity_in_and_out_of_the_storage.png", width = 25, height = 20, units = "cm")

ggplot(results_storage_heat,aes(x=week,y=value,fill=State)) + geom_bar(stat = "identity") +
  labs(title="Weekly Heat in and out of the storage",x="Week", y="Energy supplied (kW)") +
  theme(legend.title = element_blank()) + facet_grid(experiment ~ .)
ggsave("Weekly_Heat_in_and_out_of_the_storage.png", width = 25, height = 20, units = "cm")

ggplot(results_input_energy,aes(x=week,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Weekly Input energy per technology",x="Week", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank()) + facet_grid(experiment ~ .)
ggsave("comparison_weekly_input_energy.png",width = 25, height = 20, units = "cm")

ggplot(results_total_input_energy,aes(x=technology,y=value,fill=technology)) + geom_bar(stat = "identity") +
  labs(title="Total input energy",x="Experiment", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())
ggsave("comparison_total_input_energy.png", width = 25, height = 20, units = "cm")


ggplot(results_demand,aes(x=week,y=value,fill=Output)) + geom_bar(stat = "identity") +
  labs(title="Weekly demand",x="Week", y="demand (kWh)") +
  theme(legend.title = element_blank()) + facet_grid(experiment ~ .)
ggsave("comparison_weekly_demand.png", width = 25, height = 20, units = "cm")

ggplot(results_weekly_activation_trlplus,aes(x=week,y=value)) + geom_bar(stat = "identity",fill="blue") +
  labs(title="Weekly TRLplus activation",x="week", y="activated or not")
ggsave("TRLplus_activation.png", width = 25, height = 20, units = "cm")





