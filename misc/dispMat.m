function fig = dispMat( mat, xlabel, ylabel )
    [dim1, dim2]=size(mat);
    if nargin == 1
        xlabel=cell(1, dim1);
        ylabel=cell(1, dim2);
        for nx=1:dim2
            xlabel{nx}=['x', num2str(nx)];
        end
        for ny=1:dim1
            ylabel{ny}=['y', num2str(ny)];
        end
    end
    fig=imagesc(mat);            %# Create a colored plot of the matrix values
    

    colormap(gca,cmap(100, max(mat(:)), min(mat(:))));
    %colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                             %#   black and lower values are white)

    if 0.5*(dim1+dim2)<=32
        textStrings = num2str(mat(:),'%0.1e');  %# Create strings from the matrix values
        textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
        [x,y] = meshgrid(1:dim2, 1:dim1);   %# Create x and y coordinates for the strings
        hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                        'HorizontalAlignment','center');
        %midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
        textColors = [0 0 0];%repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                                     %#   text color of the strings so
                                                     %#   they can be easily seen over
                                                     %#   the background color
        set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
    end

    colorbar;
    set(gca,'XTick',1:dim2,...                         %# Change the axes tick marks
            'XTickLabel', xlabel,...  %#   and tick labels
            'YTick',1:dim1,...
            'YTickLabel', ylabel,...
            'TickLength',[0 0]);


function c=cmap(nstep, maxVal, minVal)
    one_col = ones(nstep, 1); inc = linspace(0, (nstep-1)/nstep, nstep)'; dec =linspace((nstep-1)/nstep, 0, nstep)';
    b=[dec dec one_col]; r = [one_col inc inc]; 
    
    
    if minVal >= 0
        ncut = round(nstep * (maxVal-minVal)/maxVal );
        c = r(ncut:-1:1,:);
    elseif maxVal < 0
        ncut = round(nstep * abs((minVal-maxVal)/minVal) );
        c = b(end:-1:end-ncut,:);
    elseif minVal < 0 && maxVal >=0
        if abs(minVal) > abs(maxVal)
            ncut = round(nstep*abs(maxVal/minVal));
            c = [b(end:-1:1,:); [1 1 1]; r(end:-1:end-ncut,:)];
        else
            ncut = round(nstep*abs(minVal/maxVal));
            c = [b(ncut:-1:1,:); [1 1 1]; r(end:-1:1,:)];
        end
    else
        error('wrong min. or max. values min=%f, max=%f', maxVal, minVal);
    end

