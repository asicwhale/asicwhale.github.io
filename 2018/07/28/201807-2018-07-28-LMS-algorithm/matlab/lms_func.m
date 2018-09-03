function [yn,W,en]=lms_func(xn,dn,M,mu,itr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%     xn   input signal-colum vecot
%     dn   refrence response signal vertor
%     M    order of filter
%     mu   step factor, require >0   
%     itr   iteration times
% Output:
%     W    fiter taps matrix :  M X iter
%     en   Error colum vector: iter X 1 
%     yn   filter output colum vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 4                  
    itr = length(xn);
elseif nargin == 5             
    if itr>length(xn) || itr<M
        error('ERROR: iteration times maybe too large or small!');
    end
else
    error('please check the inpur paramter of this function!');
end

en = zeros(itr,1);             
W  = zeros(M,itr);             

% Iterative caculation
for k = M:itr                 
    x = xn(k:-1:k-M+1);   
    y = W(:,k-1).' * x;     
    en(k) = dn(k) - y ;    
    
    W(:,k) = W(:,k-1) + 2*mu*en(k)*x;
end
% filter output sequce
yn = inf * ones(size(xn));
for k = M:length(xn)
    x = xn(k:-1:k-M+1);
    yn(k) = W(:,end).'* x;
end