function val = PROJ_PATH( )
%PROJ_PATH Summary of this function goes here
%   Detailed explanation goes here
val = strrep(mfilename('fullpath'), '/const/PROJ_PATH','');
val = strrep(val, '\const\PROJ_PATH',''); % for windows
%val = '/Users/nzhao/code/lib/active/OpticalPumping';

end

