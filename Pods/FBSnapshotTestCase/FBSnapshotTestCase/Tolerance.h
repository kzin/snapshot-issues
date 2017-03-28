//
//  Tolerance.h
//  FBSnapshotTestCase
//
//  Created by Bruno Mazzo on 24/03/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Tolerance : NSObject
  
@property(nonatomic, assign, readwrite) CGFloat pixelPercent;
@property(nonatomic, assign, readwrite) NSInteger colorTolerance;
@property(nonatomic, assign, readwrite) BOOL useGridTolerance;

@end
