function [keys, counts] = mapCountsByDay(data)
    dts = datetime(data.Year, data.Month, data.DayofMonth);
    dayStrings = yyyymmdd(dts);
    dayStringsCat = categorical(dayStrings);
    
    keys = categories(dayStringsCat);
    counts = num2cell(countcats(dayStringsCat));
end

