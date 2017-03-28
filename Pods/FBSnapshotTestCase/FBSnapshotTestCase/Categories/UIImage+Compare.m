//
//  Created by Gabriel Handford on 3/1/09.
//  Copyright 2009-2013. All rights reserved.
//  Created by John Boiles on 10/20/11.
//  Copyright (c) 2011. All rights reserved
//  Modified by Felix Schulze on 2/11/13.
//  Copyright 2013. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <FBSnapshotTestCase/UIImage+Compare.h>

// This makes debugging much more fun
typedef union {
  uint32_t raw;
  unsigned char bytes[4];
  struct {
    char red;
    char green;
    char blue;
    char alpha;
  } __attribute__ ((packed)) pixels;
} FBComparePixel;

@implementation UIImage (Compare)
  
- (BOOL)fb_compareWithImage:(UIImage *)image tolerance:(Tolerance *)tolerance
  {
    NSAssert(CGSizeEqualToSize(self.size, image.size), @"Images must be same size.");
    
    CGSize referenceImageSize = CGSizeMake(CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
    CGSize imageSize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
    
    // The images have the equal size, so we could use the smallest amount of bytes because of byte padding
    size_t minBytesPerRow = MIN(CGImageGetBytesPerRow(self.CGImage), CGImageGetBytesPerRow(image.CGImage));
    size_t referenceImageSizeBytes = referenceImageSize.height * minBytesPerRow;
    void *referenceImagePixels = calloc(1, referenceImageSizeBytes);
    void *imagePixels = calloc(1, referenceImageSizeBytes);
    
    if (!referenceImagePixels || !imagePixels) {
      free(referenceImagePixels);
      free(imagePixels);
      return NO;
    }
    
    CGContextRef referenceImageContext = CGBitmapContextCreate(referenceImagePixels,
                                                               referenceImageSize.width,
                                                               referenceImageSize.height,
                                                               CGImageGetBitsPerComponent(self.CGImage),
                                                               minBytesPerRow,
                                                               CGImageGetColorSpace(self.CGImage),
                                                               (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                                               );
    CGContextRef imageContext = CGBitmapContextCreate(imagePixels,
                                                      imageSize.width,
                                                      imageSize.height,
                                                      CGImageGetBitsPerComponent(image.CGImage),
                                                      minBytesPerRow,
                                                      CGImageGetColorSpace(image.CGImage),
                                                      (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                                      );
    
    if (!referenceImageContext || !imageContext) {
      CGContextRelease(referenceImageContext);
      CGContextRelease(imageContext);
      free(referenceImagePixels);
      free(imagePixels);
      return NO;
    }
    
    CGContextDrawImage(referenceImageContext, CGRectMake(0, 0, referenceImageSize.width, referenceImageSize.height), self.CGImage);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, imageSize.width, imageSize.height), image.CGImage);
    
    CGContextRelease(referenceImageContext);
    CGContextRelease(imageContext);
    
    BOOL imageEqual = YES;
    
    // Do a fast compare if we can
      // Go through each pixel in turn and see if it is different
      const NSInteger pixelCount = referenceImageSize.width * referenceImageSize.height;
      
      FBComparePixel *p0_ref = referenceImagePixels;
      FBComparePixel *p0 = imagePixels;
      
      NSInteger numDiffPixels = 0;
      
      for (int n = 0; n < pixelCount; ++n) {
        if (tolerance.useGridTolerance) {
          NSArray *pixeis = [self getPixel:p0_ref index:n width:referenceImageSize.width height:referenceImageSize.height];
          
          for (int j = 0; j < pixeis.count; j++) {
            FBComparePixel *p1 = p0_ref + n;
            FBComparePixel *p2 = p0 + [pixeis[j] intValue];
            
            imageEqual = [self fb_comparePixel:p1 withPixel:p2 colorTolerance:tolerance.colorTolerance];
            
            if (imageEqual)
            break;
          }
        } else {
          FBComparePixel *p1 = p0_ref + n;
          FBComparePixel *p2 = p0 + n;
          
          imageEqual = [self fb_comparePixel:p1 withPixel:p2 colorTolerance:tolerance.colorTolerance];
        }
        
        
        if (!imageEqual) {
          numDiffPixels ++;
          
          CGFloat percent = (CGFloat)numDiffPixels / pixelCount;
          if (percent > tolerance.pixelPercent) {
            imageEqual = NO;
            break;
          }
        }
      }
    
    free(referenceImagePixels);
    free(imagePixels);
    
    return imageEqual;
  }
  
- (NSArray *) getPixel:(FBComparePixel *)p0 index:(long) index width:(CGFloat) width height: (CGFloat) height{
  long py = floor(index/width);
  long px = index % (long) width;
  
  NSMutableArray *pixels = [[NSMutableArray alloc] initWithObjects:@(index), nil];
  
  if (px > 0)
  [pixels addObject:[self getIndex:px-1 py:py width:width]];
  
  if (px > 0 && py > 0)
  [pixels addObject:[self getIndex:px-1 py:py-1 width:width]];
  
  if (px > 0 && py < height)
  [pixels addObject:[self getIndex:px-1 py:py+1 width:width]];
  
  if (px < width)
  [pixels addObject:[self getIndex:px+1 py:py width:width]];
  
  if (px < width && py >0)
  [pixels addObject:[self getIndex:px+1 py:py-1 width:width]];
  
  if (px < width && py < height)
  [pixels addObject:[self getIndex:px+1 py:py+1 width:width]];
  
  if (py > 0)
  [pixels addObject:[self getIndex:px py:py-1 width:width]];
  
  if (py < height)
  [pixels addObject:[self getIndex:px py:py+1 width:width]];
  
  return pixels;
}
  
- (NSNumber *) getIndex:(long) px py:(long) py width: (CGFloat) width {
  return @(py*width + px);
}
  
- (BOOL)fb_comparePixel:(FBComparePixel *)p1 withPixel: (FBComparePixel *)p2 colorTolerance: (CGFloat)colorTolerance {
  if (p1->raw != p2->raw) {
    
    int redDiff = (unsigned char)p1->pixels.red - (unsigned char)p2->pixels.red;
    int greenDiff = (unsigned char)p1->pixels.green - (unsigned char)p2->pixels.green;
    int blueDiff = (unsigned char)p1->pixels.blue - (unsigned char)p2->pixels.blue;
    int alphaDiff = (unsigned char)p1->pixels.alpha - (unsigned char)p2->pixels.alpha;
    
    if(abs(redDiff) > colorTolerance ||
       abs(greenDiff) > colorTolerance ||
       abs(blueDiff) > colorTolerance ||
       abs(alphaDiff) > colorTolerance) {
      return NO;
    }
  }
  
  return YES;
}
  
@end
