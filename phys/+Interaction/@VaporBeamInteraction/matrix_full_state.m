function fullG = matrix_full_state( obj )
%MATRIX_FULL_STATE Summary of this function goes here
%   Detailed explanation goes here
    Dk = obj.beam.refTransition; % D1 or D2
    dimG = obj.vapor.atom.dim(1);
    dimE = obj.vapor.atom.dim(1+Dk);
    
        tV =  Interaction.AtomPhotonInteraction(obj.vapor, obj.beam);

        gamma_s_ge = obj.vapor.atom.parameters.gamma_s(Dk);
        A_spDecay_ge=obj.vapor.atom.operator.spDecay{Dk};


        freq = obj.vapor.atom.eigen.transFreq;
        gamma1 = gamma_s_ge;
        gamma2 = obj.vapor.gamma2+0.5*gamma_s_ge;
        E_ee = diag( freq{1+Dk, 1+Dk}(:) - 1i*gamma1 );
        E_ge = diag( freq{1, 1+Dk}(:) - 1i*gamma2 );
        E_eg = diag( freq{1+Dk, 1}(:) - 1i*gamma2 );
        E_gg = diag( freq{1, 1}(:) );

        Pg=obj.vapor.atom.operator.Proj{1}; Pe=obj.vapor.atom.operator.Proj{1+Dk};
        gg=obj.vapor.atom.dim(1); ge=obj.vapor.atom.dim(1+Dk);
        n1=1:ge^2; n2=ge^2+1:ge^2+ge*gg; n3=ge^2+ge*gg+1:ge^2+2*ge*gg; n4=ge^2+2*ge*gg+1:(ge+gg)^2; 

        G0=zeros((ge+gg)^2); 
        G0(n1, n1)=1i*E_ee; G0(n2, n2)=1i*E_ge; G0(n3, n3)=1i*E_eg; G0(n4, n4)=1i*E_gg;

        G1=zeros((ge+gg)^2); 
        G1(n1, n2)=1i*kron(Pe, tV); 
        G1(n1, n3)=-1i*kron(conj(tV), Pe);
        G1(n2, n4)=-1i*kron(conj(tV), Pg);
        G1(n3, n4)=1i*kron(Pg, tV);
        G1=G1-G1';

        G2=zeros((ge+gg)^2);
        G2(n4, n1)=-gamma_s_ge*A_spDecay_ge;

        G3=zeros((ge+gg)^2);

        detune = obj.get_atom_beam_detuning();
        doppler_shif = obj.beam.wavenumber*obj.parameter.velocity /2/pi *1e-6;
        G3(n2, n2)=1i*(detune-doppler_shif)*eye(ge*gg);
        G3(n3, n3)=-1i*(detune-doppler_shif)*eye(ge*gg);

        fullG=G0+G1+G2+G3;
    
    %% output variables
    
    obj.matrix.vapor_kernel = fullG;
    
    obj.parameter.dimG = dimG;
    obj.parameter.dimE = dimE;
end

