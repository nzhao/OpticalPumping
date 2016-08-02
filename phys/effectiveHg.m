function eHg=effectiveHg(atom,power,detuning,Gm2)
%the effective Hamiltonian of ground states, Eq(6.78)
fundamental_constants
eHg=pi*re*c*atom.pm.feg*1e4*power/(atom.pm.weg*(2*pi*1e6*detuning+1i*Gm2));
end