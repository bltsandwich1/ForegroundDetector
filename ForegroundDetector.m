## Copyright (C) 2018 John Moosemiller
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} ForegroundDetector (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: John Moosemiller
## Created: 2018-09-01


function [ForegroundMask,Composite,SD,FrameCount] = ForegroundDetector (Frame, Sigma, Composite, SD, FrameCount, NumTrainingFrames)
disp(FrameCount)
if FrameCount < NumTrainingFrames
    Composite(:,:,FrameCount) = Frame;
    FrameCount=FrameCount+1;
    ForegroundMask=[1];
    SD=[];
elseif FrameCount == NumTrainingFrames
    Composite(:,:,FrameCount) = Frame;
    ForegroundMask=[1];
    SD = std(Composite, 0, 3);
    FrameCount=FrameCount+1;
elseif FrameCount > NumTrainingFrames
    PixelDiff = abs(sum(Composite,3)/NumTrainingFrames-Frame);
    ForegroundMask=PixelDiff>SD*Sigma;
    Composite(:,:,1:NumTrainingFrames-1)=Composite(:,:,2:NumTrainingFrames);
    Composite(:,:,NumTrainingFrames) = Frame;
    SD = std(Composite, 0, 3);
    FrameCount=FrameCount+1;
endif
endfunction
