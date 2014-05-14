function humanMotionDetection(hMainFigure,hFrame)
% this function will detect the moving human beings from each frame
delete(timerfindall);
config = load('config.mat');
alarm1 = load('alarm1.mat');
[yH,fH] =  audioread('alarm2.mp3');
[yC,fC] = audioread('alarm3.mp3');
motionAlarm = alarm1.alarm1;
humanAlarm = audioplayer(yH,fH);
cameraAlarm = audioplayer(yC,fC);
num = numel(config.config.names);
ipcam = cell(1,num);
alpha = 0.005;
camNo = 1;
motionThresh = 25;
minMotionArea = 200;
motionFlag = 0;
checkHumanFrameNum = 0;
blobDetector = vision.BlobAnalysis('CentroidOutputPort', false, 'AreaOutputPort',true,...
    'BoundingBoxOutputPort', true, ...
    'MinimumBlobAreaSource', 'Property');
waitH = waitbar(0,'Reading IP cam and Initializing cam Objects');
% initialization of camera objects
for camNo = 1:num
    cap = cv.VideoCapture(char(config.config.ip(camNo)));
    waitbar(camNo./num)
    pause(1);
    frame = cap.read();
    [r,c,d] = size(frame);
    camName = config.config.names{camNo};
    ipAddr = config.config.ip(camNo);
    roiMask = config.config.mask{camNo};
    if isempty(roiMask) == 1
        minR = 1;maxR = r;
        minC = 1;maxC = c;
    else
        [row,col] = find(roiMask);
        minR = min(row);maxR = max(row);minC = min(col);maxC = max(col);
    end
    roi = [minR maxR minC maxC];
    backgnd = frame(minR:maxR,minC:maxC,1:3);
    ipcam{camNo} = ipcamera(cap,camName,ipAddr,roi,alpha,backgnd,blobDetector,...
        motionAlarm,humanAlarm,cameraAlarm,checkHumanFrameNum,motionThresh,minMotionArea,motionFlag);
end
close(waitH)
clear camNo;
% initialization of timer objects
detectionTimer = timer;
detectionTimer.TimerFcn = @getHumanFromFrames;
detectionTimer.Period = 0.01;
detectionTimer.ExecutionMode = 'fixedSpacing';
start(detectionTimer)
camNo = 1;
% timer function call back
    function getHumanFromFrames(varargin)
        frame = ipcam{camNo}.capture_obj.read();
        if isempty(frame)
            callAlarm(ipcam{camNo}.cameraAlarm)
            errordlg('check the camera connection')
            pause(0.1)
        end
        ipcam{camNo}.frame = frame(ipcam{camNo}.roi(1):ipcam{camNo}.roi(2),ipcam{camNo}.roi(3):ipcam{camNo}.roi(4),1:3);
        ipcam{camNo} = foregroundDetector(ipcam{camNo});
        
        ipcam{camNo} = getBiggestBlob(ipcam{camNo});
        set(hMainFigure,'CurrentAxes',hFrame)
        imshow(ipcam{camNo}.frame)
        axis tight
        axis off
        
        if ipcam{camNo}.motionFlag == 1
            ipcam{camNo}.checkHumanFrameNum
            Humanbbox = cv.getHuman(uint8(ipcam{camNo}.motionFrameROI));
            
            if isempty(Humanbbox) == 0
                
                ipcam{camNo}.checkHumanFrameNum = ipcam{camNo}.checkHumanFrameNum+1;
                cords = ipcam{camNo}.ROIcords;
                cordNor = round(double(Humanbbox{1})./double(cords(5)));
                cordMod = [cordNor(1)+cords(3)-1 cordNor(2)+cords(1)-1 cordNor(3) cordNor(4)];
                set(hMainFigure,'CurrentAxes',hFrame)
                imrect(hFrame,cordMod);
                drawnow
                if ipcam{camNo}.checkHumanFrameNum > 1
                    alarm1.Running = 'off';
                    disp('humanalarm')
                    callAlarm(humanAlarm)
                    
                end
            else
                ipcam{camNo}.checkHumanFrameNum = 0;
            end
        else
            camNo = camNo+1;
            if camNo > num
                camNo = 1;
            end
        end
    end
end

