# ForegroundDetector
Octave Implementation for some of the functionality of vision.ForegroundDetector

## About
This is an implementation of a [Running Gaussian Average](https://en.wikipedia.org/wiki/Foreground_detection#Running_Gaussian_average) foreground detection method. 

Variables:

* `Sigma` = number of standard deviations that a pixel has to differ by in order to be considered in the foreground
  * `Sigma` can be changed at any time
* `NumTrainingFrames` = the number of frames that the function will be trained on 
  * Also the number of layers in the composite image
    * Will eventually disconnect these, but in reality this isn't much of a limit.
* `FrameCount` = integer that counts the current frame number
* `SD` = calculated SD for each pixel
* `Composite` = an MxNxL variable where L is `NumTrainingFrames`
* `Frame` = the image, MxNx1, that is the next frame in your "video"

## Structure

- If the `FrameCount < NumTrainingFrames`
  - Add the `Frame` to the `Composite`.
  - `FrameCount+1`
- If the `FrameCount = NumTrainingFrames`
  - Add the `Frame` to the `Composite`.
  - Calculate the `SD` for each pixel
  - `FrameCount+1`
- If the `FrameCount > NumTrainingFrames`
  - Calculate the `PixelDiff` for each pixel
    - If the `PixelDiff > SD*Sigma`
      - Mark pixel is in foreground (logical TRUE)
      - Add `Frame` to the `Composite`
      - Remove the oldest frame the `Composite`
      - Recalculate the `SD` for each pixel
    - Else
      - Add `Frame` to the `Composite`
      - Remove the oldest frame the `Composite`
      - Recalculate the `SD` for the cell
  - `FrameCount+1`


## Usage

```Matlab
clc
clear
close all
%initialize variables
Frame=[1]
Sigma = 8
FrameCount = 1
SD=[]
Composite=[] 
NumTrainingFrames=20 %number of frames in your "buffer" (beware of RAM)

___loop %can be for or while

%%%%%%%%%%%%%%
%Frame = ... % Use whatever method you use to obtain a frame
%%%%%%%%%%%%%%

[ForegroundMask,Composite,SD,FrameCount] = ForegroundDetector (Frame, Sigma, Composite, SD, FrameCount, NumTrainingFrames)

end___loop %end the loop

```

### Example Code and Benchamarking
[This video](https://www.youtube.com/watch?v=4i_GFrlaStQ) is some decent quality security cam footage. I've used this as 'SC.avi' in the [ForegroundVideoTest.m](ForegroundVideoTest.m) example. I am not sure *why* but the frames from the avi reader do not pull correctly, so YMMV with the `readavi` code. 

For testing speed it's much more convenient to make up your own images. I've done this in [ForegroundTester.m](ForegroundTester.m).

```
%Processor Core i5 - 8600K @3.7GHz
% 1920 x 1080 simulated frames, pulling the 52nd frame below
% NumTrainingFrames=10
ForegroundDetectTime =  0.29223
FrameGenTime =  0.044679
```
1080p video at ~3FPS seems reasonable for non-multithreaded performance. Will upate for multi-core functionality in the future.

Note that `NumTrainingFrames` and the frame resolution are the 2 largest drivers for performance. RAM becomes a concern if there are too many frames in the buffer, using big arrays might be the solution and may be implemented in the future.

Performace between MATLAB and octave is similar (FWIW Octave is slightly faster) as there are no loops or built-in functions that cause a big time delta.

### Notes on usage

Passing variables in this manner is understandibly slow, and will be eliminated in future versions, however this is easiest for tracking down issues for the time being. The user also has to define all of the input variabels as there are no defaults set. This will also change in future implementations.

## Known Issues

- There is no decoupling of the number of training frames and the number of number of frames that contribute to your composite.
- Passing Variables to and from the workspace is inefficient as noted above
- `readavi()` is broken in octave (it's possible this is a windows error), feeding images directly works fine.
