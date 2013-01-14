function [celldata,L,Gstack]=AAG_calcium_analysis(varargin)
%%import images to be analyzed
[files,path]=uigetfile({'*.lsm'},'Select a set of lsm files'...
   ,'~/Desktop','MultiSelect','on');
G=get_OGB_frames(path,files,1);
Gstack=G;

%%display a summed time series image to allow the user to select all cells
%%to be analyzed in the data set
if nargin==0
    Gsum=sum(G,3);imagesc(Gsum);
    mask=zeros(88,88);
    stop_flag=0;
    while stop_flag==0
        subplot(1,2,1);imagesc(mask);
        subplot(1,2,2);imagesc(Gsum.*~mask);colormap(gray);
        tmpmask=roipoly;
        mask=mask+tmpmask;
        button=questdlg('label more cells?');
        if strcmp(button,'No')==1
            stop_flag=1;
        end
    end
elseif nargin==1
    mask=varargin{1};
end
%%Generate a unique cell identifier for all labeled cells and report the
%%number of cells
L=bwlabel(mask,4);
numcells=max(L(:));

%%For each block extract the summed pixel value for each cell through time
%%and compile an average across all user selected blocks
celldata=zeros(numcells,700);
blockdata=get_block_data(celldata,L,G);
celldata=blockdata;
cell_norm=celldata;
cellmean=mean(celldata,2);
for ii=1:numcells
    cell_norm(ii,:)=celldata(ii,:)/cellmean(ii);
end
plot_cells(cell_norm',numcells);
for N=2:length(files)
    G=get_OGB_frames(path,files,N);
    Gstack=Gstack+G;
    blockdata=get_block_data(celldata,L,G);
    celldata=celldata+blockdata; %summed data 
%     celldata=blockdata; %block by block data
    cellmean=mean(celldata,2);
    for ii=1:numcells
        cell_norm(ii,:)=celldata(ii,:)/cellmean(ii);
    end
    plot_cells((cell_norm)',numcells);
end
celldata=celldata/length(files);
plot_cells(cell_norm',numcells);
end

function G=get_OGB_frames(path,files,fnum)
    tmpstack=tiffread2(sprintf('%s/%s',path,files{fnum}));
    G=zeros(88,88,700);
    iter=0;
    disp('extracting OGB data');
    for N=1:2:1400
        iter=iter+1;
        G(:,:,iter)=tmpstack(N).green;
    end
end

function celldata=get_block_data(celldata,L,G)
disp('getting block data');
% %subtract mean data
% Gmean=mean(G,3);
% for N=1:700
%     G(:,:,N)=G(:,:,N)./Gmean;
% end
for M=1:700
    tmpim=G(:,:,M);
    for N=1:size(celldata,1)
        found=find(L==N);
        celldata(N,M)=mean2(tmpim(found));
    end
end
end

function plot_cells(celldata,numcells)
for N=1:numcells
    stim_marks=[1 84 168 252 336 420 504 588 672];
    subplot(4,ceil(numcells/4),N);plot(celldata(:,N));hold on;
    scatter(stim_marks,1.4*ones(size(stim_marks))...
        ,'r.','SizeData',300);hold off;
    ylim([.8 1.5]);
    title(sprintf('cell #%g',N));
end
end
