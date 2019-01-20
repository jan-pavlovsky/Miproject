function [depDelays, arrDelays] = tarea1retrasos(datastore, totalsByDay)
    ds = datastore;
    ds.SelectedVariableNames = {'Year', 'Month', 'DayofMonth', 'DepDelay'};

    res = mapreduce(ds, @mapperDelays, @reducerDelays);
    table = readall(res)
    
    table = sortrows(table);
    table.Key = datetime(num2str(table.Key), 'InputFormat', 'yyyyMMdd');
    table.Value = cell2mat(table.Value);

    depDelays = table;
    depDelays.avg = depDelays.Value ./ totalsByDay.Value

    ds = datastore;
    ds.SelectedVariableNames = {'Year', 'Month', 'DayofMonth', 'ArrDelay'};

    res = mapreduce(ds, @mapperDelays, @reducerDelays);
    table = readall(res)
    
    table = sortrows(table);
    table.Key = datetime(num2str(table.Key), 'InputFormat', 'yyyyMMdd');
    table.Value = cell2mat(table.Value);

    arrDelays = table;
    arrDelays.avg = arrDelays.Value ./ totalsByDay.Value;
end

function mapperDelays (data, ~, intermKVStore)
    data = data(~isnan(data.(4)),:);
    data.uniqueDayString = yyyymmdd(datetime(data.Year, data.Month, data.DayofMonth));

    cats = unique(data.uniqueDayString);
    daySums = table(cats);
    daySums.sums = zeros(height(daySums), 1);

    dict = containers.Map(cats, zeros(length(cats), 1));

    for i = 1:height(data)
        dict(data.uniqueDayString(i)) = dict(data.uniqueDayString(i)) + data.(4)(i);
    end

    keySet = keys(dict);
    valueSet = values(dict, keySet);

    addmulti(intermKVStore, keySet, valueSet);
end



function reducerDelays (intermKey, intermValIter, outKVStore)
    delaySum = 0;
    while hasnext(intermValIter)
        delaySum = delaySum + getnext(intermValIter);
    end
    add(outKVStore, intermKey, delaySum);
end