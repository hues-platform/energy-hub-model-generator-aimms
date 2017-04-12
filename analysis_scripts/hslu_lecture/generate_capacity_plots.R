library(openxlsx)
library(reshape)
library(ggplot2)
library(sqldf)

#set working directing using input args
path = commandArgs(trailingOnly=TRUE)
setwd(path)
      
#PLOT TECHNOLOGY CAPACITY ELECTRICITY
data = read.xlsx("results_capacities.xlsx","Capacity")
row.names(data) <- data$X1
data$X1 <- NULL 
data <- data.frame(t(data))
data_elec <- data.frame(data$Elec)
data_elec[,2] <- row.names(data)

ggplot(data_elec,aes(x=V2,y=data.Elec)) + geom_bar(stat = "identity") +
  labs(title="Electricity output capacity of conversion technologies",x="Technology", y="Capacity (kW)", legend.title="Technology")
ggsave(filename="Electricity_capacity_of_technologies.png",width=12,height=5)


#PLOT TECHNOLOGY CAPACITY HEAT
data = read.xlsx("results_capacities.xlsx","Capacity")
row.names(data) <- data$X1
data$X1 <- NULL 
data <- data.frame(t(data))
data_heat <- data.frame(data$Heat)
data_heat[,2] <- row.names(data)

ggplot(data_heat,aes(x=V2,y=data.Heat)) + geom_bar(stat = "identity") +
  labs(title="Heat output capacity of conversion technologies",x="Technology", y="Capacity (kW)", legend.title="Technology")
ggsave(filename="Heat_capacity_of_technologies.png",width=12,height=5)


#PLOT STORAGE TECHNOLOGY CAPACITIES
setwd("C://Users//boa//Documents//Repositories_Github//energy-hub-model-generator-aimms//analysis_scripts//hslu_lecture//Exercise_1")
data = read.xlsx("results_capacities.xlsx","Storage_capacity",colNames=FALSE)

ggplot(data,aes(x=X1,y=X2)) + geom_bar(stat = "identity") +
  labs(title="Capacity of storage technologies",x="Technology", y="Capacity (kWh)", legend.title="Storage technology")
ggsave(filename="Storage_capacity_of_technologies.png",width=12,height=5)
