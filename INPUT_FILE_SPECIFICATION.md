#Formatting of input data files

The sections below describe in detail how the case study and technology input data files must be formatted.

##Formatting of case study input files

###demand_data.csv

_This file is required._

This file consists of energy demand time series for the system.  It should be structured according to the HUES data specification for time series data: https://hues.empa.ch/index.php/HUESdata_v1.0_Time_series_data_specification.

**Important note:** In row 3, use the keyword "Elec" (without quotes) to denote electricity demand. All other energy streams may be named freely by the user. 

**Example file:** case_study_data\generic_energy_hub_basic\case_data\demand_data.csv

###energy_inputs_data.csv

_This file is required._

This file consists of energy inputs time series, e.g. solar insolation values.  It should be structured according to the HUES data specification for time series data: https://hues.empa.ch/index.php/HUESdata_v1.0_Time_series_data_specification.

**Important note:** In row 3, use the keyword "Solar" (without quotes) to denote solar energy inputs.

**Example file:** case_study_data\generic_energy_hub_basic\case_data\energy_inputs_data.csv

###node_data.csv

_This file is required._

This file consists of basic data about the nodes (e.g. buildings) in the system, e.g. roof area.  It should be structured as follows:

Row 1: Node ID (required)

Row 2: Node name (optional)

Row 3: Usable roof area (required if installation/sizing of solar technologies is to be considered)

**Example file:** case_study_data\generic_energy_hub_basic\case_data\node_data.csv

###installed_conversion_technologies.csv

_This file is required if the system includes pre-installed conversion technologies._

This file consits of data describing the installed energy conversion technologies.  It is necessary if the system has pre-installed technologies, or if you are doing only an optimization of system operation.  The file should be structured as follows:

Row 1: Technology name (required)

Row 2: Output type 1 (required)

Row 3: Output type 2 (optional, leave blank if only a single output type)

Row 4: Input type 1 (required, see important note below)

Row 5: Input type 2 (optional, leave blank if only a single input type)

Row 6: Efficiency (required)

Row 7: Minimum part load (required)

Row 8: Output ratio (optional, refers to the ratio of output 2 to output 1, set to zero if only a single output)

Row 9: Input ratio (optional, refers to the ratio of input 2 to input 1, set to zero if only a single input)

Row 10: Capacity (required)

Row 11: Node (required, set to 1 if the system has only a single node)

**Important note:** Output ratio refers to the ratio of Output 2 to Output 1. Input ratio refers to the ratio of Input 2 to Input 1. 

**Important note:** The values for efficiency and capacity are defined with respect to Output 1.  

**Important note:** To implement a CHP unit, set Output type 1 to "Elec" and Output type 2 to "Heat" (or whatever your heat stream is named). Then set the Output ratio to the heat-to-power ratio of the unit. The values for Efficiency and Capacity are defined with respect to the first output, in this case "Elec".  

**Important note:** For a heat pump, set Input type 1 to "Elec" and Input type 2 to the name of your low-temperature heat stream.  The Input ratio is the ratio of Input type 2 to Input type 1. The efficiency should be set to the value of the unit's CoP.

**Important note:** The electricity grid connection should not be included in this file.  The properties of the electricity grid connection should be defined in the SetExperimentParameters.m file.

**Example file:** case_study_data\generic_energy_hub_basic\case_data\installed_conversion_technologies.csv

###installed_storage_technologies.csv

_This file is required if the system includes pre-installed storage technologies._

This file consists of data describing the installed energy storage technologies.  It should be structured as follows:

Row 1: Technology name (required)

Row 2: Type of energy stored (required)

Row 3: Charging efficiency (required)

Row 4: Discharging efficiency (required)

Row 5: Decay (required)

Row 6: Maximum charging rate (required)

Row 7: Maximum discharging rate (required)

Row 8: Minimum state of charge (required)

Row 9: Minimum temperature (thermal storage) (optional, leave blank if unused)

Row 10: Maximum temperature (thermal storage) (optional, leave blank if unused)

Row 11: Specific heat (thermal storage) (optional, leave blank if unused)

Row 12: Capacity (required)

Row 13: Node (required)

**Important note:** The model functionalities associated with Minimum temperature, Maximum Temperature and Specific heat are still experimental, and not fully implemented,  It is currently recommended not to use these.

