function thresh = findOptimalThreshold(img)
% Finds the optimal threshold for segmenting tumors in a grayscale image.

qValues = 0.1:0.01:0.5;
statsArray = zeros(length(qValues), 2);

for i = 1:length(qValues)
    bnw = im2bw(img, qValues(i));
    invBnw = ~bnw;
    C = -bwdist(invBnw);
    C(invBnw) = -Inf;
    M = watershed(C);
    imgLabel = bwlabel(M);
    stats = regionprops(imgLabel, 'Solidity', 'Area');
    
    dens = [stats.Solidity];
    imgArea = [stats.Area];
    highDenseArea = dens > 0.45;
    maxArea = max(imgArea(highDenseArea));
    tumorLabel = find(imgArea == maxArea);
    segTumor = ismember(imgLabel, tumorLabel);
    
    se = strel('square', 5);
    segTumor = imdilate(segTumor, se);
    
    boundaries = bwboundaries(segTumor, 'noholes');
    boundary = boundaries{1};
    x = boundary(:, 2);
    y = boundary(:, 1);
    yellowMask = poly2mask(x, y, size(img, 1), size(img, 2));
    pixelsInYellowMask = bnw(yellowMask);
    
    numBlack = sum(pixelsInYellowMask == 0);
    numWhite = sum(pixelsInYellowMask == 1);
    statsArray(i, :) = [numBlack, numWhite];
end

blackToWhiteRatio = statsArray(:, 1) ./ statsArray(:, 2);
[~, idx] = max(blackToWhiteRatio);
thresh = qValues(idx);

end