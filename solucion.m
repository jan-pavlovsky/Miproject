files = dir('./*.csv');
filenames = {};

for filename = files
    filenames = [filenames, filename.name];
end

ds = datastore(filenames,  'TreatAsMissing', 'NA');

ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'UniqueCarrier')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'TailNum')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Origin')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'Dest')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'CancellationCode')} = '%s';
%ds.SelectedVariableNames = {'CancellationCode', 'Cancelled', 'Origin'};

res = mapreduce(ds, @mapper, @reducer);


function mapper (data, ~, intermKVStore)
    
end

function reducer (intermKey, intermValIter, outKVStore)

end