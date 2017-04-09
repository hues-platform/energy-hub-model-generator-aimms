
library(openxlsx)
library(reshape)
library(ggplot2)

setwd("C://Users//boa//Documents//Repositories_Github//energy-hub-model-generator-aimms//analysis_scripts//hslu_lecture//Exercise_1")
data = read.xlsx("results_conversion.xlsx","Output_energy_Elec")
data_stor = read.xlsx("results_storage.xlsx","Storage_output_energy")
data_stor <- data.frame(data_stor$Heat)
colnames(data_stor) <- c("Storage")
data <- cbind(data,data_stor)
data_melted <- melt(data, id=c("X1"))

#plot per hour
ggplot(data_melted,aes(x=X1,y=value,fill=variable)) + geom_bar(stat = "identity") +
  labs(title="Heat supplied per technology (hourly)",x="Hour", y="Energy supplied (kWh)") +
  theme(legend.title = element_blank())