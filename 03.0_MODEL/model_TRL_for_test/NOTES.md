# TODO

## PRIORITY

* Based on the current setup, the storage cannot charge/discharge from the grid.  This should possibly be changed. Add electricity export storage constraint or similar.

* Min and max capacity of solar techs should not be set, or you should take away the setting of this in the node csv.

* Debug and verify the model after your changes, and modify the test scripts accordingly.

* You can't actually calculate temperature levels without taking into account massflows.  How are you accounting for this now?

* Add to documentation the following notes:
NOTE: By convention, electricity has to be called "Elec" in the input files, solar "Solar", and natural gas "Gas"
NOTE: By convention, each hub in the input files has to have all the demands listed, and the hubs should be ordered chronologically across the columns.

* Merge (???) with main branch

## MULTI-HUB IMPROVEMENTS
Implement possibility to optimize the size and structure of a network

Right now, you're not able to effectively model microgrids, because the connection with the external grid is from every node individually. Change the formulation so energy is exported from a specific node, rather than from all nodes simultaneously. This node will have to be specified in the input files.

Improve the manner in which network results are printed - right now it's just one link per sheet, which is annoying.

Create visualization code for multi-hub analyses

## OTHER
Check why you're getting the Aimms warnings.

Add your generic energy hub model to the model repository.

Add some further documentation of the code structure.

Improve visualization code for single hub analyses.

Adding custom constraints. How can this be done?

It's assumed that operating costs and emissions can be incurred only by the first input for gas, but this may not necessarily be the case. They could also be incurred by a second input.

Implement different ways for dealing with time, e.g. full year, typical days, rolling horizon, receding horizon, which can then be implemented for any model.

Add on/off constraint for certain conversion technologies

When printing, you need to automatically change the last 3 AIMMS variables depending on the size of the table.

Output basic data of model in text file for reading into visualization module

It should be possible to install multiple identical technologies in a single hub.  This should simply involve having a variable for the number of technologies of a given type that are installed.  This can probably be the "installation" variable, which then should be a positive integer and not binary (you'll have to check if this screws anything up).  You probably also need an "Installation" parameter in this case, for situations in which the installed technologies are set. Somehow it should also be possible that you can install multiple technologies of the same type with different capacities within a single hub.

Create automatic testing scripts to automatically verify the code after changes are made.

## FUTURE POSSIBILITIES
Evaluation of the fulfillment of a district of the 2000W Areal label

Use standard (e.g. SIA) values as default when no data is available/inputted

Integrate cost curves for technologies

Integrate grey energy data for technologies into CO2/GHG calculations

Look at Julien's Matlab /Python code for generating/altering AMS files using Matlab, and also for altering the fundamental elements of Aimms (e.g. optimality gap), which he does in C# code executed via Matlab.

Implement possibility for multiple grid connection nodes

## AUTOMATIC SETTING OF ENERGY CARRIERS
based on the demand inputs, identify the demand types
based on the technology outputs in the technology and case inputs files, identify the relevant carriers

Technology and case study input files:
X Change output type row to two rows, output type 1 and output type 2
X Change heat to power ratio row to ratio of output type 2 to 1. Note that input capacity and efficiency are wrt output type 1.
X You might need to add a row for type of storage, with the options thermal or electrical (additional types could be added later, e.g. hydrogen). This may be necessary, but I'm not sure actually.

SetExperimentParameters.m
X It should only be possible to set one way of initializing storages, not different ones for different energy carriers. Change the variables accordingly.

LoadCaseData.m: 
X Code for cleaning up of input files has to be adjusted -> just delete all the xlsx files in that folder, or put these in a new folder and just delete the contents each time, maybe that's easier.
X Create a loop to iterate through the demand types and create the necessary input files. The consider_cooling_demand, etc. variables may not be necessary anymore.
X Adjust the code for reading in the technology params from the case study file to reflect the modified structure of the installed technologies file

LoadTechnologyData.m
X Change the code for getting a unique list of the energy outputs
X Remove the variables at the bottom that require stating specific energy carriers/demands.
X Adjust the code for reading in the technology params from the technology file to reflect the modified structure of the technologies file, also adjust this elsewhere in LoadTechnologyData.m.

SelectConstraints.m
X Remove the constraints for storage initialization for all energy carriers and reduce to a single set of constraints that apply to all storages.
X Replace the constraints having to do with CHP with modified ones as appropriate

SelectSetsParamsAndVariables.m
X Replace energy output variables with a generic one.
X Modify the code for selecting a form of storage representation. -> still need to complete this for multi-hub case

GenerateConversionTechnologyParams.m
X Adjust code for Linear_capital_costs param -> just print output type 1 instead of iterating through the different output types.
X Do the same with code for Fixed_capital_costs param
X Adjust the code for C_matrix param. This should make it much simpler actually.
X Adjust the code for Capacity param
X Adjust the code for Minimum part load param.

GenerateStorageTechnologyParams.m
X Adjust the S matrix param code.
X Adjust the storage capacity param code, in both places.

GenerateConversionTechnologyVariables.m
X Change the Output_energy_electricity, etc. variables. Create a loop to iterate through the different carriers.

GenerateConversionTechnologyConstraints.m
X Change the Minimum_capacity_constraint and Maximum_capacity_constraint -> the way you exclude CHPs won't work anymore.
X Change the Roof_area_constraint -> the way you determine the relevant solar technologies won't work anymore.  You'll have to iterate differently.
X Add roof area and min/max capacity constraints for multi-output techs. First check if you can integrate them into the existing constraint formulations.
X Modify Electricity_export_solar_constraint and Electricity_export_nonsolar_constraint, also the one with net metering
X Change your CHP_HTP_constraints 1&2, probably to iteratre through them automatically.
X Create a constraint for the input ratios
X CHP capacity constraint can just be integrated with the normal capacity constraint now.

GenerateStorageTechnologyInitializationConstraints.m
X Modify all of the constraints in this file

GenerateDataInputsProcedure.m
X Create loop for generating the RetrieveParameter commands for energy demands.

GenerateDataOutputsProcedure.m
X Adjust the commands for printing output energy of different types, for both single and multi-hub situations.

GenerateMainExecutionProcedure.m
X Adjust the relaxation strings as necessary.  Are these necessary at all?



