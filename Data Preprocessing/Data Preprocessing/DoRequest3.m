filename = 'bands.dat';
T = readtable(filename);

disp('Claculating Antropy for the classification attribute ...');

att = T(:,20);
XT = table2array(att);
XT = string(XT);

N = size(XT,1);
count1 = size( find(XT == 'band'),1);
prop1 = (count1)/N;

count2 = size( find(XT == 'noband'),1);
prop2 = (count2)/N;

HT = - prop1 * log2(prop1) - prop2 * log2(prop2);

disp(' Antropy for the classification attribute H(T)');
HT


for i=9:12
    HNew_X = 0; %the antropy for the current attribute ...  All Bin Mean Values
    
    
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
    
    
    
    
    New_X = table2array(att);
    if size(OutLiers,1) ~= 0
        New_X = New_X(New_X>=LF & New_X <= UF);
    end
    
    disp('Applaying n equal-width ...');
    disp('Number of Bins and width ')
    n = 3
    
    Min = min(X);
    Max = max(X);
    Width = (Max-Min)/n
    
    for j = 1 : n
        Bin = X (X >= Min+ (j-1)*Width & X< Min+ j * Width);
        disp('Smoothing By Mean')
        Mean = mean (Bin);
        indexs = find(ismember( New_X,Bin));
        New_X(indexs) = Mean;
        
        disp('Calculating the antropy for the generated categorical value ... Bin Mean Value');
        
        count1 = size( find(XT(indexs) == 'band'),1);
        BinN = size(Bin,1);
        prop1 = (count1)/BinN;
        
        count2 = size( find(XT(indexs) == 'noband'),1);
        prop2 = (count2)/BinN;
        
        HBin  = - prop1 * log2(prop1) - prop2 * log2(prop2)
        
        %Calculating the antropy for the current attribute ...  All Bin Mean Values
        prop = BinN/N;
        HNew_X = HNew_X + prop * HBin;
    end
    disp('Calculating the antropy for the current attribute ...  All Bin Mean Values');
    HNew_X
    disp('Calculating the GAIN for the current attribute ...');
    Gain = HT - HNew_X
end


for i=9:12
    HNew_X = 0; %the antropy for the current attribute ...  All Bin Mean Values
    
    
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
    
    
    
    
    New_X = table2array(att);
    if size(OutLiers,1) ~= 0
        New_X = New_X(New_X>=LF & New_X <= UF);
    end
    
    disp('Applaying n equal-width ...');
    disp('Number of Bins and width ')
    n = 4
    
    Min = min(X);
    Max = max(X);
    Width = (Max-Min)/n
    
    for j = 1 : n
        Bin = X (X >= Min+ (j-1)*Width & X< Min+ j * Width);
        disp('Smoothing By Mean')
        Mean = mean (Bin);
        indexs = find(ismember( New_X,Bin));
        New_X(indexs) = Mean;
        
        disp('Calculating the antropy for the generated categorical value ... Bin Mean Value');
        
        count1 = size( find(XT(indexs) == 'band'),1);
        BinN = size(Bin,1);
        prop1 = (count1)/BinN;
        
        count2 = size( find(XT(indexs) == 'noband'),1);
        prop2 = (count2)/BinN;
        
        HBin  = - prop1 * log2(prop1) - prop2 * log2(prop2)
        
        %Calculating the antropy for the current attribute ...  All Bin Mean Values
        prop = BinN/N;
        HNew_X = HNew_X + prop * HBin;
    end
    disp('Calculating the antropy for the current attribute ...  All Bin Mean Values');
    HNew_X
    disp('Calculating the GAIN for the current attribute ...');
    Gain = HT - HNew_X
end

