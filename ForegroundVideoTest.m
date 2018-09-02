clc
clear
close all
Frame=[1]
Sigma = 8
FrameCount = 1
SD=[]
Composite=[]
NumTrainingFrames=20
figure(1)
for F = 1:256
  FrameP=Frame;
  Frame = aviread('SC.avi',60*F);
  FrameRed = Frame(:,:,1);
  [ForegroundMask,Composite,SD,FrameCount] = ForegroundDetector (FrameRed, Sigma, Composite, SD, FrameCount, NumTrainingFrames);
  figure(1)
  imshow(ForegroundMask);
  figure(2)
  imshow(FrameRed)
  NumDiffs = sum(sum(ForegroundMask))
  pause(2)
  FrameSame = sum(sum(sum(FrameP~=Frame)))
endfor
