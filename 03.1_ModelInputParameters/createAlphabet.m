clear all;
clc;
l={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
combA={};
combB={};
for i =1:length(l)

    combA(i)= strcat(l(1),l(i)) ;
    combB(i)= strcat(l(2),l(i)) ;
    combC(i)= strcat(l(3),l(i)) ;
    combD(i)= strcat(l(4),l(i)) ;
end

alphabet=[l(:); combA(:); combB(:); combC(:); combD(:)];

xlswrite('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\ALPHABET.xlsx',alphabet,'ALPHABET');
clear Excel;