function getIntrusionParameters(hMainFigure,hFrame,logo)
% this function will help to initialize the intrusion parameters such as
% camera configuration and roi selection.
% 

% initialization of the variables
hpopup = 0;

camid = 0;
roiMask = [];
ip = {};
nameofcam = {};
config.names = {};
config.ip = {};
config.mask = {};


hMainFigure2 = figure('position',[350 300 600 300 ],'MenuBar','none','name','Configure Intrusion Detection','NumberTitle','off','Resize','off');
% uicontrol('Style','text','Units','normalized','Position',[0.1 0.78 0.5 0.08],...
%     'String','Select the camera configuration file','FontSize',12);
hLogo = axes('Parent',hMainFigure2,'Units', 'normalized','Position',[0.02 0.85 0.15 0.15],'Visible','off');
set(hMainFigure2,'CurrentAxes',hLogo)
% logo = imread('logo_drishtiman.png');
imshow(logo);
uicontrol(... % Button for Exit logging selection
    'Style','pushbutton','Units','normalized','Parent', hMainFigure2, ...
    'Position',[0.05 0.1 0.3 0.1],'String','Select Config. File',...
    'Callback',@browseButtonCallback);
uicontrol(... % Button for Exit logging selection
    'Style','pushbutton','Units','normalized','Parent', hMainFigure2, ...
    'Position',[0.63 0.6 0.3 0.1],'String','Select ROI',...
    'Callback',@selectRoiButtonCallback);

uicontrol(... % Button for Exit logging selection
    'Style','pushbutton','Units','normalized','Parent', hMainFigure2, ...
    'Position',[0.7 0.1 0.16 0.1],'String','Update',...
    'Callback',@updateButtonCallBack);
 
           
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

    function browseButtonCallback(hObject, eventdata)
        % Callback function run when the Open menu item is selected
        [file,path] = uigetfile('*.txt');
        if ~isequal(file, 0)
            fileID = fopen(strcat(path,file));
            camid = textscan(fileID,'%s %s');
            ip = camid{1};
            nameofcam = camid{2};
            ind = strcmp(nameofcam,'');
            if isempty(ind) == 1                
                nameofcam(ind) = ip{ind};
            end
           
            config.names = nameofcam;
            config.ip = ip;
            hpopup = uicontrol('Style','popupmenu',...
                'String',char(nameofcam),...
                'Units','normalized','Parent',hMainFigure2,'Position',[0.63 0.3 0.18 0.2]);
        end
    end


    function selectRoiButtonCallback(hObject, eventdata)
        % Callback function run when the Open menu item is selected
        
        val = get(hpopup,'Value');
        h = waitbar(0,['Reading frame from the camera' num2str(val)]);
       
        cap = cv.VideoCapture(char(ip{val}));%
        for i = 1:5
            waitbar(5./i);
            pause(2);
        end
        close(h);
        frame = cap.read();
        hROI = axes('Parent',hMainFigure2,'Units', 'normalized','Position',[0.008 0.3 0.60 0.6],'Visible','on');
        set(hMainFigure2,'CurrentAxes',hROI)
        imshow(frame);
        roiMask = roipoly(frame);
        config.mask{val} = roiMask;
        pause(0.3);
        set(hMainFigure2,'CurrentAxes',hROI)
        imshow( uint8(double(frame).*(repmat(roiMask,[1 1 3]))));
        
    end


    function updateButtonCallBack(hObject,eventdata)
        save('config.mat','config')
        close(hMainFigure2)
        humanMotionDetection(hMainFigure,hFrame)
        
        
    end

end
