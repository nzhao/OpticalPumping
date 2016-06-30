%function [aIjg,gSj,aIje,gJj]=spin_matrices(I,S,J,gI,gS,gJ)
function mat=spin_matrices(atom)
    qn=atom.qn; I=qn.I; S=qn.S; J=qn.J;
    sw=atom.sw; gI=sw.gI; gS=sw.gS; gJ=sw.gJ;

    %operators in their own space
    sIp=diag(sqrt((1:2*I).*(2*I:-1:1)),1);
    sIj(:,:,1)=(sIp+sIp')/2;
    sIj(:,:,2)=(sIp-sIp')/(2*1i);
    sIj(:,:,3)=diag(I:-1:-I);
    sSp=diag(sqrt((1:2*S).*(2*S:-1:1)),1);
    sSj(:,:,1)=(sSp+sSp')/2;
    sSj(:,:,2)=(sSp-sSp')/(2*1i);
    sSj(:,:,3)=diag(S:-1:-S);
    sJp=diag(sqrt((1:2*J).*(2*J:-1:1)),1);
    sJj(:,:,1)=(sJp+sJp')/2;
    sJj(:,:,2)=(sJp-sJp')/(2*1i);
    sJj(:,:,3)=diag(J:-1:-J);
    %operators in uncoupled space
    for k=1:3
        aIjg(:,:,k)=kron(sIj(:,:,k),eye(gS));
        gSj(:,:,k)=kron(eye(gI),sSj(:,:,k));
        aIje(:,:,k)=kron(sIj(:,:,k),eye(gJ));
        gJj(:,:,k)=kron(eye(gI),sJj(:,:,k));
    end
    mat.aIjg=aIjg;
    mat.gSj=gSj;
    mat.aIje=aIje;
    mat.gJj=gJj;
end