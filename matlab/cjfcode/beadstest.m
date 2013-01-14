function beadstest(im)
%This is a test implementation of the BEADS algorithm originally described
%by Langella and Zivy in Proteomics 2008 vol. 8 (23-24) pp. 4914-4918.  The
%algorithm finds spot domains in 2D gel images based on a physical analogy
%of beads rolling uphill on a surface defined by the gel image.  Beads are
%attracted to spot peaks which represent local maximums.
%
%VARIABLES:
%
%im - the gel image to be analyzed

%Get a test coordinate from the user on a display of the input image
tmpim=double(im);
Pos=zeros(1,2);
imagesc(tmpim);colormap(gray);
tmpPos=round(ginput(1));
Pos(1)=tmpPos(2);Pos(2)=tmpPos(1);

%Set up holding variables for later use 
oPos=Pos;
lines=zeros(2,25,2704);
linenum=1;

%explore a 101x101 pixel box centered on the user selcted pixel by
%simulating the movement of a beads along the gel surface starting at every
%other pixel in the box

%iterate through each starting point
for ii=-51:2:51
    for jj=-51:2:51
        %calculate this iteratations starting point
        Pos(1)=oPos(1)+ii;Pos(2)=oPos(2)+jj;
        for N=1:25
            %move the bead one step and store that steps location
            Pos=mvParticle(Pos,tmpim);
            lines(:,N,linenum)=Pos;
        end
        linenum=linenum+1;
    end
end

%display the original image along with the final location of all beads and
%a trail of where they have been
imagesc(tmpim);hold on;
trailsim=tmpim*0;
for N=1:size(lines,3)
    line(lines(2,:,N),lines(1,:,N),'Color','r');hold on;
    scatter(lines(2,25,N),lines(1,25,N),'b');hold on;
    %compute the number of beads crossing each pixel
    for M=1:25
        trailsim(lines(1,M,N),lines(2,M,N))=trailsim(lines(1,M,N),lines(2,M,N))+1;
    end
end
%display the summed pixel image
figure;imagesc(log(trailsim));colormap(gray);

for N=1:25
    imagesc(tmpim);hold on;
    scatter(lines(2,N,:),lines(1,N,:),'b');hold on;drawnow;hold off;
    pstr=sprintf('~/Desktop/tmp/beads%g.jpg',N);
    print(gcf,'-djpeg',pstr);
end