classdef ipcamera
    properties (SetAccess=private)
        capture_obj
        name
        ip_addr
        roi
        alpha
        blobDetector
        motionAlarm
        humanAlarm
        cameraAlarm
        motionThresh
        minMotionArea
    end
    properties (SetAccess = public)
        frame
        background
        fgmask
        motionFlag
        motionFrameROI
        checkHumanFrameNum
        ROIcords
    end
    methods
        function obj = ipcamera(capture_obj,name,ip_addr,roi,alpha,backgnd,blobDetector,...
                motionAlarm,humanAlarm,cameraAlarm,checkHumanFrameNum,motionThresh,minMotionArea,...
                motionFlag)
            obj.capture_obj = capture_obj;
            obj.name = name;
            obj.ip_addr = ip_addr;
            obj.roi = roi;
            obj.alpha = alpha;
            obj.background = backgnd;
            obj.blobDetector = blobDetector;
            obj.motionAlarm = motionAlarm;
            obj.humanAlarm = humanAlarm;
            obj.cameraAlarm = cameraAlarm;
            obj.checkHumanFrameNum = checkHumanFrameNum;
            obj.motionThresh = motionThresh;
            obj.minMotionArea = minMotionArea;
            obj.motionFlag = motionFlag;
        end
    end
end





