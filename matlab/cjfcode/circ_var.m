function cvar=circ_var(angles)
%angles in degrees
%calculate the mean cosine and sin components of the anglefield
cbar=mean(cosd(angles),3);
sbar=mean(sind(angles),3);

%calculate the mean resultant length and use V=1-R to report the circular
%variance
R=sqrt(cbar.^2+sbar.^2);
cvar=1-R;
