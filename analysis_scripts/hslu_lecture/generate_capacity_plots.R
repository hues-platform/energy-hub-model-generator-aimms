library(openxlsx)
library(reshape)
library(ggplot2)
library(sqldf)

#set working directing using input args
path = commandArgs(trailingOnly=TRUE)
setwd(path)

#PLOT ELECTRICITY OUTPUT OF TECHNOLOGIES PER HOUR
data = read.xlsx("results_conversion.xlsx","Output_energy_Elec")
data_stor = read.xlsx("results_storage.xlsx","Storage_output_energy")
data_stor <- data.frame(data_stor$Elec)
colnames(data_stor) <- c("Storage")
data <- cbind(data,data_stor)
data_melted <- melt(data, id=c("X1"))

#plot per hour
ggplot(data_melted,aes(x=X1,y=value,fill=variable)) + geom_bar(stat = "identity") +
  labs(title="Electricity supplied per technology (hourly)",x="Hour", y="Energy supplied (kWh)", legend.title="Technology") +
  theme(legend.title = element_blank())
ggsave(filename="Electricity_output_per_technology.png",width=12,height=5)


#PLOT HEAT OUTPUT OF TECHNOLOGIES PER HOUR
data = read.xlsx("results_conversion.xlsx","Output_energy_Heat")
data_stor = read.xlsx("results_storage.xlsx","Storage_output_energy")
data_stor <- data.frame(data_stor$Heat)
colnames(data_stor) <- c("Storage")
data <- cbind(data,data_stor)
data_melted <- melt(data, id=c("X1"))

#plot per hour
ggplot(data_melted,aes(x=X1,y=value,fill=variable)) + geom_bar(stat = "identity") +
  labs(title="Heat supplied per technology (hourly)",x="Hour", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())
ggsave(filename="Heat_output_per_technology.png",width=12,height=5)


#PLOT ELECTRICITY OUTPUT OF TECHNOLOGIES PER WEEK
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

data = read.xlsx("results_conversion.xlsx","Output_energy_Elec")
data_stor = read.xlsx("results_storage.xlsx","Storage_output_energy")
data_stor <- data.frame(data_stor$Elec)
colnames(data_stor) <- c("Storage")
data <- cbind(data,data_stor)
data <- cbind(t,data)
data_m <- melt(data, id=c('weeks','X1'))
data_summed <- sqldf('select weeks, variable, sum(value) as value from data_m group by weeks,variable order by weeks')
ggplot(data_summed,aes(x=weeks,y=value,fill=variable)) + geom_bar(stat = "identity") +
  labs(title="Electricity supplied per technology (weekly)",x="Week", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())
ggsave(filename="Electricity_supplied_per_technology_weekly.png",width=12,height=5)


#PLOT HEAT OUTPUT OF TECHNOLOGIES PER WEEK
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

data = read.xlsx("results_conversion.xlsx","Output_energy_Heat")
data_stor = read.xlsx("results_storage.xlsx","Storage_output_energy")
data_stor <- data.frame(data_stor$Heat)
colnames(data_stor) <- c("Storage")
data <- cbind(data,data_stor)
data <- cbind(t,data)
data_m <- melt(data, id=c('weeks','X1'))
data_summed <- sqldf('select weeks, variable, sum(value) as value from data_m group by weeks,variable order by weeks')
ggplot(data_summed,aes(x=weeks,y=value,fill=variable)) + geom_bar(stat = "identity") +
  labs(title="Heat supplied per technology (weekly)",x="Week", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())
ggsave(filename="Heat_supplied_per_technology_weekly.png",width=12,height=5)


#PLOT ANNUAL ELECTRICITY OUTPUT OF TECHNOLOGIES
data = read.xlsx("results_conversion.xlsx","Output_energy_Elec")
data_stor = read.xlsx("results_storage.xlsx","Storage_output_energy")
data_stor <- data.frame(data_stor$Elec)
colnames(data_stor) <- c("Storage")
data <- cbind(data,data_stor)
data_m <- melt(data, id=c("X1"))
data_summed <- sqldf('select variable, sum(value) as value from data_m group by variable')

blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

ggplot(data_summed, aes(x="", y=value, fill=variable)) + geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + 
  blank_theme + theme(axis.text.x=element_blank())  +
  labs(title="Total share of electricity supplied per technology") +
  theme(legend.title = element_blank())
ggsave(filename="Total_share_electricity_supplied_per_technology.png",width=12,height=5)


#PLOT ANNUAL HEAT OUTPUT OF TECHNOLOGIES
data = read.xlsx("results_conversion.xlsx","Output_energy_Heat")
data_stor = read.xlsx("results_storage.xlsx","Storage_output_energy")
data_stor <- data.frame(data_stor$Heat)
colnames(data_stor) <- c("Storage")
data <- cbind(data,data_stor)
data_m <- melt(data, id=c("X1"))
data_summed <- sqldf('select variable, sum(value) as value from data_m group by variable')

blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

ggplot(data_summed, aes(x="", y=value, fill=variable)) + geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + 
  blank_theme + theme(axis.text.x=element_blank())  +
  labs(title="Total share of heat supplied per technology") +
  theme(legend.title = element_blank())
ggsave(filename="Total_share_heat_supplied_per_technology.png",width=12,height=5)


#PLOT CARBON EMISSIONS PER TECHNOLOGY
data = read.xlsx("results_emissions.xlsx","Total_carbon_per_technology",colNames=FALSE)
total_emissions <- sum(data$X2)

blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

plot_title = paste('Breakdown of carbon emissions per technology \n Total emissions = ',round(total_emissions),' kg')
ggplot(data, aes(x="", y=X2, fill=X1)) + geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + 
  blank_theme + theme(axis.text.x=element_blank())  +
  labs(title=plot_title) +
  theme(legend.title = element_blank())
ggsave(filename="Carbon_emissions_per_technology.png",width=12,height=5)


#PLOT CARBON EMISSIONS PER HOUR
data = read.xlsx("results_emissions.xlsx","Total_carbon_per_timestep",colNames=FALSE)

#plot per hour
ggplot(data,aes(x=X1,y=X2)) + geom_bar(stat = "identity") +
  labs(title="Carbon emissions (hourly)",x="Hour", y="Emissions (kg CO2)")
ggsave(filename="Carbon_emissions_per_hour.png",width=12,height=5)


#PLOT COST BREAKDOWN PER TECHNOLOGY
data1 = read.xlsx("results_costs.xlsx","Total_cost_per_technology",colNames=FALSE)
data2 = read.xlsx("results_costs.xlsx","Total_cost_grid",colNames=FALSE)
data3 = read.xlsx("results_costs.xlsx","Total_cost_per_storage",colNames=FALSE)

data2b <- data.frame()
data2b[1,1] = 'Grid'
data2b[1,2] = data2[1,1]
colnames(data2b) <- c('X1','X2')
data <- rbind(data1,data2b,data3)
data <- sqldf('select X1, sum(X2) as X2 from data group by X1 order by X1')
total_cost <- sum(data$X2)

blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

plot_title = paste('Cost breakdown per technology \n Total cost = CHF ',round(total_cost))
ggplot(data, aes(x="", y=X2, fill=X1)) + geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + 
  blank_theme + theme(axis.text.x=element_blank())  +
  labs(title=plot_title) +
  theme(legend.title = element_blank())
ggsave(filename="Cost_per_technology.png",width=12,height=5)


#PLOT COST VS. INCOME
data1 = read.xlsx("results_costs.xlsx","Total_cost_per_technology",colNames=FALSE)
data2 = read.xlsx("results_costs.xlsx","Total_cost_grid",colNames=FALSE)
data3 = read.xlsx("results_costs.xlsx","Total_cost_per_storage",colNames=FALSE)
data4 = read.xlsx("results_costs.xlsx","Income_via_exports",colNames=FALSE)

total_cost = sum(data1$X2) + sum(data2$X1) + sum(data3$X2)
total_income = sum(data4$X1)

data <- data.frame(c(total_cost,total_income))
data[,2] <- c('Total_cost','Total_income')
colnames(data) <- c('value','variable')


blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

ggplot(data, aes(x="", y=value, fill=variable)) + geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) +
  geom_text(aes(y = value/3 + c(0, cumsum(value)[-length(value)]), label = round(value,digits=2)), size=6) +
  blank_theme + theme(axis.text.x=element_blank())  + 
  labs(title="Costs vs. income") +
  theme(legend.title = element_blank()) 
ggsave(filename="Total_cost_vs_income.png",width=12,height=5)
      

#PLOT TECHNOLOGY CAPACITIES
data = read.xlsx("results_capacities.xlsx","Capacity",colNames = FALSE, rowNames = FALSE)

ggplot(data,aes(x=X1,y=X2)) + geom_bar(stat = "identity") +
  labs(title="Output capacity of conversion technologies",x="Technology", y="Capacity (kW)", legend.title="Technology")
ggsave(filename="Output_capacity_of_technologies.png",width=12,height=5)


#PLOT STORAGE TECHNOLOGY CAPACITIES
data = read.xlsx("results_capacities.xlsx","Storage_capacity",colNames=FALSE)

ggplot(data,aes(x=X1,y=X2)) + geom_bar(stat = "identity") +
  labs(title="Capacity of storage technologies",x="Technology", y="Capacity (kWh)", legend.title="Storage technology")
ggsave(filename="Storage_capacity_of_technologies.png",width=12,height=5)
