function dydt=drho(t,rho,atom,eHg)
fundamental_constants

% rho=zeros(atom.sw.gg^2,1);
% drhodt=(eHg*reshape(rho,atom.sw.gg,atom.sw.gg)...
%            -reshape(rho,atom.sw.gg,atom.sw.gg)*eHg')/(1i*hbar);

rho=zeros(atom.sw.gg);
drhodt=(eHg*rho-rho*eHg')/(1i*hbar);

 dydt=drhodt(:);
end