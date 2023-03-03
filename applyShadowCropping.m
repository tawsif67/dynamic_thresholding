function maskedimage = applyShadowCropping(img, mostWhiteBorderPixels, threshold)
    % This function applies shadow cropping to the input image.
    % Inputs:
    %   img: grayscale input image
    %   mostWhiteBorderPixels: a 2xN matrix containing the row and column indices
    %       of the pixels on the tumor border with the highest intensity values
    %   threshold: a vector of threshold values used for image segmentation
    % Output:
    %   maskedimage: the input image with the shadow cropped out and replaced
    %       with white pixels

    rows = size(img, 1);
    columns = size(img, 2);
        xaxis = mostWhiteBorderPixels(:,1);      
        yaxis = mostWhiteBorderPixels(:,2);
    finalwhite = zeros(1, length(xaxis));

    % Loop through each pixel on the tumor border with the highest intensity values
    for n = 1:length(xaxis)
        row = yaxis(n);
        column = xaxis(n);
        %fprintf("%d %d ", row, column);
        % Get the gray level of the point they clicked on.
        gray_lev = img(row, column);
        tol = 10;

        % Construct a binary image within the gray level tolerance
        % of where they clicked.
        Gray_lev_low = gray_lev - tol;
        Gray_lev_high = gray_lev + tol;
        binaryImage = img >= Gray_lev_low & img <= Gray_lev_high;
        finalwhite(n) = sum(binaryImage(:));

        % Get a marker image to reconstruct just the connected region and not all the other disconnected regions.
        binMarkerImg = false(rows, columns);
        binMarkerImg(row, column) = true;
        binMarkerImg = im2bw(binMarkerImg,threshold);
        resultImg = imreconstruct(binMarkerImg, binaryImage);

        % Get the masked image - the original image in the region.
        maskedImage = zeros(rows, columns, 'uint8');
        maskedImage(resultImg) = img(resultImg);
    end

    % Find the ideal shadow cropping by selecting the pixel on the tumor border
    % with the max number of white pixels in the cropped region.
    maxwhite = max(finalwhite);
    [val,idx] = max(abs(finalwhite));
    ind = min(idx);
    row = yaxis(ind);
    column = xaxis(ind);

    % Apply the Seed Region Growing Method again to get the masked image
    gray_lev = img(row, column);
    tol = 10;
    Gray_lev_low = gray_lev - tol;
    Gray_lev_high = gray_lev + tol;
    binaryImage = img >= Gray_lev_low & img <= Gray_lev_high;
    binMarkerImg = false(rows, columns);
    binMarkerImg(row, column) = true;
    resultImg = imreconstruct(binMarkerImg, binaryImage);
    iteration = 100;
    img3=activecontour(img,resultImg,iteration,'Chan-Vese');

    % Apply the shadow as white layer in the original image
    maskedimage = imoverlay(img, img3, 'white');
end