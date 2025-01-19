filename = 'bands.dat';
T = readtable(filename);

for i=9:12
    figure 
    
     
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
    
    
    
    % min-max normalizasyon
    
    Min = min(X);
    Max = max(X);
    New_Min = 0;
    New_Max = 1;
    
    X_MinMax = ((X - Min )/ (Max - Min) ) * (New_Max- New_Min) + New_Min;
    disp('min-max normalization is Done ');
    disp(X_MinMax');
    
   
    Mean = mean(X);
    SD = std(X);
    
    X_ZScore = (X-Mean)/SD;
    disp('Z-Score normalization is Done ');
    disp(X_ZScore')
    
    disp('Applaying n equal-width ...');
    disp('Number of Bins and width ')
    n = 5
    Width = (Max-Min)/n
    X = sort(X);
    for j = 1 : n
        Bin = X (X >= Min+ (j-1)*Width & X< Min+ j * Width);
        histogram(Bin)
        hold on
    end
    
       
end