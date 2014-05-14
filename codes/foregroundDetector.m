function camObj =  foregroundDetector(camObj)
% this will detect the foreground using the background subtraction method.
% we are using recrussive average method for finding the foreground
current = double(camObj.frame);
backgnd = double(camObj.background);
fg = sum(abs(current - backgnd),3)./3;
backgroundUpdate = (camObj.alpha.*double(camObj.frame) + (1-camObj.alpha).* double(camObj.background));
camObj.background = backgroundUpdate;
camObj.fgmask = fg;
end