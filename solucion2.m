function [ output_args ] = lab7( input_args )
close all;clear all;clc;

function mapperDelays (data, ~, intermKVStore)
    add(intermKVStore, 'DepDelay',data.DepDelay);
end


function reducerDelays (intermKey, intermValIter, outKVStore)
    totalFlights = 0;
    totalDelay = 0;
    while hasnext(intermValIter)
        totalFlights = sumFlights + 1;
        totalDelay = getnext(intermValIter);
    end
    addmulti(outKVStore, {'TotalFlights', 'TotalDelay'}, {totalFlights, totalDelay});
end

function mapperCD (data, ~, intermKVStore)
    %disp(data.Cancelled);
    %add(intermKVStore, 'Cancelled',data.Cancelled);
    %add(intermKVStore, 'DepDelay',data.DepDelay);
    %add(intermKVStore, 'ArrDelay',data.ArrDelay);
    %add(intermKVStore, 'Diverted',data.Diverted);
    addmulti(intermKVStore, {'Cancelled', 'Diverted'}, {data.Cancelled, data.Diverted});
end

function reducerCD (intermKey, intermValIter, outKVStore)
    totalFlights = 0;
    affectedFlights = 0;
    
    while hasnext(intermValIter)
        %totalFlights = totalFlights + 1;
        %disp(totalFlights)
        flights = getnext(intermValIter);
        totalFlights = 2*length(flights);
        size(flights)
        for index = 1:numel(flights)
            %disp('aaaaaaaaaaaaaaaaaaaa')
            
            %size(flight)
            if (flights(index) > 0)
                affectedFlights = affectedFlights + 1;
            end
        end
    end
    addmulti(outKVStore, {'TotalFlights', 'AffectedFlights'}, {totalFlights, affectedFlights});
    %add(outKVStore, 'TotalFlights', totalFlights);
end

files = dir('./*.csv');
filenames = {};

for filename = files
    filenames = [filenames, filename.name];
end

%filenames = ['lineas.csv'];
%filenames = ['2001.csv'];


ds = datastore(filenames,  'TreatAsMissing', 'NA');
ds.SelectedFormats{strcmp(ds.SelectedVariableNames, 'CancellationCode')} = '%s';
%ds.SelectedVariableNames = {'CancellationCode', 'Cancelled', 'Origin'};
ds.SelectedVariableNames = {'Cancelled', 'DepDelay', 'ArrDelay', 'Diverted'};

res = mapreduce(ds, @mapperCD, @reducerCD);
readall(res)
end