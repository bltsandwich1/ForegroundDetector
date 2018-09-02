# ForegroundDetector
Octave Implementation for some of the functionality of vision.ForegroundDetector

## About
This is an implementation of a naiive foreground detection method.

Variables:

* Sigma = number of standard deviations that a pixel has to differ by in order to be considered in the foreground
* NumTrainingFrames = the number of frames that the function will be trained on, also the number of layers in the composite image
* FrameCount = integer that counts the current frame number
* SD = calculated SD for each pixel
* Composite = an MxNxL variable where L is NumTrainingFrames

## Structure

- If the FrameCount < NumTrainingFrames
  - Add the frame to the composite.
  - FrameCount+1
- If the FrameCount = NumTrainingFrames
  - Add the frame to the composite.
  - Calculate the SD for each pixel
  - FrameCount+1
- If the FrameCount > NumTrainingFrames
  - Calculate the PixelDiff for each pixel
    - If the PixelDiff > SD*Sigma
      - Mark pixel is in foreground (logical TRUE)
      - Add frame to the composite
      - Remove the oldest frame the composite
      - Recalculate the SD for the cell
    - Else
      - Add frame to the composite
      - Remove the oldest frame the composite
      - Recalculate the SD for the cell
  - FrameCount+1


## Usage

[ForegroundMask,Composite,SD,FrameCount] = ForegroundDetector (FrameRed, Sigma, Composite, SD, FrameCount, NumTrainingFrames)

### Notes on usage

Passing variables in this manner is understandibly slow, and will be eliminated in future versions, however this is easiest for tracking down issues for the time being. The user also has to define all of the input variabels as there are no defaults set. This will also change in future implementations.

## Known Issues

- There is no decoupling of the number of training frames and the number of number of frames that contribute to your composite.
- Passing Variables to and from the workspace is inefficient as noted above
- readavi() is broken in octave, feeding images directly works fine.
