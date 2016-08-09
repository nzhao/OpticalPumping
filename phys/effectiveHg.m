function eHg = effectiveHg( atom, beam, B, Gm2, temperature )
%EFFEHG Summary of this function goes here
%   Detailed explanation goes here
    fundamental_constants
    
    H=Hamiltonian(atom,B);  %Hamiltonian
    uHg=H.uHg;  uHe=H.uHe;
    eigVg=eigH(uHg);  eigVe=eigH(uHe);
    eigV.Ug=eigVg.U; eigV.Eg=eigVg.E;
    eigV.Ue=eigVe.U; eigV.Ee=eigVe.E;

    [~,~,Heg,~]=rfShift(eigV.Ee,eigV.Eg,atom);

    Dj=dipoleOperator(eigV.Ug,eigV.Ue,atom);
    tV=interaction(atom,beam,Dj);
    
    if nargin == 4 
        tW=tV./(Heg-hP*beam.Dw-1i*hbar*Gm2);
    elseif nargin == 5
        sigv=(2*pi/atom.pm.lamJ)*sqrt(kB*temperature*NA/atom.pm.MW);%Doppler variance, k*v; v=Eq(6.111)
        z=-(Heg-hP*beam.Dw-1i*hbar*Gm2)/(hbar*sigv*sqrt(2));
        tW=tV.*w(z)*1i*sqrt(pi/2)/(hbar*sigv); %w(z) is the Faddeeva function
    else
        error('wrong input');
    end
    
    eHg = -tV'*tW;
end

