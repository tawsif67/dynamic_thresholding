function imgWithBorder = createTumorBorder(img, segmentedMask, borderWidth)
    % Create a border around the segmented tumor
    tumorPerimeter = bwperim(segmentedMask);
    se = strel('disk', borderWidth); % create a disk structuring element
    tumorBorder = imdilate(tumorPerimeter, se); % dilate the tumor perimeter
    imgWithBorder = imoverlay(img, tumorBorder, [1 0 0]);
end