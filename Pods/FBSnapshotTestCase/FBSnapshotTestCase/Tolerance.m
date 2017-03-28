//
//  Tolerance.m
//  FBSnapshotTestCase
//
//  Created by Bruno Mazzo on 24/03/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "Tolerance.h"

@implementation Tolerance

-(instancetype)init {
  if (self = [super init]) {
    self->_pixelPercent = 0;
    self->_colorTolerance = 1;
    self->_useGridTolerance = YES;
  }
  return self;
}
  
@end
