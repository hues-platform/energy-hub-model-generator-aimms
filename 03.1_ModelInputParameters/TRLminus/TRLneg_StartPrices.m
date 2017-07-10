%prices capacity TRL-

clear all;
clc;

day=xlsread('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\TRLminus\TRLminDaily.xlsx','TRLmin','A1:A2193');
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

xlswrite('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\TRLminus\TRL-Day_UsableNEW.xlsx',dayinyear,'UsableData');

week=xlsread('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\Tertiary control power Weekly TRL-.csv','Tertiary control power Weekly T','A1:A56');
weekinyear=[];
j=1;
for i=1:length(week)
weekinyear(j)=week(i);
weekinyear(j+168)=week(i);

j=j+168;
end
weekinyear=weekinyear(:);
xlswrite('C:\Users\Raphaela\Dropbox\MASTER THESIS\Working on data\TRL-Week_Usable .xlsx',weekinyear,'UsableData');


