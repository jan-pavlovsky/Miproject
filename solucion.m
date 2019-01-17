files = dir('./*.csv');
filenames = {};

for filename = files
    filenames = [filenames, filename.name];
end

filenames = "2000.csv";

ds = datastore(filenames,  'TreatAsMissing', 'NA');

ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'UniqueCarrier')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'TailNum')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Origin')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Dest')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'CancellationCode')} = '%s';
%ds.SelectedVariableNames = {'CancellationCode', 'Cancelled', 'Origin'};



res = mapreduce(ds, @plotMapper, @plotReducer);

arr = zeros(366*20);

function plotMapper (data, info, intermKVStore)
    dts = datetime(data.Year, data.Month, data.DayofMonth);
    dayStrings = yyyymmdd(dts);
    dayStringsCat = categorical(dayStrings);
    
    keys = categories(dayStringsCat);
    counts = num2cell(countcats(dayStringsCat));
    
    %dayOfYear = day(dt, 'dayofyear');
    %totalDay = dayOfYear + (data.Year - 1987 * 365);
    
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