function camObj = getBiggestBlob(camObj)
% finding the biggest blob from the foreground
fgmask = camObj.fgmask;
[m,n] = size(fgmask);
fgmaskTh = fgmask > camObj.motionThresh;
se = strel('rectangle',[15 5]);
fgmaskTh = imopen(fgmaskTh,se);
[area,bbox] = step(camObj.blobDetector,fgmaskTh);
[maxVal,ind] = max(area);
if maxVal > camObj.minMotionArea
    camObj.motionFlag = 1;  
    bboxImp = bbox(ind,1:end);
    x1 = max(1,bboxImp(1)-100);
    x2 = min(n,bboxImp(1)+bboxImp(3)+100);
    y1 = max(1,bboxImp(2)-100);
    y2 = min(m,bboxImp(2)+bboxImp(4)+100);
    g = fgmask(y1:y2,x1:x2);
    s =1 ;
    if bboxImp(3) < 70 && bboxImp(4) < 130
        g = imresize(g,2);
        s = 2;
    end    
    camObj.motionFrameROI = g;
    camObj.ROIcords = [y1,y2,x1,x2,s];
else
    camObj.motionFlag = 0;
end
end