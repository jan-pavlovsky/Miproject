function [totals, destinations, origins] = tarea2(datastore)
    ds = datastore;
    ds.SelectedVariableNames = {'Cancelled', 'CancellationCode', 'Origin', 'Dest'};

    fname = 'airportCodes.txt'; 
    fid = fopen(fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    airportCodes = jsondecode(str);
    
    cells = struct2cell(airportCodes.airports);
    codes = cells(1,:);
    names = cells(2,:);
    
    airCodeDict = containers.Map(codes, names);
    
    res = mapreduce(ds, @mapperTotals, @reducerCounter);
    totalFlights = readall(res);
    
    flightCountDict = containers.Map(totalFlights.Key, totalFlights.Value);
    
    res = mapreduce(ds, @mapperClimatologicalReasons, @reducerCounter);
    table = readall(res);
    
    table.percentage = zeros(height(table), 1);
    for i=1:height(table)
        table.percentage(i) = cell2mat(table{i,2}) / flightCountDict(char(table{i,1}));
    end
    
    totals = table(strcmp(extractAfter(table.Key, 3), ''),:);
    destinations = table(strcmp(extractAfter(table.Key, 3), '-destination'),:);
    origins = table(strcmp(extractAfter(table.Key, 3), '-origin'),:);
    
    totals.Key = extractBefore(totals.Key,4);
    destinations.Key = extractBefore(destinations.Key,4);
    origins.Key = extractBefore(origins.Key,4);
    
    totals.airport = cell(height(totals), 1);
    destinations.airport = cell(height(destinations), 1);
    origins.airport = cell(height(origins), 1);
    
    for i=1:height(totals)
        if isKey(airCodeDict,char(totals{i,1}))
            totals.airport(i) = cellstr(airCodeDict(char(totals{i,1})));
        end
        if isKey(airCodeDict,char(origins{i,1}))
            origins.airport(i) = cellstr(airCodeDict(char(origins{i,1})));
        end
        if isKey(airCodeDict,char(destinations{i,1}))
            destinations.airport(i) = cellstr(airCodeDict(char(destinations{i,1})));
        end
    end
end

function mapperTotals (data, ~, intermKVStore)
    addmulti(intermKVStore, data.Origin, num2cell(zeros(height(data), 1)));
    addmulti(intermKVStore, data.Dest, num2cell(ones(height(data), 1)));
end

function mapperClimatologicalReasons (data, ~, intermKVStore)
    data = data(~isnan(data.Cancelled),:);
    data = data(data.Cancelled == 1,:);
    data = data(strcmp(data.CancellationCode, 'B'),:);

    addmulti(intermKVStore, data.Origin, num2cell(zeros(height(data), 1)));
    addmulti(intermKVStore, data.Dest, num2cell(ones(height(data), 1)));
end

function reducerCounter (intermKey, intermValIter, outKVStore)
    originCancellations = 0;
    destinationCancellations = 0;
    total = 0;
    
    while hasnext(intermValIter)
        total = total + 1;
        
        type = getnext(intermValIter);
        if type == 0
            originCancellations = originCancellations + 1;
        end
        if type == 1
            destinationCancellations = destinationCancellations + 1;
        end
    end
    add(outKVStore, intermKey, total);
    add(outKVStore, [intermKey '-origin'], originCancellations);
    add(outKVStore, [intermKey '-destination'], destinationCancellations);
end