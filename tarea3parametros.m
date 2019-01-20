function [cancelledStats, divertedStats] = tarea1parametros(datastore)
    data = datastore;
    data.SelectedVariableNames = {'Year', 'Month', 'DayofMonth', 'Cancelled', 'Diverted'};

    res = mapreduce(data, @mapperCancelled, @reducerCounter);
    table = readall(res)
    
    table = sortrows(table);
    table.Key = datetime(table.Key, 'InputFormat', 'yyyyMMdd');
    table.Value = cell2mat(table.Value);
    
    cancelledStats = table;
    
    res = mapreduce(data, @mapperDiverted, @reducerCounter);
    table = readall(res);
    
    table = sortrows(table);
    table.Key = datetime(table.Key, 'InputFormat', 'yyyyMMdd');
    table.Value = cell2mat(table.Value);
    
    divertedStats = table;
end

function mapperCancelled (data, ~, intermKVStore) 
    cancelled = data(data.Cancelled == 1,:);
    
    [keys, counts] = mapCountsByDay(cancelled);

    addmulti(intermKVStore, keys, counts);
end

function mapperDiverted (data, ~, intermKVStore)       
    diverted = data(data.Diverted == 1,:);
    
    [keys, counts] = mapCountsByDay(diverted);

    addmulti(intermKVStore, keys, counts);
end

function reducerCounter (intermKey, intermValIter, outKVStore)
    numberOfFlights = 0;
    while hasnext(intermValIter)
        nextCount = getnext(intermValIter);
        numberOfFlights = numberOfFlights + nextCount;
    end
    add(outKVStore, intermKey, numberOfFlights);
end