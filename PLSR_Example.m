%% PLS regression Code
% Susan Meerdink
% 9/14/2015
%This code is being adjusted based on RSE reviewer comments

%% Load Data
load PLSR_example_workspace.mat

%% Setting Variables
traitName = 'Water Content';
disp(['Running PLSR for '  traitName])
allChem = moisture; %pulls out the whole column of data
spectra = ASDspectra; %Pulls out and combines into HyspIRI data

% Finding and removing NaN Values
nanListFull = find(isnan(allChem));
allChem(nanListFull) = [];
spectra([nanListFull],:) = [];
species = sampleInfoNum.Species;
species(nanListFull) = [];
season = sampleInfoNum.Season;
season(nanListFull) = [];

%% Set calibration and validation
[valChem,valspectra,valIndex,calChem,calspectra] = splitValCalMore(allChem,spectra,species,season);

%% HyspIRI Determine Components
[PRESSRMSEY, ID, Min, meanPCTVAR] = determinefactors(spectra,allChem);

%% HyspIRI PLSR Model
[results,stdBETA,meanBETA,meanValRMSE,meanValRsq,meanValCIinter,meanValCIx, meanValRegLine,stdValRegLine, meanValCoeff,stdValCoeff] = plsr(calspectra,valspectra,calChem,valChem,ID);
disp(['Done with PLSR for ' traitName])
%% Creating Figures for PLSR results
plsfigure(valChem, meanValRegLine,meanValCoeff,meanValRsq,meanValRMSE,traitName,meanValCIinter,meanValCIx)

%% Figures for PLSR Coefficients
%plot(hyspiriWavelengths,BETA(:,[2:size(BETA,2)])','.','Color',[119/256 136/256 153/256])
%all model results

%     figure
%     hold on
%     subplot(1,3,[1 2])
%     plot(hyspiriWavelengths,(stdBETA([2:size(meanBETA,2)],:) + meanBETA([2:size(meanBETA,2)],:)),'.','Color',[119/256 136/256 153/256])
%     plot(hyspiriWavelengths,(meanBETA([2:size(meanBETA,2)],:) - stdBETA([2:size(meanBETA,2)],:)),'.','Color',[119/256 136/256 153/256])
%     plot(hyspiriWavelengths,meanBETA([2:size(meanBETA,2)],:),'k-')
%     axis([0.35 2.5 -80 80])
%
%     subplot(1,3,3)
%     hold on
%     plot(hyspiriWavelengths,(stdBETA([2:size(meanBETA,2)],:) + meanBETA([2:size(meanBETA,2)],:)),'.','Color',[119/256 136/256 153/256])
%     plot(hyspiriWavelengths,(meanBETA([2:size(meanBETA,2)],:) - stdBETA([2:size(meanBETA,2)],:)),'.','Color',[119/256 136/256 153/256])
%     plot(hyspiriWavelengths,meanBETA([2:size(meanBETA,2)],:),'k.')
%     axis([3.5 15 -80 80])
%     hold off
%     %%
%     figure
%     h = errorbar(hyspiriWavelengths,meanBETA(:,[2:size(BETA,2)])',stdBETA(:,[2:size(BETA,2)])');
%     set(h,'Color','y')

