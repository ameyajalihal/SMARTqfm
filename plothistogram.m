clc;
i = imread('/Users/ameya/Documents/SMARTCenter_guide_images/Nuclei_Ruusuvuori.tif','Index',1);
[m,n,o] = size(i)
temp = reshape(i(:,:,1),1,m*n);
figure(1)
subplot(121)
imshow(i);
t=title('\fontsize{12}a. Ruusuvuori Nuclei');
set(t, 'horizontalAlignment', 'right')
axis square;
subplot(122)
[h,n] = histcounts(temp,'BinWidth',5);
bar(n(1:end-1),h)
xlabel('Intensity, A.U.');
ylabel('Number of pixels');
t=title('\fontsize{12}b. Histogram of pixel intensities');
set(t, 'horizontalAlignment', 'right');
axis square;

figure(2)
subplot(121)
imshow(i(:,:,1)>70)
t=title('\fontsize{12}a. Binary image after threshold');
set(t, 'horizontalAlignment', 'center');
gb = imfilter(i(:,:,1),fspecial('gaussian',10,5),'replicate');
subplot(122)
imshow(gb)
t=title('\fontsize{12}b. Thresholding after Gaussian filter');
set(t, 'horizontalAlignment', 'center');

e1 = edge(i(:,:,1),'sobel');
e2 = edge(i(:,:,1),'log');
figure(3)
subplot(121)
imshow(e1)
t=title('\fontsize{12}a. Edge detected using "Sobel" method');
set(t, 'horizontalAlignment', 'center');
subplot(122)
imshow(e2)
t=title('\fontsize{12}b. Edge detected using "LoG" method');
set(t, 'horizontalAlignment', 'center');

figure(4)
subplot(121)

thresh = multithresh(gb);
bin = gb>thresh;
BW = bwlabel(bin);
D = -bwdist(~BW);
D(~BW) = -Inf;
L = watershed(D);
imshow(label2rgb(L,'jet','w'))

% imshow(label2rgb(lab))
t=title('\fontsize{12}a. Labeled blobs');
set(t, 'horizontalAlignment', 'center');

props = regionprops(L,'Area','Circularity');
for j = 1:length(props)
    areas(j) = props(j).Area;
    circs(j)= props(j).Circularity;
end
subplot(122)
scatter(areas,circs);
axis square;
xlim([0 1500]);
ylim([0 1.2])
xlabel('Nuclei Areas, px^2');
ylabel('Nuclei Circularity');
t=title('\fontsize{12}b. Scatter plot of blob properties');
set(t, 'horizontalAlignment', 'center');
