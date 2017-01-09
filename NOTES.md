# TODO

## PRIORITY
X Add solar techs to Minimum_part_load parameter.
X Don't set min and max allowed grid capacity params when you're not sizing the grid. Why are you sizing the grid connection in the generic energy hub model?
X Create an option to ignore grid capacity constraints, which then gets rid of the grid capacity param, variable Capacity_grid, and the Grid_capacity_violation_constraint import and export.
X Dont create Storage_minimum_capacity_constraint when the min allowed capacities of all storages are zero
X Don't create min part load param and min part load constaints when min part load is zero.
X Don't create the Minimum_capacity_constraint when all conv have min capacity of zero
X Adjust and rename the CHP installation constraint -> remove installation from the equation (this is set by the installation param), and rename it the CHP capacity constraint.
X Add the enforce grid capacity variable in the test experiments and the price policy experiment
Test the test scripts to make sure the changes work there.

Check why you're getting the Aimms warnings.

Add your generic energy hub model to the model repository.

Automatic identification and setting of energy carriers based on technology and case study input files. Parameterize energy demands so you don't have to deal with heat, cooling, electricity, etc. separately in the code, but these are automatically set. This can be dealt with in the outputs the same way as multiple hubs are dealt with. Change the case study read-in code so you get the demand types from the input files and not manually. Energy outputs should be dealt with in the same way as multiple hubs, with automated printing routines that dynamically set the sheet names and variable names. This goes together with the CHP constraints -> CHP constraints should be more generic to deal with any type of technology with more than one type of input or output.  Probably you'll have to set the max inputs/outputs per tech to 2.

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
