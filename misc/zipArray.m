function zipped_array = zipArray( array1, array2 )
%ZIPARRAY 此处显示有关此函数的摘要
%   此处显示详细说明

len1 = length(array1); len2 = length(array2);
ext_array1 = repmat(array1, len2, 1);
ext_array2 = repmat(array2, len1, 1).';
zipped_array = [ext_array1(:) ext_array2(:) ];

end

