clc
clear
close

Sigma = 1 % the higher this is set the fewer pixels will pass.
FrameCount = 1
SD=[]
Composite=[]
NumTrainingFrames=10 %arbitrary, the higher this is the more data will contribute to your normal distribution and you'll get more predictable results
figure(1)
for F = 1:256 % number of frames is arbitrary, just has to be > NumTrainingFrames
  
  tic
  Frame = randi([0,255],1080,1920);
  FrameGenTime = toc
  tic
  [ForegroundMask,Composite,SD,FrameCount] = ForegroundDetector (Frame, Sigma, Composite, SD, FrameCount, NumTrainingFrames);
  ForegroundDetectTime = toc                                          

  imshow(ForegroundMask);
  pause(.1);


endfor
