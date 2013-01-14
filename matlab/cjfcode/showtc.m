function showtc(im,tcvol,ww,tt)
% Usage ... showtc(im,tcvol,ww,tt)
%

if (nargin<4),
  tt=[];
end;
if (nargin<3),
  ww=[];
end;
if (nargin==1),
  tcvol=im;
  im=tcvol(:,:,1);
end;

if isempty(ww),
  ww=[min(min(im)) max(max(im))];
end;
if isempty(tt),
  tt=[1:size(tcvol,3)];
  if isstruct(tcvol),
    tt=[1:length(tcvol)];
  end;
end;

subplot(211)
show(im,ww)

exit_flag=0;
while (~exit_flag),
  subplot(211)
  [locy,locx,locbb]=ginput(1);
  locy=round(locy);
  locx=round(locx);
  if (locy<1), locy=1; end;
  if (locy>size(im,2)), locy=size(im,2); end;
  if (locx<1), locx=1; end;
  if (locx>size(im,1)), locx=size(im,1); end;
  %[locy locx],
  if (locbb==3),
    exit_flag=1;
  else,
    subplot(212)
    if isstruct(tcvol),
      plot(tt,zeros(size(tt)))
      hold('on')
      if isfield(tcvol,'blue'), if ~isempty(tcvol(1).blue),
        for mm=1:length(tcvol), tmpblue(mm)=tcvol(mm).blue(locx,locy); end;
	plot(tt,double(squeeze(tmpblue)),'b')
      end; end;
      if isfield(tcvol,'green'), if ~isempty(tcvol(1).green),
        for mm=1:length(tcvol), tmpgreen(mm)=tcvol(mm).green(locx,locy); end;
	plot(tt,double(squeeze(tmpgreen)),'g')
      end; end;
      if isfield(tcvol,'red'), if ~isempty(tcvol(1).red),
        for mm=1:length(tcvol), tmpred(mm)=tcvol(mm).red(locx,locy); end;
	plot(tt,double(squeeze(tmpred)),'r')
      end; end;
      hold('off')
    else,
      plot(tt,squeeze(tcvol(locx,locy,:)))
    end;
  end;
end;

