#What is the Ehub Modeling Tool?

The *Energy Hub (Ehub) Modeling Tool* is a set of Matlab scripts for creating, executing and visualizing the results of an energy hub model for a given case study and a set of technologies.  

The Ehub Modeling Tool takes as input case study data and technology data in defined formats and outputs an AMS file which is executed in the optimization package Aimms.  The Ehub Modeling Tool also includes R code for visualizing the results of the energy hub model.

The purpose of the Ehub Modeling Tool is:

1. To facilitate computational experiments for optimizing the design and operation of multi-energy systems under different conditions.
2. To simplify and accelerate the process of developing energy hub models via automated code generation.
3. To facilitate the incorporation of energy hub models into multi-model workflows.

*Note: The Ehub Modeling Tool is currently only in Beta release, as we continue to resolve remaining issues*

![Ehub Modeling Tool diagram](/images/Ehub_Modeling_Tool_Diagram.png)

#What can the Ehub Modeling Tool do?

The Ehub Modeling Tool automates the creation of code for an energy hub model formulated as a mixed-integer linear programme, which is outputted in the form of an Aimms AMS file. The outputted AMS file is then automatically executed in the optimization package Aimms, and the results are printed to a set of XLSX files.  These files may then be read by a visualization script (implemented in R), which outputs a series of PNG files summarizing the results of a given experiment.

###The Ehub Modeling Tool is capable of optimizing:

* The operation (dispatch of energy technologies) over a defined time horizon
* The selection and sizing of energy conversion and storage technologies 

###The Ehub Modeling Tool is capable of optimizing systems with:

* Multiple energy carriers
* Multiple energy demands
* Multi-hub (thermal or electrical) networks

###Current limitations of the Ehub Modeling Tool:

* Part-load efficiencies are not yet enabled
* Not yet able to generate models for optimizing selection, sizing or routing of thermal or electrical networks.
* Visualization code is still a bit buggy  and is currently limited to analyzing single-node systems (optimization of multi-node systems is possible).

#How to use the Ehub Modeling Tool

##1. Configure your system

Software requirements:

