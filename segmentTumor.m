function finalMask = segmentTumor(img, threshold)
% Segments tumors in a grayscale image using the specified threshold value.

bnw = im2bw(img, threshold);
invBnw = ~bnw;
C = -bwdist(invBnw);
C(invBnw) = -Inf;
M = watershed(C);
imgLabel = bwlabel(M);
stats = regionprops(imgLabel, 'Solidity', 'Area');

dens = [stats.Solidity];
imgArea = [stats.Area];
highDenseArea = dens > 0.5;
maxArea = max(imgArea(highDenseArea));
tumorLabel = find(imgArea == maxArea);
segTumor = ismember(imgLabel, tumorLabel);

se = strel('square', 5);
segTumor = imdilate(segTumor, se);

boundaries = bwboundaries(segTumor, 'noholes');
for i = 1:length(boundaries)
    [rows, columns, numberOfColorChannels] = size(img);
    segMask = poly2mask(boundaries{i}(:, 2), boundaries{i}(:, 1), rows, columns);
end

finalMask = segMask;

end