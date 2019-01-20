filenames = "2001m.csv";

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
    
    lpa = airCodeDict('LPA');
    prg = airCodeDict('PRG');

ds = datastore(filenames,  'TreatAsMissing', 'NA');

data = read(ds);
height(data)
data = data(~isnan(data.DepDelay),:);
height(data)

data.uniqueDayString = yyyymmdd(datetime(data.Year, data.Month, data.DayofMonth));

cats = unique(data.uniqueDayString);
daySums = table(cats);
daySums.sums = zeros(height(daySums), 1);

dict = containers.Map(cats, zeros(length(cats), 1));

for i = 1:height(data)
    %dict(data.uniqueDayString(i)) = dict(data.uniqueDayString(i)) + data.DepDelay(i);
end

keySet = keys(dict);
valueSet = values(dict);