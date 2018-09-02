%Foreground Tester
clc
clear
close

Sigma = 2
FrameCount = 1
SD=[]
Composite=[]
NumTrainingFrames=10
figure(1)
for F = 1:256
  Frame = randi([0,255],3,4);
  [ForegroundMask,Composite,SD,FrameCount] = ForegroundDetector (Frame, Sigma, Composite, SD, FrameCount, NumTrainingFrames);
  imshow(ForegroundMask);
  pause(.5)
endfor
