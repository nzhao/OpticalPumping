function A2 = interval_union( A )
%INTERVAL_UNION Summary of this function goes here
%   Detailed explanation goes here
%   A solution found in
%   https://www.mathworks.com/matlabcentral/newsreader/view_thread/171594
    if all(A(:, 1)<A(:,2))
        n = size(A,1);
        [t,p] = sort(A(:));
        z = cumsum(accumarray((1:2*n)',2*(p<=n)-1));
        z1 = [0;z(1:end-1)];
        A2 = [t(z1==0 & z>0),t(z1>0 & z==0)];
    else
        error('wrong input');
    end
end

