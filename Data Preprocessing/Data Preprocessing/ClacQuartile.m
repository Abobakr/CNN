function Q = CalcQuartile(X,rank)

N = size(X,1) ;
index =  (rank/100)*(N+1);

if isinteger(index)
    Q = X(index);
else
    index = floor(index);
    Q = (X(index)+ X(index+1))/2;
end

end