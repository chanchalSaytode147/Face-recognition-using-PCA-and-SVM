%Feature extraction using PCA 
%Classification using SVM
clc
clearvars
tic
facedb=imageSet('C:\Users\Chanchal Saytode\Desktop\Projects\DFD\matlab\faces94\faces94','recursive');
disp('Reading the training database');
%Read all the images
[image_vect,class_vect,height,width]=Training();
M=length(class_vect);
disp('Processing for PCA');
%Calculate mean of each column and stored as row vector
mean_i=mean(image_vect,1);
%Convert image vector into double from unit8 and subtract each image from mean
Xm = double(image_vect)-repmat (mean_i , size(image_vect,1),1) ;
disp('Calculating right singular vectors and singular values...');
% Calculate Right Singular Vectors and Singular Values
[U,S,V]=svd(Xm);
% Singular Values matrix will have at most M-1 non zero values
S=S(:,1:M-1);
% Choosing number of principal components to retain 99% variance
totalS=sum(diag(S));
varS=0;
for i= 1:M-1
    varS=varS+S(i,i);
    ratio=varS/totalS;
    if ratio>=0.99 
        disp(i);
        break;
    end
end
S=S(:,1:i);
V=V(:,1:i);
%Training Data
train=Xm*V;

toc
disp('Training/Loading Machine Learning Model...');
tic
%Use multi class SVM Classifier for making Machine Learning Model
mdl=fitcecoc(train,'class_vect');
toc

%% Live Recognition of Face
tic
disp('Capturing Face');
%Capture Query image from camera
imgcam=Face_Detection();
%Store it temporarily
temp=imgcam;
%Reshape to row vector
imgcam=reshape(imgcam,1,height*width);
%Convert to double for manipulations
imgcam=double(imgcam);
%Calculate difference from mean
imgcam=imgcam-mean_i;
%Reprojection on Principal Component Vector Space
projection=double(imgcam)*V;
disp('Predicting a potential match');
pre=predict(mdl,projection);
%Show the query and matched faces
figure;
temp2=read(facedb(pre),1);
subplot(1,2,1);
imshow(temp);
title('Query Face');
subplot(1,2,2);
imshow(temp2);
title('Recognized Face');
toc
disp('End of program');