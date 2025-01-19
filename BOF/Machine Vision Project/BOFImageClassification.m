%% Selcuk University - SELÇUK ÜN?VERS?TES? - FEN B?L?MLER? ENST?TÜSÜ
%% Okutman: Yrd. Doç.Dr. Ö. Kaan Baykan - Haz?rlayan: ENG. Abobakr Almostafa

%% Load image data

rootFolder = 'C:\BottleCategories';
imgSets = [ imageSet(fullfile(rootFolder, 'Complete' )), ...
    imageSet(fullfile(rootFolder, 'Incomplete'  ))];

disp('display labels and show the corresponding count of images');
labels = { imgSets.Description } % display all labels on one line
counts = [imgSets.Count] % show the corresponding count of images

%% Show sampling of all data
figure

subplot(1,2,1);
img = read(imgSets(1),1);
imshow(img);
title(char(labels{1}));

subplot(1,2,2);
img = read(imgSets(2),1);
imshow(img);
title(char(labels{2}));

%% Prepare Training and Validation Image Sets

disp('Make the number of images in the training set balanced by trimming to the minimum count');
minSetCount = min([imgSets.Count]) % determine the smallest amount of images in a category
imgSets = partition(imgSets, minSetCount, 'randomize'); % Use partition method to trim the set.

disp('Notice that each set now has exactly the same number of images.');
labels = { imgSets.Description }
counts = [imgSets.Count]

[trainingSet, validationSet] = partition(imgSets, 0.3,... % 30% training 70% validation. 
                                        'randomize'); %Randomize to avoid biasing the results.

%% Create a Visual Vocabulary and Train an Image Category Classifier

% # extracts SURF features
% # constructs the visual vocabulary using K-means 
bag = bagOfFeatures(trainingSet);

% encode method counts the visual word occurrences & produces a histogram.
scenedata = double(encode(bag, trainingSet)); 

%% Visualize Feature Vectors
i = 1;
j = 1;
figure
while i <= 2
    img = read(imgSets(i),randi(imgSets(i).Count));
    featureVector = encode(bag, img);
    
    subplot(2,2,j);
    j = j + 1;
    imshow(img);
    
    
    subplot(2,2,j);
    j = j + 1;
    bar(featureVector);
    
    title('Visual Word Occurrences');
    xlabel('Visual Word Index');
    ylabel('Frequency');
    
    i = i + 1;
end

%% Create a Table using the encoded features
SceneImageData = array2table(scenedata);
sceneType = categorical(repelem({trainingSet.Description}', [trainingSet.Count], 1));
SceneImageData.sceneType = sceneType;

%% Use the new features to train a model and assess its performance using
classificationLearner

%%  multiclass linear SVM classifier
categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);

%% evaluate the classifier on the validationSet
confMatrix = evaluate(categoryClassifier, validationSet);

% Compute average accuracy
disp('average accuracy')
mean(diag(confMatrix))
%% Try the Newly Trained Classifier on Test Images


img = imread(fullfile(rootFolder, 'Incomplete', '20170605_084717.jpg'));
[labelIdx, scores] = predict(categoryClassifier, img);

% Display the string label
categoryClassifier.Labels(labelIdx)

