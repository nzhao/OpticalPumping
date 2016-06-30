function y=del(a,b,c) 
%\Delta(a,b,c)=\frac{(a+b-c)!(a-b+c)!(-a+b+c)!}{(a+b+c+1)!}
y=sqrt(prod(1:a+b-c)*prod(1:a-b+c)*prod(1:-a+b+c)/prod(1:a+b+c+1)); 
