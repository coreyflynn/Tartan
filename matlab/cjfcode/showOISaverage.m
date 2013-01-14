function yy2=showOISaverage(fname,subIm,nfa,zmdn,displayim)
% Usage ... yy=showOISaverage(fname,subIm,nfa,zmdn,displayims)
%
% subIm = im# , nfa = #im, zmdn= 0/1, displayims= #'s

if isstr(fname),
  eval(sprintf('load %s avgim',fname))
else,
  avgim=fname;
end;

if nargin<5,
  displayim=[];
end;
if nargin<4,
  zmdn=1;
end;
if nargin<3,
  nfa=1;
end;
if nargin<2,
  subIm=mean(avgim,3);
end;

if length(subIm)<32,
  if length(subIm)==1,
    subIm=subIm*ones(size(avgim(:,:,1)));
  else,
    subIm=mean(avgim(:,:,subIm),3);
  end;
end;

cnt=0;
tmpim=0;
cnt2=0;
for mm=1:size(avgim,3),
  tmpim=tmpim+avgim(:,:,mm)-subIm;
  cnt=cnt+1;
  if cnt==nfa,
    if zmdn>=1,
      tmpim2=zoomdn2(tmpim);
    else,
      tmpim2=tmpim;
    end;
    cnt2=cnt2+1;
    yy(:,:,cnt2)=tmpim2/nfa;
    cnt=0;
    tmpim=0;
  end;
end;

if length(displayim)==1,
  displayim=[1:displayim];
elseif length(displayim)==2,
  displayim=[displayim(1):displayim(2)];
elseif length(displayim)==0,
  displayim=[1:size(yy,3)];
end;

yy=yy(:,:,displayim);
yymed=median(yy,3);
minmax=[min(min(yymed)) max(max(yymed))];
yy2=tile3d(yy,minmax);

if nargout==0,
  colormap(gray(256))
  disp(sprintf('  displayed min/max= [%f, %f]',minmax(1),minmax(2)));
  disp(sprintf('     actual min/max= [%f, %f]',min(min(yy2)),max(max(yy2))));
  clear yy2
end;

