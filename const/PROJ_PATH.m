function val = PROJ_PATH( )
%PROJ_PATH Summary of this function goes here
%   Detailed explanation goes here
val = strrep(mfilename('fullpath'), '/const/PROJ_PATH','');
%val = '/Users/nzhao/code/lib/active/OpticalPumping';

end

