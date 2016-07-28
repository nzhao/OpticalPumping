function SAmat=SecularApproMat(nk,gg)
%secular approx. matrices %Eq.(7.44)
SAmat.Mp2=nk*ones(1,gg*gg)-ones(gg*gg,1)*nk'==2;
SAmat.Mp1=nk*ones(1,gg*gg)-ones(gg*gg,1)*nk'==1;
SAmat.M0=nk*ones(1,gg*gg)-ones(gg*gg,1)*nk'==0;
SAmat.Mm1=nk*ones(1,gg*gg)-ones(gg*gg,1)*nk'==-1;
SAmat.Mm2=nk*ones(1,gg*gg)-ones(gg*gg,1)*nk'==-2;
end