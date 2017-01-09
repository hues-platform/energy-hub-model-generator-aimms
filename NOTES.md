# TODO

## PRIORITY
Check why you're getting the Aimms warnings.

Add your generic energy hub model to the model repository.

Automatic identification and setting of energy carriers based on technology and case study input files. SEE NOTES BELOW FOR SPECIFIC TASKS TO DO THIS. Parameterize energy demands so you don't have to deal with heat, cooling, electricity, etc. separately in the code, but these are automatically set. This can be dealt with in the outputs the same way as multiple hubs are dealt with. Change the case study read-in code so you get the demand types from the input files and not manually. Energy outputs should be dealt with in the same way as multiple hubs, with automated printing routines that dynamically set the sheet names and variable names. This goes together with the CHP constraints -> CHP constraints should be more generic to deal with any type of technology with more than one type of input or output.  Probably you'll have to set the max inputs/outputs per tech to 2.

Add some further documentation of the code structure.

Improve visualization code for single hub analyses.

Adding custom constraints. How can this be done?

## MULTI-HUB IMPROVEMENTS
Implement possibility to optimize the size and structure of a network

Right now, you're not able to effectively model microgrids, because the connection with the external grid is from every node individually. Change the formulation so energy is exported from a specific node, rather than from all nodes simultaneously. This node will have to be specified in the input files.

Improve the manner in which network results are printed - right now it's just one link per sheet, which is annoying.

Create visualization code for multi-hub analyses

## OTHER
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
Change output type row to two rows, output type 1 and output type 2
Change heat to power ratio row to ratio of output type 2 to 1. Note that input capacity and efficiency are wrt output type 1.
You might need to add a row for type of storage, with the options thermal or electrical (additional types could be added later, e.g. hydrogen). This may be necessary, but I'm not sure actually.

SetExperimentParameters.m
It should only be possible to set one way of initializing storages, not different ones for different energy carriers. Change the variables accordingly.

LoadCaseData.m: 
Code for cleaning up of input files has to be adjusted -> just delete all the xlsx files in that folder, or put these in a new folder and just delete the contents each time, maybe that's easier.
Create a loop to iterate through the demand types and create the necessary input files. The consider_cooling_demand, etc. variables may not be necessary anymore.
Adjust the code for reading in the technology params from the case study file to reflect the modified structure of the installed technologies file

LoadTechnologyData.m
Note: By convention, electricity has to be called "Elec" in the input files, solar "Solar", and natural gas "Gas"
Change the code for getting a unique list of the energy outputs
Remove the variables at the bottom that require stating specific energy carriers/demands.
Adjust the code for reading in the technology params from the technology file to reflect the modified structure of the technologies file, also adjust this elsewhere in LoadTechnologyData.m.

SelectConstraints.m
Remove the constraints for storage initialization for all energy carriers and reduce to a single set of constraints that apply to all storages.
Replace the constraints having to do with CHP with modified ones as appropriate

SelectSetsParamsAndVariables.m
Replace energy output variables with a generic one.
Modify the code for selecting a form of storage representation.

GenerateConversionTechnologyParams.m
Adjust code for Linear_capital_costs param -> just print output type 1 instead of iterating through the different output types.
Do the same with code for Fixed_capital_costs param
Adjust the code for C_matrix param. This should make it much simpler actually.
Adjust the code for Capacity param
Adjust the code for Minimum part load param.

GenerateStorageTechnologyParams.m
Adjust the S matrix param code.
Adjust the storage capacity param code, in both places.


