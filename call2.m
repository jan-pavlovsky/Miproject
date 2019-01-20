close all;
clear all;
clc;

files = dir('./*.csv');
filenames = {};

for filename = files
    filenames = [filenames, filename.name];
end

ds = datastore(filenames,  'TreatAsMissing', 'NA');

ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'UniqueCarrier')} = '%s';
%ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'TailNum')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Origin')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Dest')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'CancellationCode')} = '%s';
%ds.SelectedVariableNames = {'CancellationCode', 'Cancelled', 'Origin'};

[totals, destinations, origins] = tarea2(ds);

totals = sortrows(totals, 2, 'descend');
destinations = sortrows(destinations, 2, 'descend');
origins = sortrows(origins, 3, 'descend');

writetable(totals, 'totalsByCount.xlsx');
writetable(destinations, 'destinationsByCount.xlsx');
writetable(origins, 'originsByCount.xlsx');

totals = sortrows(totals, 3, 'descend');
destinations = sortrows(destinations, 3, 'descend');
origins = sortrows(origins, 3, 'descend');

writetable(totals, 'totalsByPercentage.xlsx');
writetable(destinations, 'destinationsByPercentage.xlsx');
writetable(origins, 'originsByPercentage.xlsx');