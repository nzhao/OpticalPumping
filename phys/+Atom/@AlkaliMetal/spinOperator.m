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

    
    electric_dipole=obj.dipole();

    gS = obj.gJ(1);
    gJ1 = obj.gJ(1+Atom.Transition.D1);
    Dj1 = electric_dipole{Atom.Transition.D1};
    A_spDecay1=3/gS*(gJ1/3)*( kron(conj(Dj1(:,:,1)),Dj1(:,:,1)) ... % 3/gS comes from different convention of Dj
                           +kron(conj(Dj1(:,:,2)),Dj1(:,:,2)) ...
                           +kron(conj(Dj1(:,:,3)),Dj1(:,:,3)) );
    gJ2 = obj.gJ(1+Atom.Transition.D2);
    Dj2 = electric_dipole{Atom.Transition.D2};
    A_spDecay2=3/gS*(gJ2/3)*( kron(conj(Dj2(:,:,1)),Dj2(:,:,1)) ...
                             +kron(conj(Dj2(:,:,2)),Dj2(:,:,2)) ...
                             +kron(conj(Dj2(:,:,3)),Dj2(:,:,3)) ); 
    
    op.spDecay=cell(1,2);
    op.spDecay{1} = A_spDecay1; op.spDecay{2} = A_spDecay2;
    op.electric_dipole=electric_dipole;
    
    eyeG=eye(obj.dim(1))/obj.dim(1); zerosD1=zeros(obj.dim(2)); zerosD2=zeros(obj.dim(3));
    op.thermal_state_qs = {[zerosD1(:); eyeG(:)], [zerosD2(:); eyeG(:)]};
    
    op.equilibrium_state = {Algorithm.DensityMatrix(obj, [Atom.Subspace.GS]), ...
                            Algorithm.DensityMatrix(obj, [Atom.Subspace.GS, Atom.Subspace.ES1]), ...
                            Algorithm.DensityMatrix(obj, [Atom.Subspace.GS, Atom.Subspace.ES2])};
end

