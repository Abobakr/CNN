filename = 'bands.dat';
T = readtable(filename);

for i=9:12
    
    % take the attribute and covert to array
    disp(['For Attribute Number ',num2str(i)])
    disp('-------------------------------------------------------');
    
    att = T(:,i);
    X = table2array(att);
    
    % Fisrt we see if we have outliers
    disp('Fisrt we see if we have outliers')
    X = sort(X);
    Q1 = ClacQuartile(X,25);
    Q3 = ClacQuartile(X,75);
    IQR = Q3 - Q1;
    LF = Q1- 1.5* IQR; % LowerFence
    UF = Q3+ 1.5* IQR; % UpperFence
    OutLiers = X(X<LF | X > UF)
    
    % remove outliers if exist    
    if size(OutLiers,1) ~= 0
        X = X(X>=LF & X <= UF);
    end
    disp('Outliers are removed')
    
    %Five Number Summary
    disp('Five Number Summary')
    Min = min(X)
    Q1  
    Med = median(X)
    Q3
    Max = max(X)
    
    disp('Other statistical measures')
    Mean = mean(X)
    Mode = mode(X)
    IQR
    Variance = var(X)
    StandardDeviation = std(X)
    figure
    boxplot(X);  
    title(['For Attribute Number ',num2str(i)])
    
    
end

