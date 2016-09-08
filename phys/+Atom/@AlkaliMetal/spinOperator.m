function op = spinOperator( obj )
%SPINOPERATOR Summary of this function goes here
%   Detailed explanation goes here

    S=obj.matEigen.Smat{1};
    dim_lv = obj.dim(1)*obj.dim(1);
    S_circleC=zeros(dim_lv, dim_lv, 3);
    S_flat=zeros(dim_lv, dim_lv, 3);
    S_sharp=zeros(dim_lv, dim_lv, 3);
    for k=1:3
        S_circleC(:,:,k) = circleC(S(:,:,k));
        S_flat(:,:,k)    = flat(S(:,:,k));
        S_sharp(:,:,k)   = sharp(S(:,:,k));
    end
    
    op.SD = matdot(S_circleC, S_circleC)/2; %S-damping matrix
    op.SE =S_flat+S_sharp-2*1i*matcross(S_flat,S_sharp);%exchange matrix
    op.S_circleC = S_circleC;
    op.S_flat = S_flat;
    op.S_sharp = S_sharp;
    
    
end

