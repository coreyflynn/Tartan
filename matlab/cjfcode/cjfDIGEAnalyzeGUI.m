function [finalimages,summary]=cjfDIGEAnalyzeGUI(varargin)
%% determine what the user input and set the varables appropriately 
if nargin==2
    Cy3im=varargin{1};
    Cy5im=varargin{2};
    ratiocutoff=2;
end
if nargin==3
    Cy3im=varargin{1};
    Cy5im=varargin{2};
    ratiocutoff=varargin{3};
end

%% Break the images into subimages and flatten each with cjfDIGEPanel
panel_size=[256 256];
numxpanels=4;
numypanels=5;
Cy3panelstack=zeros(panel_size(1),panel_size(2),numxpanels*numypanels);
Cy5panelstack=zeros(panel_size(1),panel_size(2),numxpanels*numypanels);
panelcount=0;
disp('Flattening Images');
for xpanel=0:numxpanels-1
    for ypanel=0:numypanels-1
        panelcount=panelcount+1;
        Cy3panel=Cy3im(panel_size(2)*ypanel+1:panel_size(2)*ypanel+panel_size(2),panel_size(1)*xpanel+1:panel_size(1)*xpanel+panel_size(1));
        Cy5panel=Cy5im(panel_size(2)*ypanel+1:panel_size(2)*ypanel+panel_size(2),panel_size(1)*xpanel+1:panel_size(1)*xpanel+panel_size(1));
        images=cjfDIGEPanel(Cy3panel,Cy5panel);
        Cy3panelstack(:,:,panelcount)=images.FlatCy3im;
        Cy5panelstack(:,:,panelcount)=images.FlatCy5im;
    end
end

%% Recompile the flattened images
disp('Recompiling Flattened Images...');
FlatCy3=zeros(size(Cy3im));
FlatCy5=zeros(size(Cy5im));
panelcount=0;
for xpanel=0:numxpanels-1
    for ypanel=0:numypanels-1
        panelcount=panelcount+1;
        FlatCy3(panel_size(2)*ypanel+1:panel_size(2)*ypanel+panel_size(2),panel_size(1)*xpanel+1:panel_size(1)*xpanel+panel_size(1))=Cy3panelstack(:,:,panelcount);
        FlatCy5(panel_size(2)*ypanel+1:panel_size(2)*ypanel+panel_size(2),panel_size(1)*xpanel+1:panel_size(1)*xpanel+panel_size(1))=Cy5panelstack(:,:,panelcount);
    end
end
finalimages.FlatCy3=FlatCy3;
finalimages.FlatCy5=FlatCy5;

%% Ask the User to Crop the image
disp('Choose ROI');
[finalimages.FlatCy3,croprect]=imcrop;
finalimages.FlatCy5=imcrop(finalimages.FlatCy5,croprect);

%% Find Spot edges in the flattened Cy3 image and define spot domains based on
%% the edges.
disp('Calculating Spot Domains...');
finalimages.Edges=edge(finalimages.FlatCy3,'canny');
finalimages.EdgeDistance=bwdist(finalimages.Edges);
finalimages.SpotDomains=watershed(-finalimages.EdgeDistance);

%% Calculate the mean and standard deviation of the mean ratio from all
%% spot domains.
disp('Finding Significantly Different Spots...')
summary.Ratios=[];
for N=2:max(max(finalimages.SpotDomains));
    found=finalimages.SpotDomains==N;
    Cy3mean=mean(Cy3im(found)+1);
    Cy5mean=mean(Cy5im(found)+1);
    summary.Ratios=horzcat(summary.Ratios,Cy3mean/Cy5mean);
end
summary.RatioMean=mean(summary.Ratios);
summary.RatioStd=std(summary.Ratios);

%% Find spots that are significantly different from the mean ratio
summary.SigSpots=find(summary.Ratios>summary.RatioMean+ratiocutoff*summary.RatioStd | summary.Ratios<summary.RatioMean-ratiocutoff*summary.RatioStd);


figure(1);subplot(2,2,1);hist(summary.Ratios,100);title(sprintf('mean=%d, std=%d',summary.RatioMean,summary.RatioStd));
subplot(2,2,2);imagesc(finalimages.Edges);title('Found Edges');
subplot(2,2,3);imagesc(finalimages.EdgeDistance);title('Edge Distance');
subplot(2,2,4);imagesc(finalimages.SpotDomains);title('Spot Domains');


summary.FoundSpots=length(summary.Ratios);
summary.NumSig=length(summary.SigSpots);
summary
disp(sprintf('found %d spots',length(summary.Ratios)));
disp(sprintf('...%d of which were significant at %d standard deviations',sum(summary.NumSig),ratiocutoff));


        
        