function[regi]=Face_Detection()
web=webcam();
for j=1:1000
    %Get Snapshot
    img=snapshot(web);
    %Detect face using Viola-Jones detector algorithm
    faceDetector = vision.CascadeObjectDetector();
    %Get the bounding box of face
    boundingbox = faceDetector(img);
    %Tag the face in the image
    face = insertObjectAnnotation(img,'rectangle',boundingbox(:,:),'Face');
    if isempty(boundingbox)==0   %If face is detected
        %Get the first and only bounding box
        i=1;
        %Get the co-ordinates and size of bounding box
        x=boundingbox(i,1);
        y=boundingbox(i,2);
        w=boundingbox(i,3);
        h=boundingbox(i,4);
        %Register the face
        regi=img(y:y+w,x:x+h,:);
        regi=rgb2gray(regi);
        %Resize and crop to required size
        regi=imresize(regi,[112 112]);
        regi=regi(:,10:101);
        %Show the detected face in the original image
        imshow(face)
        %Break if face has been recognised
        break;
    end
end
%figure; imshow(fac); title('Detected face');
end

