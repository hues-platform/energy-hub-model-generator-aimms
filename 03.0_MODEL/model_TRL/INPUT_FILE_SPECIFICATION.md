#Formatting of input data files

The sections below describe in detail how the case study and technology input data files must be formatted.

##Formatting of case study input files

###demand_data.csv

_This file is required._

This file consists of energy demand time series for the system.  It should be structured according to the HUES data specification for time series data: https://hues.empa.ch/index.php/HUESdata_v1.0_Time_series_data_specification.

Important note: Possible values for demand type (row 3) are currently limited to: Elec, Heat Cool, DHW and Anergy.  The value Heat may be used to represent space heating demand.

Example file: case_study_data\testing_case_single_hub\demand_data.csv

###energy_inputs_data.csv

_This file is required._

This file consists of energy inputs time series, e.g. solar insolation values.  It should be structured according to the HUES data specification for time series data: https://hues.empa.ch/index.php/HUESdata_v1.0_Time_series_data_specification.

Important note: Possible values for supply type (row 3) are currently limited to: Solar.  

Example file: case_study_data\testing_case_single_hub\energy_inputs_data.csv

###node_data.csv

_This file is required._

This file consists of basic data about the nodes (e.g. buildings) in the system, e.g. roof area.  It should be structured as follows:

Row 1: Node ID (required)

Row 2: Node name (optional)

Row 3: Usable roof area (required if installation/sizing of solar technologies is to be considered)

Example file: case_study_data\testing_case_single_hub\node_data.csv

###installed_conversion_technologies.csv

_This file is required if the system includes pre-installed conversion technologies._

This file consits of data describing the installed energy conversion technologies.  It should be structured as follows:

Row 1: Technology name (required)

Row 2: Output type (required, see important note below)

Row 3: Input type (required, see important note below)

Row 4: Efficiency (required)

Row 5: Minimum part load (required)

Row 6: Heat to power ratio (optional, set to zero if inapplicable)

Row 7: Capacity (required)

Row 8: Node (required)

Important note: The values of rows 2 are limited to Heat, Elec, Cool, DHW and Anergy. For technologies with multiple outputs, enclose a comma-separated list of the outputs in double quotes (e.g. "Heat,Elec"). For technologies with multiple outputs, the possible values are currently limited to "Heat,Elec","DHW,Elec" and "Anergy,Elec"

Important note: For row 3, in case of multiple inputs for a single technology, enclose a comma-separated list of the inputs in double quotes (e.g. "Anergy,Elec").

Important note: The electricity grid connection should not be included in this file.  The properties of the electricity grid connection should be defined in the scenario file.

Example file: case_study_data\testing_case_single_hub\installed_conversion_technologies.csv

###installed_storage_technologies.csv

_This file is required if the system includes pre-installed storage technologies._

This file consists of data describing the installed energy storage technologies.  It should be structured as follows:

Row 1: Technology name (required)

Row 2: Type of energy stored (required, see important note below)

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

Important note: The values of rows 2 are limited to Heat, Elec, Cool, DHW and Anergy.

Example file: case_study_data\testing_case_single_hub\installed_storage_technologies.csv

##network_data.csv

_This file is required if the system includes a pre-installed network (e.g. thermal network, microgrid)._

This file consists of data describing the structure of the installed network.  It should be structured as follows:

Row 1: Link ID (required)

Row 2: Node 1 (required)

Row 3: Node 2 (required)

Row 4: Length (m) (required)

Example file: case_study_data\testing_case_multihub\network_data.csv

###installed_network_technologies.csv

_This file is required if the system includes a pre-installed network (e.g. thermal network, microgrid)._

This file consists of data describing the installed network link technologies, e.g. thermal pipes.  It should be structured as follows:

Row 1: Technology name (required)

Row 2: Energy type (required; possible values limited to: Heat, Elec, Cool, DHW and Anergy)

Row 3: Capacity (required)

Row 3: Losses (fraction per m) (required)

Row 4: Link ID (required)

Example file: case_study_data\testing_case_multihub\installed_network_technologies.csv


##Formatting of technology input files

###conversion_technology_data.csv

_This file is required if the selection and sizing of energy conversion technologies should be considered._

This file consists of data describing the energy conversion technologies that are being considered for selection and sizing. The file should be formatted as follows:

Row 1: Technology name (required)

Row 2: Output type (required, see important note below)

Row 3: Input type (required, see important note below)

Row 4: Lifetime (required)

Row 5: Capital cost per kW (required)

Row 6: Capital cost fixed (required)

Row 7: OM cost per kWh (required)

Row 8: OM cost fixed (required)

Row 9: Efficiency (required)

Row 10: Minimum part load (required)

Row 11: Heat to power ratio (optional, set to zero if inapplicable)

Row 12: Minimum capacity (required)

Row 13: Maximum capacity (required)

Important note: The values of rows 2 are limited to Heat, Elec, Cool, DHW and Anergy. For technologies with multiple outputs, enclose a comma-separated list of the outputs in double quotes (e.g. "Heat,Elec"). For technologies with multiple outputs, the possible values are currently limited to "Heat,Elec","DHW,Elec" and "Anergy,Elec"

Important note: For row 3, in case of multiple inputs for a single technology, enclose a comma-separated list of the inputs in double quotes (e.g. "Anergy,Elec").

Important note: The electricity grid connection should not be included in this file.  The properties of the electricity grid connection should be defined in the scenario file.  

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


