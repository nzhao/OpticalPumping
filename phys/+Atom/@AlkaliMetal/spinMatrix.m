function m = spinMatrix( obj )
%SPINMATRIX Summary of this function goes here
%   Detailed explanation goes here
    
    I2 = obj.I*(obj.I+1); 
    S2 = obj.J.*(obj.J+1);
    
    muI = obj.parameters.mu_I;
    LgS = {obj.parameters.LgS, ...
           obj.parameters.LgJ1, ...
           obj.parameters.LgJ2};
    
    Imat=Atom.Spin(obj.I);
    Smat={Atom.Spin(obj.J(1)), ...
          Atom.Spin(obj.J(2)), ...
          Atom.Spin(obj.J(3))};
    
    for i=1:3
        m.Imat{i} = kroneye(Imat, obj.gJ(i));
        m.Smat{i} = eyekron(obj.gI, Smat{i});
        m.Fmat{i} = m.Smat{i} + m.Imat{i};
        m.IS{i} = matdot(m.Imat{i}, m.Smat{i}); 
        m.F2{i} = (I2+S2(i))*eye(obj.dim(i)) + 2*m.IS{i};
        m.mu{i} = -LgS{i}*muB * m.Smat{i}  + muI*muN/(obj.I+eps) * m.Imat{i};
    end

end

