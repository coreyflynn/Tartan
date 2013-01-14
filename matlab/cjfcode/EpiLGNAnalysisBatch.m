function EpiLGNAnalysisBatch
%basic setup
basePath='F10_087RLGN_RGB_align';
extension='.jpg';
numImages=25;
%assume that the first slice in the series is used and then every third
%slice after that.  This is a custom analysis used here to accomodate our
%experimental pipeline in which CRMP4, myelin, and nissl stains are
%alternated in the same LGN.  The slice numbering will still be in the
%right order.  Ex. slice1=CRMP4, slice2=myelin, slice3=nissl, slice4=CRMP4
outputCell={'Slice','Total Area','Overlap Area','Percent Overlap',...
            'Number of Ipsi Patches', 'Ipsi Percent Area',...
            'Ipsi Perim/Area',...
            'Contra Percent Area', 'Contra Perim/Area'};
for ii=1:3:numImages
    im=imread([basePath num2str(ii) extension]);
    disp(['analyzing ' basePath num2str(ii) extension '...']);
    out=EpiLGNAnalysis(im);
    %save slice output to file
    save([basePath 'Slice' num2str(ii) 'EpibatidineMorphology']);
    tmpCell={['Slice' num2str(ii)],out.TotalArea,out.OverlapArea,...
             out.PercentOverlap, length(out.Ipsi.Stats),...
             out.Ipsi.PercentArea, out.Ipsi.PerimToArea,...
             out.Contra.PercentArea, out.Contra.PerimToArea};
    outputCell=vertcat(outputCell,tmpCell);
    disp('');
end
%write to an external .csv file using cell2csv
outputString=[basePath 'EpibatidineMorphologySummary.csv'];
disp(['writing csv file to ' outputString]);
cell2csv(outputString,outputCell,',',2000)
