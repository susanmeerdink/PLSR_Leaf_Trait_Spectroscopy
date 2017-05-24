%Susan Meerdink
%This function calculates the PLSR equation
%This function requires the calibration dataset for spectra and traits
%along with the number of factors generated using determinefactors.m
function [results,stdBETA,meanBETA,meanValRMSE,meanValRsq,meanValCIinter,meanValCIx, meanValRegLine,stdValRegLine, meanValCoeff,stdValCoeff] = plsr(calSpectra,valSpectra,calTrait,valTrait,ID)

disp('Running PLSR Model')

BETA = zeros(1000,(size(calSpectra,2)+1));
calRsq = zeros(1000,1);
valRsq = zeros(1000,1);
calRMSE = zeros(1000,1);
valRMSE = zeros(1000,1);
%calCoeff = zeros(1000,round(.7*size(calSpectra,1)));
valCoeff = zeros(1000,size(valSpectra,1));
%calRegLine = zeros(1000,2);
valRegLine = zeros(1000,2);
%calCIinter = zeros(1000,2);
%calCIx = zeros(1000,2);
valCIinter = zeros(1000,2);
valCIx = zeros(1000,2);

for iteration = 1:1000
    %Randomly select 70%
    random = randperm(size(calSpectra,1),round((.7*size(calSpectra,1))));
    tempSpectra = calSpectra([random],:);
    tempTrait = calTrait(random);
    %Run PLSR
    [~,~,~,~,BETA1,~,~,~]=plsregress(tempSpectra,tempTrait,ID); 
    %Calculate Results
    calCoeff1 = [ones(size(tempSpectra,1),1),tempSpectra]*BETA1;
    valCoeff1 = [ones(size(valSpectra,1),1),valSpectra]*BETA1;
    calMDL = LinearModel.fit(tempTrait,calCoeff1,'linear','RobustOpts','on');
    valMDL = LinearModel.fit(valTrait,valCoeff1,'linear','RobustOpts','on');
    %calCI1 = coefCI(calMDL);
    valCI1 = coefCI(valMDL);
    %calRegLine1 = [calMDL.Coefficients.Estimate(1), calMDL.Coefficients.Estimate(2)];
    valRegLine1 = [valMDL.Coefficients.Estimate(1), valMDL.Coefficients.Estimate(2)];
    calRMSE1 = (calMDL.RMSE/(max(calTrait)-min(tempTrait)))*100;
    valRMSE1 = (valMDL.RMSE/(max(valTrait)-min(valTrait)))*100;
    
    BETA([iteration],:) = BETA1';
    calRsq(iteration) = calMDL.Rsquared.Ordinary;
    valRsq(iteration) = valMDL.Rsquared.Ordinary;
    calRMSE(iteration) = calRMSE1;
    valRMSE(iteration) = valRMSE1;
    %calCoeff([iteration],:) = calCoeff1';
    valCoeff([iteration],:) = valCoeff1';
    %calCIinter(iteration,:) = calCI1(1,:);
    valCIinter(iteration,:) = valCI1(1,:);
    %calCIx(iteration,:) = calCI1(2,:);
    valCIx(iteration,:) = valCI1(2,:);
    %calRegLine(iteration,:) = calRegLine1;
    valRegLine(iteration,:) = valRegLine1;
end


% %Regression for Calibration
% calMDL = LinearModel.fit(calTrait,calCoeff,'linear','RobustOpts','on')
% var = 0:(max(calTrait)+max(calTrait)*.25);
% calRegLine = calMDL.Coefficients.Estimate(1) + calMDL.Coefficients.Estimate(2)*var;
% %calRegLine = calMDL.Coefficients.Estimate(1) + calMDL.Coefficients.Estimate(2)*calChem;
% calRMSE = (calMDL.RMSE/(max(calTrait)-min(calTrait)))*100;
% 
% %Regression for Validation
% valMDL = LinearModel.fit(valTrait,valCoeff,'linear','RobustOpts','on')
% valRegLine = valMDL.Coefficients.Estimate(1) + valMDL.Coefficients.Estimate(2)*var;
% %valRegLine = valMDL.Coefficients.Estimate(1) + valMDL.Coefficients.Estimate(2)*valChem;
% valRMSE = (valMDL.RMSE/(max(valTrait)-min(valTrait)))*100;

%% Math
stdBETA = std(BETA)';
meanBETA = mean(BETA)';
stdValRMSE = std(valRMSE);
meanValRMSE = mean(valRMSE);
stdValRsq = std(valRsq);
meanValRsq = mean(valRsq);
stdCalRMSE = std(calRMSE);
meanCalRMSE = mean(calRMSE);
stdCalRsq = std(calRsq);
meanCalRsq = mean(calRsq);
%meanCalRegLine = mean(calRegLine);
%stdCalRegLine = std(calRegLine);
meanValRegLine = mean(valRegLine);
stdValRegLine = std(valRegLine);
%meanCalCoeff = mean(calCoeff);
%stdCalCoeff = std(calCoeff);
meanValCoeff = mean(valCoeff);
stdValCoeff = std(valCoeff);
%meanCalCI = mean(calCIinter);
meanValCIinter = mean(valCIinter);
meanValCIx = mean(valCIx);

%% Output Table
% 
% results = zeros(1,14);
%     % Number of Samples, Number used for Validation, # of Factors,
%     % Calibration mean and std Rsq, Calibration mean and std RMSE,
%     % Validation mean and std Rsq, Validation mean and std RMSE,
%     % model average rsq and rmse
results = [(size(calTrait,1)+size(valTrait,1)), size(valTrait,1), ID, meanCalRsq, stdCalRsq, meanCalRMSE, stdCalRMSE, meanValRsq, stdValRsq, meanValRMSE, stdValRMSE, ((meanCalRsq+meanValRsq)/2), ((meanCalRMSE+meanValRMSE)/2)];

end