%% GENERATE CONSTRAINTS FOR AMS FILE

constraints_section = '';
header_section = '\n\tDeclarationSection Constraints {';

GenerateConversionTechnologyConstraints
GenerateStorageTechnologyConstraints
GenerateStorageTechnologyInitializationConstraints
GenerateNetworkConstraints
GenerateOtherConstraints

footer_section = '\n\t}';

constraints_section = strcat(header_section,constraints_section,footer_section);
