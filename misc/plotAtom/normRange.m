function r = normRange( v, vmax, vmin, rmax, rmin, margin_portion )
%NORMRANGE Summary of this function goes here
%   Detailed explanation goes here
    dr = rmax-rmin; dv=vmax-vmin;
    rmax1=rmax-margin_portion*dr;
    rmin1=rmin+margin_portion*dr;
    
    dr1 = rmax1-rmin1;
    r = rmin1 + dr1/dv*(v-vmin);
end

