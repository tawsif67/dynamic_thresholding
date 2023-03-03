function plotFigures(img,maskedimage,imgWithBorder, ac_img,mask, threshold, shadow)
    figure
    subplot(3,3,1)
    imshow(img)
    title('Original Image')
    
    if shadow == 1
        subplot(3,3,2)
        imshow(maskedimage)
        title('Speckles Cropped')
    end
    
    subplot(3,3,3)
    imshow(imgWithBorder)
    title('Segmented Tumor')
    
    subplot(3,3,4)
    imshow(ac_img)
    title('Segmented Mask')
    
    subplot(3,3,6)
    imshow(mask)
    title('Reference Mask')
    
    subplot(3,3,7)
    similarity = dice(ac_img, mask);
    imshowpair(ac_img, mask);
    title(['Dice Index = ' num2str(similarity)]);
    
    subplot(3,3,8)
    bf_sc = bfscore(ac_img, mask);
    imshowpair(ac_img, mask);
    title(['BF Score = ' num2str(bf_sc)])
    
    subplot(3,3,9)
    jac = jaccard(ac_img, mask);
    imshowpair(ac_img, mask);
    title(['Jaccard Index = ' num2str(jac)])
    
    % Print threshold value on top middle of figure
    annotation('textbox', [0.32, 0.95, 0.4, 0.05], 'String', ['Threshold = ' num2str(threshold)], 'HorizontalAlignment', 'center', 'EdgeColor', 'none')
end