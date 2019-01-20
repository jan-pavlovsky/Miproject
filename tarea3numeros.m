function [totalFlights cancelledFlights] = tarea3numeros(datastore) % add mean calculation + festive only
    ds = datastore;
    ds.SelectedVariableNames = {'Year', 'Month', 'DayofMonth', 'Cancelled'};
    res = mapreduce(ds, @plotMapper, @plotReducer);

    table = readall(res);
    table = sortrows(table);
    table.Key = datetime(table.Key, 'InputFormat', 'yyyyMMdd');
    table.Value = cell2mat(table.Value);

    totalFlights = table;
    
    res = mapreduce(ds, @plotMapperC, @plotReducer);

    table = readall(res);
    table = sortrows(table);
    table.Key = datetime(table.Key, 'InputFormat', 'yyyyMMdd');
    table.Value = cell2mat(table.Value);

    cancelledFlights = table;
end

function plotMapper (data, info, intermKVStore)
    [keys, counts] = mapCountsByDayOfYear(data);

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

function plotMapperC (data, info, intermKVStore)
    [keys, counts] = mapCountsCancelledByDayOfYear(data);

    addmulti(intermKVStore, keys, counts);
end

function plotReducerC (intermKey, intermValIter, outKVStore) 
    numberOfFlights = 0;
    
    while hasnext(intermValIter)
        nextCount = getnext(intermValIter);
        numberOfFlights = numberOfFlights + nextCount;
    end
    add(outKVStore, intermKey, numberOfFlights);
end

function [keys, counts] = mapCountsByDayOfYear(data)
    dts = datetime(2001, data.Month, data.DayofMonth);
    dayStrings = yyyymmdd(dts);
    
    dayStringsCat = categorical(dayStrings);
    
    keys = categories(dayStringsCat);
    
    counts = num2cell(countcats(dayStringsCat));
end 


function [keysCancelled, countsCancelled] = mapCountsCancelledByDayOfYear(data)
    dts = datetime(2001, data.Month, data.DayofMonth);
    dayStrings = yyyymmdd(dts);
    
    T = table(dayStrings, data.Cancelled, 'VariableNames', {'Day', 'Cancelled'});
    TF = (T.Cancelled == 1);
    TC = T(TF, :);
    
    dayStringsCatCancelled = categorical(TC.Day);
    
    keysCancelled = categories(dayStringsCatCancelled);
    
    countsCancelled = num2cell(countcats(dayStringsCatCancelled));
end 


