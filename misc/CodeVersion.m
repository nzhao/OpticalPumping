function sha1 = CodeVersion(  )
%CODEVERSION Summary of this function goes here
%   Detailed explanation goes here
    [~, sha1] = system(['cd ' PROJ_PATH ';' ...
                        'git rev-parse HEAD']);

end

