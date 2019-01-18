close all;clear all;clc;

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



res = mapreduce(ds, @plotMapper, @plotReducer);

table = readall(res);
table = sortrows(table);
table.Key = datetime(table.Key, 'InputFormat', 'yyyyMMdd');
table.Value = cell2mat(table.Value);

plot(table.Key, table.Value);

function plotMapper (data, info, intermKVStore)
    dts = datetime(data.Year, data.Month, data.DayofMonth);
    dayStrings = yyyymmdd(dts);
    dayStringsCat = categorical(dayStrings);
    
    keys = categories(dayStringsCat);
    counts = num2cell(countcats(dayStringsCat));
    
    addmulti(intermKVStore, keys, counts);
end

function plotReducer (intermKey, intermValIter, outKVStore)
    numberOfFlights = 0;
    while hasnext(intermValIter)
        nextCount = getnext(intermValIter);
        numberOfFlights = numberOfFlights + nextCount;
    end
    add(outKVStore, intermKey, numberOfFlights);
end