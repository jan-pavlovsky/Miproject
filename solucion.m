files = dir('./*.csv');
filenames = {};

for filename = files
    filenames = [filenames, filename.name];
end

ds = datastore(filenames,  'TreatAsMissing', 'NA');
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'TailNum')} = '%s';
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'CancellationCode')} = '%s';
ds.SelectedVariableNames = {'CancellationCode', 'Cancelled', 'Origin'};

res = mapreduce(ds, @mapper, @reducer);


function mapper (data, ~, intermKVStore)
    %Se estandarizan los NA por NaN
    data.CancellationCode = standardizeMissing(data.CancellationCode,'NA');
    % Se eliminan los NaN
    cleared = rmmissing(data);
    %pillar code y cancelled y crear un método que los compare elemento a
    %elemento, si code == b y cancelled == 1, entonces añado un 1 en un
    %vector que he creado. Si no, pues añado un 0.
    code = [cleared.CancellationCode];
    cancelled = [cleared.Cancelled];
    origins = [cleared.Origin];
    aux = ismember(code, 'B') & ismember(cancelled, 1);
    [intermKeys,~, idxs] = unique(origins, 'stable');
    intermVals = accumarray(idxs,aux,size(intermKeys),@countReason);
    addmulti(intermKVStore, intermKeys, num2cell(intermVals));
end

function reducer (intermKey, intermValIter, outKVStore)
    sum_occurences = 0;
    while(hasnext(intermValIter))
        sum_occurences = sum_occurences + getnext(intermValIter);
    end
    add(outKVStore, intermKey, sum_occurences); 
end