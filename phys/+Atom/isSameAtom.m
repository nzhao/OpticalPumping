function tf = isSameAtom( atom1, atom2 )
%ISSAMEATOM Summary of this function goes here
%   Detailed explanation goes here
    tf = strcmp(atom1.name, atom2.name);
end

