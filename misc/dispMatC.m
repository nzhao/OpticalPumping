function fig = dispMatC( mat, mode )

    if nargin == 1
        mode='ReIm';
    end

    if strcmp(mode, 'ReIm')
        mat1=real(mat); mat2=imag(mat);
    elseif strcmp(mode, 'LenPhi')
        mat1=abs(mat); mat2=angle(mat);
    end
    
    fig=figure;
    subplot(1,2,1);
    dispMat(mat1);
    subplot(1,2,2);
    dispMat(mat2);

end

