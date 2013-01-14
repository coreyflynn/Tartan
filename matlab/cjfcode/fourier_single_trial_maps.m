function fourier_single_trial_maps(varargin)
% This funciton takes a set of blocks from a fourier orientaiton imaging 
% expriment and computes single trial angle maps from the data as well as a
% summed map.  The maps are all computed using a method in which 18 
% discrete difference images are used to compute the angle map.  This 
% method is faster than a frequency based approach, but less accurate. 
%
% USAGE 
% fourier_single_trial_maps(expnum,startblk,endblk) - This command operates
% on the set of the collected data specified between startblk and endblk.  
% Data is assumed to be from the first stimulus cycle.
%
% fourier_single_trial_maps(expnum,startblk,endblk) - This command operates
% on the set of the collected data specified between startblk and endblk.
% Analysis of data starts at the specified cycle.
%
% VARIABLE DEFINITIONS
% expnum - the experiment number from which the data is to be analyzed 
%          (note the data block names must be of the form "Data_ExBy", 
%          where x and y are the experiment number and the block number, 
%          respectively).
% sartblk - the block file at which data analysis should start
% end blk - the block file at which data analysis should end
% cycle - the first cycle into which maps are to be written 

% Parse user input
if nargin==3
    expnum=varargin{1};
    startblk=varargin{2};
    endblk=varargin{3};
    cycle=0;
elseif nargin==4
    expnum=varargin{1};
    startblk=varargin{2};
    endblk=varargin{3};
    cycle=varargin{4};
end

% create intermediate holding arrays for data storage, open a lookup table 
% for later use, and initilize a flag to allow manual ROI definition for 
% image normalization.
xmagtotal=zeros(1024);
ymagtotal=zeros(1024);
averagestack=zeros(1024,1024,36); 
cmaps=open('cjflut.mat');
firstflag=1;

% get a user defined path to a file in the directory to be analyzed.  
% Additionally, check for an output directory into which data
% will be written.  If the directory does not exist, create it.
[fname,path]=uigetfile('*.BLK','~/Desktop');
if isdir(sprintf('%s/Analysis/Fourier/',path))==1
else
    mkdir(sprintf('%s/Analysis/Fourier/',path));
end


% initialize a progress bar
h=waitbar(0,sprintf('Trial %d Progress',cycle+1));

% For all data in the range indicated, read the data in, generate 18 
% discrete orientation difference images, and use these images to compute 
% single cycle maps as well as cumulative maps.
for N=startblk:endblk
	  % read data in from each block file and average all of the frames in
      % the block file for analysis.  This is similar to using
	  % a temporal boxcar filter on the data.
      tmp=blkread_longdaq(sprintf('%sData_E%dB%d.BLK',path,expnum,N));
      disp(sprintf('Reading Block %d Data',N));
      averagestack(:,:,mod(N,36)+1)=mean(tmp.data,3);
      waitbar((mod(N,36)+1)/36,h,sprintf('Trial %d Progress',cycle+1));
      
      % For each cycle of the data, compute 18 discrete difference images 
      % and compute a single cycle angle map from them.
      if mod(N,36)==0 && N~=36
          cycle=cycle+1;
          % if the cycle is the first in the analysis series, ask the user 
          % to define a spatial ROI in the dataset to normalize over.
          if firstflag==1
              figure(1);
              diff=(averagestack(:,:,1)+averagestack(:,:,19)/2)...
                  -(averagestack(:,:,10)+averagestack(:,:,28)/2);
              subplot(1,1,1);imagesc(diff);colormap(gray);
              title('select an ROI to normilze over');caxis([-25 25]);
              mask=roipoly;
              firstflag=0;
          end
          
          %initialize storage arrays for the current cycle
          orientationdiff=zeros(1024,1024,18);
          xmag=zeros(1024);
          ymag=zeros(1024);
          z=zeros(1024);
          
          % Compute 18 difference images and write them to the output 
          % directory
          for M=1:18
                pos=(averagestack(:,:,M)/2+averagestack(:,:,M+18)/2);
                neg=(averagestack(:,:,mod(M+9,36)+1)/2+...
                averagestack(:,:,mod(M+27,36)+1)/2);
                ratio=mean(pos(find(mask==1)))/mean(neg(find(mask==1)));
                pos=pos*ratio;
                diff=pos-neg;
                diff=diff-min(min(diff(find(mask==1))));
                diff(find(mask==0))=-1;
                orientationdiff(:,:,M)=diff;
                cpp_write2(sprintf(...
                    '%s/Analysis/Fourier/cycle%d_orientationdiff%d'...
                    ,path,cycle,M),orientationdiff(:,:,M));
                subplot(3,6,M);imagesc(orientationdiff(:,:,M));
                colormap(gray);title(sprintf(...
                    '(%d+%d)-(%d+%d)',M,M+18,M+9,M+27));
                drawnow;
                xmag=xmag+diff*cosd(20*M);
                ymag=ymag+diff*sind(20*M);
          end
          
          % Compute the current cycle angle map using vector addition from 
          % the summed magnitude of the orthoganal components of the 
          % diffences images computed above.
          z=atan2(ymag,xmag)/2;
          z=z/pi*180+90;
          subplot(1,2,1);imagesc(z);colormap(cmaps.cjflut.circle);
          colorbar;title(sprintf('Cycle %g map',cycle));drawnow;
          
          % calculate a running average of the two orthoganal components of
          % the difference images 
          xmagtotal=(cycle-1)/cycle*xmagtotal+xmag;
          ymagtotal=(cycle-1)/cycle*ymagtotal+ymag;
          
          % diplay the cumulative angle map
          ztotal=(atan2(ymagtotal,xmagtotal)/2)/pi*180+90;
          subplot(1,2,2);imagesc(ztotal);colormap(cmaps.cjflut.circle);
          colorbar;title('Cumulative map');drawnow;
          
          % write intermediate images to the output directory
          cpp_write2(sprintf('%s/Analysis/Fourier/cycle%d_anglemap',...
              path,cycle),z);
          cpp_write2(sprintf('%s/Analysis/Fourier/cycle%d_xmagmap',...
              path,cycle),xmag);
          cpp_write2(sprintf('%s/Analysis/Fourier/cycle%d_ymagmap',...
              path,cycle),ymag);
      end
end
% write the cumulative angle map to the output directory
cpp_write2(sprintf('%s/Analysis/Fourier/final_anglemap',path),ztotal);
close(h);

%Version: 1.0
%Corey J. Flynn
%Laboratory of Justin Crowley
%Department of Biological Sciences
%Carnegie Mellon University
%Contact: cjflynn@andrew.cmu.edu