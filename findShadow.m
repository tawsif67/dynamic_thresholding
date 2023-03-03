function [shadow, mostWhiteBorder, mostWhiteBorderPixels] = findShadow(segmentedMask)

% Create a border around the segmented mask
tumorPerimeter = bwperim(segmentedMask);

% Define the four borders (top, bottom, left, and right)
topBorder = tumorPerimeter(1,:);
bottomBorder = tumorPerimeter(end,:);
leftBorder = tumorPerimeter(:,1);
rightBorder = tumorPerimeter(:,end);

% Count the number of white pixels in each border
topBorderCount = sum(topBorder);
bottomBorderCount = sum(bottomBorder);
leftBorderCount = sum(leftBorder);
rightBorderCount = sum(rightBorder);

% Find the border with the most white pixels
[maxCount, maxIndex] = max([topBorderCount, bottomBorderCount, leftBorderCount, rightBorderCount]);

% Determine the most white border
if maxIndex == 1
    mostWhiteBorder = 'Top Border';
    mostWhiteBorderPixels = [find(topBorder)', repmat(1, topBorderCount, 1)];
elseif maxIndex == 2
    mostWhiteBorder = 'Bottom Border';
    mostWhiteBorderPixels = [find(bottomBorder)', repmat(size(segmentedMask,1), bottomBorderCount, 1)];
elseif maxIndex == 3
    mostWhiteBorder = 'Left Border';
    mostWhiteBorderPixels = [repmat(1, leftBorderCount, 1), find(leftBorder)'];
else
    mostWhiteBorder = 'Right Border';
    mostWhiteBorderPixels = [repmat(size(segmentedMask,2), rightBorderCount, 1), find(rightBorder)'];
end

% Determine if any border pixel is white
if sum(tumorPerimeter(:)) == 0
    shadow = 0;
else
    shadow = 1;
end
end