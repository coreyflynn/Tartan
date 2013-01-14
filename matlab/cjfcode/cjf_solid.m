function cjf_solid(xlist,ylist,zlist,color)
% inputs x,y,and z coordinates of points and generates a filled, semi-transparent,
% 3D solid mesh of those points.
%
% USAGE
% cjf_solid(xlist,ylist,zlist,color)
%
% VARIABLE DEFINITIONS
% xlist,ylist,zlist - 1xn arrays of the x,y, and z coordinates of the pints
% to be meshed into a solid object patch
%
% color - a string secifying the color of the 3D solid that will be created
% all color specifications conform to MATLAB default color definitions 
% for example, 'r' specifies a red solid and 'g' specifies a green solid

% check to see if the list sizes match, if not terminate the function and
% give an error message
dimcheck = length(xlist) ~= length(ylist) | length(xlist) ~= length(zlist);
if dimcheck ==1
    errordlg('xlist, ylist, and zlist must be the same size');
    return
end
% input the three lists of points into a matrix nx3 matrix which define the
% postions of all the vertices to be meshed.
FV.vertices=horzcat(xlist',ylist',zlist');
% use the 3D version of the delaunay tesselation to create tetrahedrons
% which represent the optimal spacing of faces for the given inputs. Use
% these face definitions to render a patch object in the current figure.
FV.faces=delaunay3(xlist,ylist,zlist);
patch(FV,'FaceColor',color);alpha .5;axis off;
