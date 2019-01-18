filenames = "2001m.csv";

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