**Example file:** case_study_data\generic_energy_hub_basic\case_data\installed_storage_technologies.csv

##network_data.csv

_This file is required if the system includes a pre-installed network (e.g. thermal network, microgrid)._

This file consists of data describing the structure of the installed network.  It should be structured as follows:

Row 1: Link ID (required)

Row 2: Node 1 (required)

Row 3: Node 2 (required)

Row 4: Length (m) (required)

**Example file:** case_study_data\testing_case_multihub\case_data\network_data.csv

###installed_network_technologies.csv

_This file is required if the system includes a pre-installed network (e.g. thermal network, microgrid)._

This file consists of data describing the installed network link technologies, e.g. thermal pipes.  It should be structured as follows:

Row 1: Technology name (required)

Row 2: Energy type (required; possible values limited to: Heat, Elec, Cool, DHW and Anergy)

Row 3: Capacity (required)

Row 3: Losses (fraction per m) (required)

Row 4: Link ID (required)

**Example file:** case_study_data\testing_case_multihub\case_data\installed_network_technologies.csv


##Formatting of technology input files

###conversion_technology_data.csv

_This file is required if the selection and sizing of energy conversion technologies should be considered._

This file consists of data describing the energy conversion technologies that are being considered for selection and sizing. The file should be formatted as follows:

Row 1: Technology name (required)

Row 2: Output type 1 (required)

Row 3: Output type 2 (optional, leave blank if only a single output type)

Row 4: Input type 1 (required)

Row 5: Input type 2 (optional, leave blank if only a single input type)

Row 6: Lifetime (required)

Row 7: Capital cost per kW (required)

Row 8: Capital cost fixed (required)

Row 9: OM cost per kWh (required)

Row 10: OM cost fixed (required)

Row 11: Efficiency (required)

Row 12: Minimum part load (required)

Row 13: Output ratio (optional, refers to the ratio of output 2 to output 1, set to zero if only a single output)

Row 14: Input ratio (optional, refers to the ratio of input 2 to input 1, set to zero if only a single input)

Row 15: Minimum capacity (required)

Row 16: Maximum capacity (required)

**Important note:** Output ratio refers to the ratio of Output 2 to Output 1. Input ratio refers to the ratio of Input 2 to Input 1. 

**Important note:** The values for efficiency and capacity are defined with respect to Output 1.  

**Important note:** To implement a CHP unit, set Output type 1 to "Elec" and Output type 2 to "Heat" (or whatever your heat stream is named). Then set the Output ratio to the heat-to-power ratio of the unit. The values for Efficiency and Capacity are defined with respect to the first output, in this case "Elec".  

**Important note:** For a heat pump, set Input type 1 to "Elec" and Input type 2 to the name of your low-temperature heat stream.  The Input ratio is the ratio of Input type 2 to Input type 1. The efficiency should be set to the value of the unit's CoP.

**Important note:** The electricity grid connection should not be included in this file.  The properties of the electricity grid connection should be defined in the SetExperimentParameters.m file.

**Example file:** case_study_data\generic_energy_hub_basic\case_data\conversion_technology_data.csv

###storage_technology_data.csv

_This file is required if the selection and sizing of energy storage technologies should be considered._

This file consists of data describing the energy storage technologies that are being considered for selection and sizing. The file should be formatted as follows:

Row 1: Technology name (required)

Row 2: Type of energy stored (required)

Row 3: Lifetime (required)

Row 4: Capital cost per kWh (required)

Row 5: Capital cost fixed (required)

Row 6: Charging efficiency (required)

Row 7: Discharging efficiency (required)

Row 8: Decay (required)

Row 9: Maximum charging rate (required)

Row 10: Maximum discharging rate (required)

Row 11: Minimum state of charge (required)

Row 12: Minimum capacity (required)

Row 13: Maximum capacity (required)

Row 14: Minimum temperature (thermal storage) (optional, leave blank if inapplicable)

Row 15: Maximum temperature (thermal storage) (optional, leave blank if inapplicable)

Row 16: Specific heat (thermal storage) (optional, leave blank if inapplicable)

**Example file:** case_study_data\generic_energy_hub_basic\case_data\storage_technology_data.csv


