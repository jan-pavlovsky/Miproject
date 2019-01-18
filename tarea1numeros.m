function [result] = tarea1numeros(datastore)
    ds = datastore;
    ds.SelectedVariableNames = {'Year', 'Month', 'DayofMonth'};
    res = mapreduce(ds, @plotMapper, @plotReducer);

    table = readall(res);
    table = sortrows(table);
    table.Key = datetime(table.Key, 'InputFormat', 'yyyyMMdd');
    table.Value = cell2mat(table.Value);

    result = table;
end

function plotMapper (data, info, intermKVStore)
    [keys, counts] = mapCountsByDay(data);
    
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