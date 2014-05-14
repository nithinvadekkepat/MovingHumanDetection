function humanIntrusionDetectionGui()
close all;
hMainFigure = figure('position',[350 50 400 300 ],'MenuBar','none','name',...
    'Human Intrusion Detector','NumberTitle','off','Resize','off');
hLogo = axes('Parent',hMainFigure,'Units', 'normalized','Position',[0.02 0.85 0.15 0.15],'Visible','off');
uicontrol('Style','pushbutton','Parent', hMainFigure,'Units','normalized',...
    'HandleVisibility','callback', ...
    'Position',[0.05 0.1 0.4 0.1],...
    'String','Configure Camera',...
    'Callback', @configureButtonCallBack);
uicontrol('Style','pushbutton','Parent',hMainFigure,'units','normalized','HandleVisibility','callback',...
    'Position',[0.5 0.1 0.4 0.1],'String','Exit','Callback',@ExitButtonCallBack);
hFrame = axes('Parent',hMainFigure,'Units', 'normalized','Position',[0.05 0.4 0.40 0.4],'Visible','off');
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
 file = dir('config.mat');
 set(hMainFigure,'CurrentAxes',hLogo)
 logo = imread('logo_drishtiman.png');
 imshow(logo);
 axis tight
 axis off
if isempty(file) == 1   
   hString =  uicontrol('Style','text','Parent',hMainFigure,'Units','normalized','Position',[0.3 0.6 0.45 0.05],...
    'String','Please Configure the Camera Set Up','FontSize',24     );
else
    hString = 0;
    humanMotionDetection(hMainFigure,hFrame)  
end

    function  configureButtonCallBack(src, eventdata)
        if isempty(hString) == 0
        delete(hString)        
        end
        getIntrusionParameters(hMainFigure,hFrame,logo);
        
        
  end
    function ExitButtonCallBack(src, eventdata)
        clear
        delete(timerfindall)
        close(gcf)
    end

end