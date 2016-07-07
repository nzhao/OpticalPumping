function Aex=exchangeMat(flatS,sharpS)
Aex=flatS+sharpS-2*1i*matcross(flatS,sharpS);%exchange matrix
end