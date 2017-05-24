function plsfigure(valTrait, valRegLine,valCoeff,valRsq,valRMSE,traitName,valCIinter,valCIx)

%% Setting up Variables

%Add additional features of graph
if roundn(max(valTrait),2) > roundn(max(valTrait),0)
    upperLim = roundn(max(valTrait),2);
end
if roundn(max(valTrait),2) < roundn(max(valTrait),0)
    upperLim = roundn(max(valTrait),0);
end

if strcmp(traitName,'LMA') == 1
    units = '(g/m^2)';
else
    units = '(%)';
end

%% Valibration figure gray scale
figure; 
axis square;
hold on
%Add regression line
hf = @(x) valRegLine(1) + valRegLine(2)*x;
he = ezplot(hf,[0 upperLim]);
set(he,'Color','k','LineWidth',1.5)

%CI
hciup = @(x) valCIinter(1) + valCIx(1)*x;
hciupf = ezplot(hciup,[0 upperLim]);
set(hciupf,'Color',[159/256 182/256 205/256],'LineWidth',1.5)
hcidw = @(x) valCIinter(2) + valCIx(2)*x;
hcidwf = ezplot(hcidw,[0 upperLim]);
set(hcidwf,'Color',[159/256 182/256 205/256],'LineWidth',1.5)

%Add 1:1 reference line
hRefLine = refline(1,0);
set(hRefLine,'Color','k','LineStyle',':','LineWidth',1.5);
%Add scatter plot of calibration samples
s = scatter(valTrait,valCoeff,'filled');
set(s, 'MarkerFaceColor',[119/256 136/256 153/256],'MarkerEdgeColor','k');
%Add additional features of graph
set(gca,'FontSize',12)
set(gca,'YTick',[0:(upperLim*.25):upperLim])
set(gca,'XTick',[0:(upperLim*.25):upperLim])
set(gca,'YLim',[0 upperLim])
set(gca,'XLim',[0 upperLim])
xlabel(['Observed ' traitName ' ' units],'FontSize',14);
ylabel(['Predicted ' traitName ' ' units],'FontSize',14);
rsqText = ['R^2 = ' sprintf('%0.2f',valRsq)];
rmseText = ['RMSE = ' sprintf('%0.2f',valRMSE)];
nText = ['N_v_a_l = ' num2str(size(valTrait,1))];
text(0.05,1,{rsqText,rmseText,nText},'Units','normalized','VerticalAlignment','top','FontSize',14)
title('')
hold off
end