1. The Ehub Modeling Tool requires MATLAB, and has been tested on MATLAB R2013b.  
2. Running the energy hub model created by the Ehub Modeling Tool requires the optimization package [Aimms](http://aimms.com/).  Aimms is available for free for academic use.
3. Visualization of results is executed via an R Script, and uses the R packages openxlsx, ggplot2, sqldf and reshape2. R can be downloaded for free from https://www.r-project.org/.
4. The Ehub Modeling Tool has been tested on a Windows OS, but should also function with minimal changes on other systems as well. _NOTE: The CSV inputs to the Ehub Modeling Tool use comma-separated formatting. If your OS uses a semicolen as the default list separator, this will cause errors.  On Windows, this can be checked/changed at Control Panel -> Region and language -> Additional settings -> List separator (under the "Numbers" tab)._

Download the Ehub Modeling Tool from [Github](https://github.com/hues-platform/ehub_modeling_tool) (click the "Clone or download" button). Place the downloaded files in a convenient location in your system.

##2. Create an experiment folder

An *experiment folder* contains all the files necessary to set up experiments for execution with the Ehub Modeling Tool. To create a new experiment, create a new directory in the "experiments" folder in the project's root directory, and name the directory according to the desired name of your experiment. In this directory, you should create two sub-directories. One of these should be named "case_data" and the other should be named "technology_data".  You should also create two new Matlab scripts (M files).  These should be named "SetupExperiments.m" and "SetExperimentalParameters.m".  For an example of how to set up an experiment, see the "generic energy hub basic" experiment, which can be found in: experiments/generic_energy_hub_basic/.

##3. Create a case study

A *case study* refers to the building or district to be analyzed. In order to generate an energy hub model for a given case study, the data describing the case study must be provided in a specific format. 

To create a new case study, add a new directory to the "case_study" folder in your newly created experiment folder.  In this folder, you must then create a set of appropriately named and formatted CSV files, including:

1. a file titled "demand_data.csv" containing energy demand time series for the case.
2. a file titled "energy_inputs_data.csv" containing energy inputs time series for the case (e.g. solar radiation)
3. a file titled "node_data.csv" containing data on the building(s) at the site (e.g. roof area)

In addition to these two files, several additional files may be optionally created, depending on the properties of the case.  This includes:

4. a file titled "installed_conversion_technologies.csv" containing a description of energy conversion technologies already installed at the site.
5. a file titled "installed_storage_technologies.csv" containing a description of energy storage technologies already installed at the site.
6. a file titled "installed_network_technologies.csv" containing a description of network technologies already installed at the site.
7. a file titled "network_data.csv" containing a description of the network structure.

Each of these files must be formatted in a specific way, with specific properties defined on each row. See the [INPUT_FILE_SPECIFICATION](INPUT_FILE_SPECIFICATION.md) for further details. 

For an example of how to structure and format the case study files, see experiments/generic_energy_hub_basic/case_data.

##4. Define the technologies to be included in the analysis

If you would like to optimize the selection and sizing of *energy conversion and storage technologies* for a given case, you must define the properties of the technologies to be considered. These should be defined in the "technology_data" directory in your newly created experiment folder.  

Descriptions of energy conversion and storage technologies should be defined in a "conversion_technology_data.csv" file and a "storage_technology_data.csv"file, respectively, which should be placed within this directory. These files must be formatted in a specific way, with specific properties defined on each row.  See the [INPUT_FILE_SPECIFICATION](INPUT_FILE_SPECIFICATION.md) for details on how to format these files.

For an example of how to structure and format these files, see the default "conversion_technology_data.csv" and "storage_technology_data.csv" files in experiments/generic_energy_hub_basic/technology_data/. Note: In the current version of the Ehub Modeling Tool, it is not possible to generate models for optimizing the network technologies or topology.

If you would like to generate a model for only operational optimization of a given case, it is unnecessary to define these files.

##5. Set up your experiments

To set up your experiments, you need to create two files in the newly created experiment folder: "SetupExperiments.m" and "SetExperimentalParameters.m". In "SetExperimentalParameters.m", the values of various parameters are set, which may be given fixed values, or varied in the course of a parametric study.  These parameters include, amongst others:
* The objective and type of optimization to be carried out
* The time horizon and resolution
* Electricity grid parameters
* Price parameters
* Carbon parameters
* Constraint options

See experiments/generic_energy_hub_basic/SetExperimentalParameters.m for an example and further explanation of how to set up this file.

"SetupExperiments.m" contains code for defining how the different parameters set in "SetExperimentalParameters.m" should be varied in the course of your experiments. Your experiments may be executed simply by running this file, which calls both "SetExperimentalParameters.m" and the file "RunExperiment.m" (in src/run_experiment). See experiments/generic_energy_hub_basic/SetupExperiments.m for an example and further explanation of how to set up this file.

Example scenario file: define_scenarios/test_single_hub_no_sizing/TestScenario_SingleHubNoSizing.m

To add a new scenario, create a new directory in the "define_scenarios" folder (give the directory any name you wish), and place the m-file defining the scenario parameters within this directory.  The directory may also contain any additional scenario-specific files not included in the "case_study_data" or "technology_data" directories.

##6. Run your experiments

Once you have defined the case study and technologies, and created a scenario file, you're ready to run your experiments.  To set up a run, simply run the file "SetupExperiments.m" in your experiment folder. 

For each of the experiments you defined, the Ehub Modeling Tool will output a file called "energy_hub.ams", located in "aimms_model\energy_hub\MainProject". The Ehub Modeling Tool will also output a set of input files for Aimms, based on the case study data provided.  These files will be located in "aimms_model\energy_hub", and will automatically be loaded and run by Aimms when the energy hub model is executed. 

There are two ways to run your experiments, manually and automatically:

1. *Running your experiments manually*: This is primarily useful for debugging purposes, or when you aren't sure whether your model will execute properly in Aimms.  To run the model manually, set the variable "execute_energy_hub_model" at the bottom of your "SetExperimentParameters.m" file to 0, and execute "SetupExperiments.m".  The Ehub Modeling Tool will generate an AMS file and the necessary supporting files, but will not actually run the energy hub model code.  To manually run the model, go to "aimms_model\energy_hub" and open the file "energy_hub.aimms".  This will open an Aimms session. To run the model, right-click the procedure "Main_execution" in the top pane on the left hand side of the Aimms window and select "Run procedure".  When running your experiments manually, you will have to execute each experiment individually.
2. *Running your experiments automatically*: To run your experiments automatically, change the value of the variable "execute_energy_hub_model" at the bottom of your "SetExperimentParameters.m" file to 1, and execute "SetupExperiments.m".

In both of these cases, the results from your experiments will be printed to a set of XLSX files in the directories "aimms_model\energy_hub\results\<experiment-name>\".

##7. Visualize your results

*NOTE: The visualization script is no longer up-to-date and will not work properly in most cases.*

The R script for visualizing the results of your experiments can be found in the "analysis_scripts" folder of the project's root directory.  Open this script (VisualizationScript_SingleHub.R) in your R editor (RStudio is recommended), and set the working directory and experiment names. The working directory corresponds to the directory where your results are stored (aimms_model\energy_hub\results), and the experiment names to the names of your experiments as defined in "SetupExperiments.m". Then simply execute the script.  For the visualization script to execute properly, the R packages openxlsx, ggplot2, sqldf and reshape2 are required.  These can be installed via the install.packages() command.

The script will output a number of PNG files visualizing the results of your experiments.  These include visualizations of:
* Energy output capacities of conversion and storage technologies
* Cumulative costs per technology and income from electricity exports to the grid
* Cumulative CO2 emissions per technology
* Cumulative and weekly production values per technology

In its current form, the visualization script has a number of limitations, and may not work properly in some cases.  These limitations are listed on the top lines of "VisualizationScript_SingleHub.R". The file has been constructed to be easily extensible and editable, and may be adapted to suit different needs.  Some knowledge of R is necessary for this.
