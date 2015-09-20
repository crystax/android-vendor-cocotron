/* Copyright (c) 2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import <CoreGraphics/CGColorSpace.h>
#import <Onyx2D/O2ColorSpace.h>

CGColorSpaceRef CGColorSpaceRetain(CGColorSpaceRef colorSpace) {
   return (CGColorSpaceRef)O2ColorSpaceRetain((O2ColorSpaceRef)colorSpace);
}

void CGColorSpaceRelease(CGColorSpaceRef colorSpace) {
   O2ColorSpaceRelease((O2ColorSpaceRef)colorSpace);
}

CGColorSpaceRef CGColorSpaceCreateDeviceRGB() {
   return (CGColorSpaceRef)O2ColorSpaceCreateDeviceRGB();
}

CGColorSpaceRef CGColorSpaceCreateDeviceGray() {
   return (CGColorSpaceRef)O2ColorSpaceCreateDeviceGray();
}

CGColorSpaceRef CGColorSpaceCreateDeviceCMYK() {
   return (CGColorSpaceRef)O2ColorSpaceCreateDeviceCMYK();
}

CGColorSpaceRef CGColorSpaceCreatePattern(CGColorSpaceRef baseSpace) {
   return (CGColorSpaceRef)O2ColorSpaceCreatePattern((O2ColorSpaceRef)baseSpace);
}

CGColorSpaceModel CGColorSpaceGetModel(CGColorSpaceRef self) {
   return (CGColorSpaceModel)O2ColorSpaceGetModel((O2ColorSpaceRef)self);
}

size_t CGColorSpaceGetNumberOfComponents(CGColorSpaceRef self) {
   return O2ColorSpaceGetNumberOfComponents((O2ColorSpaceRef)self);
}
