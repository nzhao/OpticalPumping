function Aex=SEmat(S, v)
    Aexj=S.flat+S.sharp-2*1i*matcross(S.flat,S.sharp);%exchange matrix
    Aex=v(1)*Aexj(:,:,1) + v(2)*Aexj(:,:,2) + v(3)*Aexj(:,:,3);
end