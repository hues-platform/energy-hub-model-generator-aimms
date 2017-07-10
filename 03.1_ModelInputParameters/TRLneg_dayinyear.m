%prices capacity TRL-

clear all;
clc;
%daily capacity prices 2016 to be written per year
day=xlsread('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\Trl_Daily_NEG.csv','Trl_Daily_NEG','P5:P2536');
dayinyear=[];
j=1;
for i=1:length(day)
dayinyear(j)=day(i);
dayinyear(j+1)=day(i);
dayinyear(j+2)=day(i);
dayinyear(j+3)=day(i);
j=j+4;
end
dayinyear=dayinyear(:);

xlswrite('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\TRL-Day_Usable.xlsx',dayinyear,'UsableData');

%weekly capacity prices 2016 to be written per year
week=xlsread('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\TRLminus\Tertiary control power Weekly.csv','Tertiary control power Weekly','M5:M60');
weekinyear=[];
j=1;
 w=0;
for i=1:length(week) 
    for j=1:168 
 weekinyear(j+w*168)=week(i);
    end
 w=w+1;
end
weekinyear=weekinyear(:);
xlswrite('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\TRLminus\TRL-Week_Usable.xlsx',weekinyear,'UsableData');

%energy prices of 2016, in order to find the most frequent one
energy=xlsread('C:\Users\Raphaela\Dropbox\MASTER THESIS\from psl\EnergieUebersichtCH_2016.xls','Zeitreihen0h15','Y3:Y35134');
energy(find(energy==0))=[];
energy=energy/1000;
histogram(energy);
