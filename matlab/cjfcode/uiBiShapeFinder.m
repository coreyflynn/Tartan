function uiBiShapeFinder(im)

figure; imagesc(medfilt2(im));
im=medfilt2(im);
%get user input for a ceter point
[x,y] = ginput(1);
x = round(x)
y = round(y)

edgePointsY = zeros(1,8);
edgePointsX = zeros(1,8);

[cx,cy,c] = improfile(im,[y,size(im,1)],[x,x]);
[pointy,pointx] = getLineEdgePoint(cx,cy,c);
edgePointsY(1) = pointy;
edgePointsX(1) = pointx;

[cx,cy,c] = improfile(im,[y,size(im,1)],[x,size(im,2)]);
[pointy,pointx] = getLineEdgePoint(cx,cy,c);
edgePointsY(2) = pointy;
edgePointsX(2) = pointx;

[cx,cy,c] = improfile(im,[y,y],[x,size(im,2)]);
[pointy,pointx] = getLineEdgePoint(cx,cy,c);
edgePointsY(3) = pointy;
edgePointsX(3) = pointx;

[cx,cy,c] = improfile(im,[1,y],[size(im,2),x]);
[pointy,pointx] = getLineEdgePoint(cx,cy,c);
edgePointsY(4) = pointy;
edgePointsX(4) = pointx;

[cx,cy,c] = improfile(im,[1,y],[x,x]);
[pointy,pointx] = getLineEdgePoint(cx,cy,c);
edgePointsY(5) = pointy;
edgePointsX(5) = pointx;

[cx,cy,c] = improfile(im,[1,y],[1,x]);
[pointy,pointx] = getLineEdgePoint(cx,cy,c);
edgePointsY(6) = pointy;
edgePointsX(6) = pointx;

[cx,cy,c] = improfile(im,[y,y],[1,x]);
[pointy,pointx] = getLineEdgePoint(cx,cy,c);
edgePointsY(7) = pointy;
edgePointsX(7) = pointx;

[cx,cy,c] = improfile(im,[y,size(im,1)],[x,1]);
[pointy,pointx] = getLineEdgePoint(cx,cy,c);
edgePointsY(8) = pointy;
edgePointsX(8) = pointx;

hold on;
scatter(edgePointsX,edgePointsY);
hold off;

h = imellipse(gca,[min(edgePointsX) min(edgePointsY) max(edgePointsX)-min(edgePointsX) max(edgePointsY)-min(edgePointsY  )]);



function [pointy,pointx] = getLineEdgePoint(cx,cy,c)
cDiffAbs = abs(diff(c));
found = find(cDiffAbs == max(cDiffAbs), 1);
pointy = cy(found);
pointx = cx(found);

	