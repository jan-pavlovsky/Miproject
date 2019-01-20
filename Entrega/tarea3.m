close all;
clear all;
clc;

files = dir('./*.csv');
filenames = {};

for filename = files
    filenames = [filenames, filename.name];
end

%filenames = "2001m.csv";

ds = datastore(filenames,  'TreatAsMissing', 'NA');

ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'UniqueCarrier')} = '%s';
%ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'TailNum')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Origin')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Dest')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'CancellationCode')} = '%s';
%ds.SelectedVariableNames = {'CancellationCode', 'Cancelled', 'Origin'};


%[flightAvgNum flightAvgNumFest] = tarea3numeros(ds);
[countsByDay countsCancelledByDay] = tarea3numeros(ds);
figure;
plot(countsByDay.Key, countsByDay.Value);
hold on;
plot(countsCancelledByDay.Key, countsCancelledByDay.Value);
legend({'Total count of flights by day', 'Cancellations'},'Location','northwest')


%{
[cancelledStats, divertedStats] = tarea1parametros(ds);
figure;
plot(cancelledStats.Key, cancelledStats.Value, divertedStats.Key, divertedStats.Value);
legend({'cancelled flights by day','diverted flights by day'},'Location','northwest')
%}

[averageDepDelays, averageArrDelays] = tarea3retrasos(ds, countsByDay);
figure;
plot(averageDepDelays.Key, averageDepDelays.Value, averageArrDelays.Key, averageArrDelays.Value);
legend({'Average daily departure delay','Average daily arrival delay'},'Location','northwest')