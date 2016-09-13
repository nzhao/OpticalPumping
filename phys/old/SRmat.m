function Arot = SRmat(S, v)
%SRMAT Summary of this function goes here
%   Detailed explanation goes here
    Arot = v(1)*S.circleC(:,:,1) + v(2)*S.circleC(:,:,2) + v(3)*S.circleC(:,:,3);
end

