function para = parse_paremeters( dft_para, args )
%PARSE_PAREMETERS Summary of this function goes here
%   Detailed explanation goes here
    
    dft_k = keys(dft_para);
    dft_v = values(dft_para);
    
    para = containers.Map();
    for q = 1:dft_para.length
        para(dft_k{q}) = dft_v{q};
    end
    
    len = floor( length(args)/2 );
    if length(args) ~= 2*len
        error('odd arguments recieved.');
    end
    
    new_arg = reshape(args, [2, len]);
    new_k = new_arg(1, :);
    new_v = new_arg(2, :);
    for q = 1:len
        if dft_para.isKey( new_k{q} )
            para( new_k{q} ) = new_v{q};
        else
            warning('non-supported key %s is ignored.', new_k{q});
        end
    end

end

