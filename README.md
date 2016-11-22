#What is the EHM Generator?

The *Energy Hub Model (EHM) Generator* is a set of Matlab scripts for automating the creation of an energy hub model for a given case study and a given set of technologies.  

The EHM Generator takes as input case study data and technology data in defined formats and outputs an AMS file which can be executed in the optimization package Aimms.  The EHM Generator also includes optional code for executing the energy hub model and visualizing the results.

The purpose of the EHM Generator is:

1. To simplify and accellerate the process of developing energy hub models by automated code generation
2. To facilitate the incorporation of energy hub models into multi-model workflows, e.g. together with other modules in the HUES platform.

*Note: The EHM Generator is currently only in Beta release, as we continue to resolve remaining issues*

![EHM Generator diagram](/images/EHM_Generator_Diagram.png)

#What can the EHM Generator do?

The EHM Generator automates the creation of code for an energy hub model, which is outputted in the form of an Aimms AMS file. 

###The EHM Generator is capable of generating models for optimizing:

* The operation (dispatch of energy technologies) over a defined time horizon
* The selection and sizing of energy conversion and storage technologies 

###The EHM Generator is capable of generating models for systems with:

* Multiple energy carriers
* Multiple energy demands
* Multi-hub (thermal or electrical) networks

###Current limitations of the EHM Generator:

* Represented energy carriers/demands are currently limited to electricity, heat (space heating), domestic hot water, anergy and cooling
* Not yet able to generate models for optimizing selection, sizing or routing of thermal or electrical networks.

#How to use the EHM Generator

##1. Configure your system

Software requirements:

1. The EHM Generator requires MATLAB, and has been tested on MATLAB R2013b.  
2. Running the energy hub model created by the EHM generator requires the optimization package [Aimms](http://aimms.com/).  Aimms is available for free for academic use.
3. The EHM Generator has been tested on a Windows OS, but should also function with minimal changes on other systems as well. NOTE: The CSV inputs to the EHM Generator use comma-separated formatting. If your OS uses a semicolen as the default list separator, this will cause errors.  On Windows, this can be checked/changed at Control Panel -> Region and language -> Additional settings -> List separator (under the "Numbers" tab).

Download the EHM Generator from [Github](https://github.com/hues-platform/energy-hub-model-generator-aimms) (click the "Clone or download" button). Place the downloaded files in a convenient location in your system

##2. Define a case study

A *case study* refers to the building or district to be analyzed. In order to generate an energy hub model for a given case study, the data describing the case study must be provided in a specific format. 

To create a new case study, add a new directory to the "case_study_data" folder in the project's root directory, and name the directory according to the desired name of your case study.  In this folder, you must then create a set of appropriately named and formatted CSV files, including:

1. a file titled "demand_data.csv" containing energy demand time series for the case.
2. a file titled "energy_inputs_data.csv" containing energy inputs time series for the case (e.g. solar radiation)
3. a file titled "node_data.csv" containing data on the building(s) at the site (e.g. roof area)

In addition to these two files, a several additional files may be optionally created, depending on the properties of the case.  This includes:

4. a file titled "installed_conversion_technologies.csv" containing a description of energy conversion technologies already installed at the site.
5. a file titled "installed_storage_technologies.csv" containing a description of energy storage technologies already installed at the site.
6. a file titled "installed_network_technologies.csv" containing a description of network technologies already installed at the site.
7. a file titled "network_data.csv" containing a description of the network structure.

Each of these files must be formatted in a specific way, with specific properties defined on each row. See the section below "Formatting of case study input files" for further details. 

For an example of how to structure and format the case study files, see the "testing_case_single_hub" and "testing_case_multihub" folders in the "case_study_data" directory.

##3. Define the technologies to be included in the analysis

If you would like to optimize the selection and sizing of *energy conversion and storage technologies* for a given case, you must define the properties of the technologies to be considered. These should be defined in the "technology_data" directory in the root directory of the project.  

Descriptions of energy conversion and storage technologies should be defined in a "conversion_technology_data.csv" file and a "storage_technology_data.csv"file, respectively, which should be placed within this directory. These files must be formatted in a specific way, with specific properties defined on each row.  See the section below "Formatting of technology input files" for details on how to format these files.

For an example of how to structure and format these files, see the default "conversion_technology_data.csv" and "storage_technology_data.csv" files in this folder. Note: In the current version of the EHM Generator, it is not possible to generate models for optimizing the network technologies or topolocy.

If you would like to generate a model for only operational optimization of a given case, it is unnecessary to define these files.

##4. Create a scenario file

A *scenario file* indicates the case study to be analyzed and defines the parameters for a specific experiment to be carried out on that case study.  A scenario file takes the form of a Matlab m-file. The scenario file includes:
* Name of the scenario
* Name of the case study being analyzed
* The objective and type of optimization to be carried out
* The time horizon and resolution
* Electricity grid parameters
* Price parameters
* Carbon parameters
* Constraint options

Example scenario file: define_scenarios/test_single_hub_no_sizing/TestScenario_SingleHubNoSizing.m

To add a new scenario, create a new directory in the "define_scenarios" folder (give the directory any name you wish), and place the m-file defining the scenario parameters within this directory.  The directory may also contain any additional scenario-specific files not included in the "case_study_data" or "technology_data" directories.

##5. Run the EHM generator

Once you have defined the case study and technologies, and created a scenario file, you're ready to run the EHM Generator.  To set up a run, (1) open the "EHM_Generator.m" script in the root directory of the project, (2) set the correct system path to the root directory of the project and (3) change the scenario name as appropriate.  Then simply run the EHM_Generator.m script.  

The script will run for 1-3 minutes, then output a file called "energy_hub.ams", located in "aimms_model\energy_hub\MainProject". The EHM Generator will also output a set of input files for Aimms, based on the case study data provided.  These files will be located in "aimms_model\energy_hub", and will automatically be loaded and run by Aimms when the energy hub model is executed. 

#Running your energy hub model
There are two ways to run your energy hub model, manually and automatically:

1. To run the model manually, go to "aimms_model\energy_hub" and open the file "energy_hub.aimms".  This will open an Aimms session. To run the model, right-click the procedure "Main_execution" in the top pane on the left hand side of the Aimms window and select "Run procedure".
2. To run the model automatically, change the value of the variable "execute_energy_hub_model" to 1 in Main.m, and run Main.m.  If you've already generated the model, you can simply run the "Execute AIMMS Model" cell in Main.m.

Results will be printed to a set of XLSX files in the directory "aimms_model\energy_hub\results".


