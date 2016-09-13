function eHg=effectiveHgHighPressure(atom,beam,Gm2)
%the effective Hamiltonian of ground states, Eq(6.78)
fundamental_constants
eHg=pi*re*c*atom.pm.feg*beam.Sl/(atom.pm.weg*(beam.Dw+1i*Gm2));
end