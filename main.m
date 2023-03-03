% Define the folders containing the images and their masks
imgFolder = 'E:\Dataset_BUSI_with_GT\ben';
maskFolder = 'E:\Dataset_BUSI_with_GT\mask';
shadow_exists=[];
ShadowBorder = {};
% Get a list of all the images and their corresponding masks
imgFiles = dir(fullfile(imgFolder, '*.png'));
maskFiles = dir(fullfile(maskFolder, '*.png'));
iteration = 50;
% Loop through each image and its mask
for i = 1:length(imgFiles)
    % Read in the image and mask
    img = imread(fullfile(imgFolder, imgFiles(i).name));
    mask = imread(fullfile(maskFolder, maskFiles(i).name));    
   % Convert RGB images to grayscale
    if ndims(img) == 3
        img = rgb2gray(img);
    end  
    % Find the optimal threshold value for the image
    threshold = findOptimalThreshold(img);   
    % Segment the tumor using the optimal threshold value
    segmentedMask = segmentTumor(img, threshold);
    borderWidth = 2;
    maskedimage = img;
    [shadow, mostWhiteBorder, mostWhiteBorderPixels] = findShadow(segmentedMask);
    if shadow == 1
         maskedimage = applyShadowCropping(img, mostWhiteBorderPixels, threshold);
         threshold = findOptimalThreshold(maskedimage);
         segmentedMask = segmentTumor(maskedimage, threshold);
    end
    ac_img=activecontour(img,segmentedMask,iteration,'Chan-Vese');
    imgWithBorder = createTumorBorder(img, ac_img, borderWidth);
    % Plot original, segmented, and bordered images side by side
    plotFigures(img,maskedimage, imgWithBorder, ac_img,mask, threshold, shadow)
end