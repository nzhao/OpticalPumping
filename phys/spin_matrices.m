%function [aIjg,gSj,aIje,gJj]=spin_matrices(I,S,J,gI,gS,gJ)
function mat=spin_matrices(atom)
    fundamental_constants

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
        uFjg(:,:,k)=aIjg(:,:,k)+gSj(:,:,k);
        uFje(:,:,k)=aIje(:,:,k)+gJj(:,:,k);
    end
    mat.aIjg=aIjg;
    mat.gSj=gSj;
    mat.aIje=aIje;
    mat.gJj=gJj;
    
    mat.uFjg=uFjg;
    mat.uFje=uFje;
    mat.uIS=matdot(aIjg,gSj); %uncoupled I.S
    mat.uIJ=matdot(aIje,gJj);%uncoupled I.J
    mat.uF2g=( I*(I+1)+S*(S+1) )*eye(sw.gg)+2*mat.uIS;
    mat.uF2e=( I*(I+1)+J*(J+1) )*eye(sw.ge)+2*mat.uIJ;
    
    %uncoupled spin matrices
    for k=1:3;% uncoupled magnetic moment operators
        mat.umug(:,:,k)=-atom.LgS*muB*gSj(:,:,k) + (atom.pm.muI/(atom.qn.I+eps))*aIjg(:,:,k);
        mat.umue(:,:,k)=-atom.LgJ*muB*gJj(:,:,k) + (atom.pm.muI/(atom.qn.I+eps))*aIje(:,:,k);
    end
end