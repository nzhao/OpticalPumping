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
    
    op.Proj=cell(1,3); op.cProj=cell(1,3); op.rProj=cell(1,3);
    op.Proj{1} = eye(obj.dim( Atom.Subspace.GS ));
    op.Proj{2} = eye(obj.dim( Atom.Subspace.ES1 ));
    op.Proj{3} = eye(obj.dim( Atom.Subspace.ES2 ));
    op.cProj{1} = op.Proj{1}(:); op.rProj{1} = op.cProj{1}';
    op.cProj{2} = op.Proj{2}(:); op.rProj{2} = op.cProj{1}';
    op.cProj{3} = op.Proj{3}(:); op.rProj{3} = op.cProj{1}';
    
end

