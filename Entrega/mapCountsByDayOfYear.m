function [keys, counts] = mapCountsByDayOfYear(data) % check if works correctly
    dts = datetime(2001, data.Month, data.DayofMonth);
    dayStrings = yyyymmdd(dts);
    
    T = table(dayStrings, data.Cancelled, 'VariableNames', {'Day', 'Cancelled'});
    TF = (T.Cancelled == 1);
    TC = T(TF, :);
    %disp(T(1:100));
    %head(TC, 100)
    %TF
    dayStringsCat = categorical(dayStrings);
    dayStringsCatCancelled = categorical(TC.Day);
    
    keys = categories(dayStringsCat);
    %keysCancelled = categories(dayStringsCatCancelled);
    %missingKeys = setdiff(keys, keysCancelled);
        
    counts = num2cell(countcats(dayStringsCat));
    countsCancelled = num2cell(countcats(dayStringsCatCancelled));
    
    
    
    
    
    
    %cell2mat(keys)
    %counts = countcats(dayStringsCat)
    %class(counts)
    %class(zeros(5, 1))
    %counts
    %counts = cell2mat(counts);
    
    %counts = [counts, zeros(length(counts), 1)];
    %counts(ismember(counts(:, 1), countsCancelled(:, 1)), 3) = countsCancelled(:, 2); % magic
    %counts = num2cell(counts);
   
    
    %[size(counts) size(countsCancelled)]
end

