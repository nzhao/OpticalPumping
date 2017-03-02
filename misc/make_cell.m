function cell_obj = make_cell( object )
%MAKE_CELL Summary of this function goes here
%   Detailed explanation goes here
    if iscell(object)
        cell_obj = object;
    else
        cell_obj =  {object};
    end

end

