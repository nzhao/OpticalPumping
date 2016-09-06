function mat = Spin( j )
%SPIN Summary of this function goes here
%   Detailed explanation goes here

    p=diag(sqrt((1:2*j).*(2*j:-1:1)),1);
    mat(:,:,1)=(p+p')/2;
    mat(:,:,2)=(p-p')/(2*1i);
    mat(:,:,3)=diag(j:-1:-j);
end

