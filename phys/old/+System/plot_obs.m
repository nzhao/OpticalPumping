function p = plot_obs( time, res, style, func )
%PLOT_OBS Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 3
        style = cell(1,length(res));
        for k=1:length(res)
            style{k} = '.-';
        end
        func = @plot;
    end
    
    if nargin < 4
        func = @plot;
    end
    
    keys = res.keys;
    vals = res.values;
    hold off;
    for k=1:length(keys)

        style_idx = mod(k, length(style));
        if style_idx ==0
            style_idx = length(style);
        end
        p=func(time, vals{k}, style{style_idx});
        hold on;
    end
    legend(keys);
    legend('boxoff');

end

