%Susan Meerdink
%This function calculates the number of factors for PLSR
function [valTrait,valSpectra,valIndex,calTrait,calSpectra] = splitValCalMore(allTrait,allSpectra,allSpecies,allSeason)

valIndex = [];
for species = 1:16
    for season = 1:3
        index = find(allSpecies==species & allSeason==season);
        random = randperm((size(index,1)),round((.2*size(index,1)))); %Get random numbers in this bin range
        %inputs = [allTrait(random) ]; % PUll out chemistry and index values
        valIndex = vertcat(valIndex, index(random));%Add them to the validation list
    end  
end

%% Bin Data
[sortedTrait,sortedIndex] = sort(allTrait);

%% Randomly select from each bin for a total of 20% of data
pullNum = round((.2*(size(allTrait,1)) - size(valIndex,1))/4);
breakNum = round(size(allTrait,1)/4);
begin = 1;

for i = 1:4
    if begin+breakNum > size(sortedTrait,1)
        last = size(sortedTrait,1);
    else
        last = (begin+breakNum);
    end
    bin = sortedTrait([begin:last],:);
    random = randperm((size(bin,1)),pullNum); %Get random numbers in this bin range
    %inputs = [sortedTrait(random) ]; % PUll out chemistry and index value
    valIndex = vertcat(valIndex, sortedIndex(random));%Add them to the validation list
    begin = begin + breakNum +1;
end

%% Look for duplicates and replace if necessary
checkDup = unique(valIndex,'sorted');

while size(checkDup,1) < floor(.2*size(sortedTrait,1))
    random = randperm((size(sortedTrait,1)),(size(valIndex,1) - size(checkDup,1)));
    %inputs = [sortedTrait(random) ]; % PUll out chemistry and index values
    valIndex = checkDup; %Remove duplicate
    valIndex = vertcat(valIndex, sortedIndex(random));%Add them to the validation list
    checkDup = unique(valIndex);
end

%% Set final validation and calibration datasets
%Validation (20% of data)
valTrait = allTrait(valIndex);
valSpectra = allSpectra([valIndex],:);

%Calibration (80% of data)
calTrait = allTrait;
calTrait(valIndex) = []; %Calibration with validation removed
calSpectra = allSpectra;
calSpectra([valIndex],:) = [];

disp(['Total number of samples: '  num2str(size(allTrait,1))])
disp(['Number of samples set aside for validation: '  num2str(size(valTrait,1))])
disp(['Number of samples set aside for calibration: '  num2str(size(calTrait,1))])
end