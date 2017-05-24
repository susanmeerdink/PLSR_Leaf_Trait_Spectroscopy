%Susan Meerdink
%This function calculates the number of factors for PLSR
function [meanPRESSY, ID, Min, meanPCTVAR] = determinefactors(spectra,trait)

disp('Determining number of components')
nobs = size(trait,1);
ncomp = nobs - 2;
c = cvpartition((size(trait,1)),'leaveout');
PRESSY = zeros(c.NumTestSets,ncomp+1);
PCTVAR = zeros(c.NumTestSets,ncomp);
for i = 1:c.NumTestSets
    [~,~,~,~,~,PCTVAR1,MSE,~]= plsregress(spectra(c.training(i),:),trait(c.training(i)),ncomp);
    PRESSY(i,:) = MSE(2,:); %Pull out PRESS stat for y
    PCTVAR(i,:) = cumsum(100*PCTVAR1(2,:));
end
%Note: PLSR setting components or factors is run on full data set


%% Figure out the lowest number of components using PRESS 
meanPRESSY = mean(PRESSY);
meanPCTVAR = mean(PCTVAR);
IDm = [];

[Minm,IDm] = min(meanPRESSY(10:20)); % Pulls lowest PRESS statistic to determine number of factors
IDm = IDm + 9;
PCTm = meanPCTVAR(IDm);
        
disp([ 'ID of minimum PRESS statistic for Y: ' num2str(IDm)])
disp([ 'Value of minimum PRESS statistic for Y: ' num2str(Minm)])
disp([ 'Percent Variance Explained at minimum PRESS statistic for Y: ' num2str(PCTm)])

ID = IDm;
Min = Minm;

%% Figure for % Variance Explained

%Figure of PRESS statistic for y
figure('units','normalized','outerposition',[0 0 1 1])
hold on
plot(1:(ncomp),meanPCTVAR,'-bo'); axis square;
grid on
xlabel('Number of Factors');
ylabel ('Percent of Variance Explained');
axis([0 30 0 100])
scatter(IDm,PCTm,'r','filled'); %Adds minimum onto the graph
pressText = ['PRESS = ' sprintf('%0.2f',PCTm) ' at ' num2str(IDm)];
text(0.95,1,{pressText},'Units','normalized','VerticalAlignment','top','HorizontalAlignment','right','FontSize',14)
legend('% Var Explained','PRESS statistic','Location', 'BestOutside');
hold off

%% Figure for PRESS stat

%Figure of PRESS statistic for y
figure('units','normalized','outerposition',[0 0 1 1])
hold on
plot(1:(ncomp+1),meanPRESSY,'-bo'); axis square;
grid on
xlabel('Number of Factors');
ylabel ('PRESS Statistic');
axis([0 30 0 meanPRESSY(1)])
scatter(IDm,Minm,'r','filled'); %Adds minimum onto the graph
pressText = ['PRESS = ' sprintf('%0.2f',Minm) ' at ' num2str(IDm)];
text(0.95,1,{pressText},'Units','normalized','VerticalAlignment','top','HorizontalAlignment','right','FontSize',14)
legend('PRESS Statistic','t-test','PRESS statistic','Location', 'BestOutside');
hold off
end
