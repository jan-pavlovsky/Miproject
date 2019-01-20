close all;
clear all;
clc;

files = dir('./*.csv');
filenames = {};

for filename = files
    filenames = [filenames, filename.name];
end

filenames = "2001m.csv";

ds = datastore(filenames,  'TreatAsMissing', 'NA');

ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'UniqueCarrier')} = '%s';
%ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'TailNum')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Origin')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Dest')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'CancellationCode')} = '%s';
%ds.SelectedVariableNames = {'CancellationCode', 'Cancelled', 'Origin'};

[totals, destinations, origins] = tarea2(ds);
%plot(countsByDay.Key, countsByDay.Value);
%legend({'Total count of flights by day'},'Location','northwest')