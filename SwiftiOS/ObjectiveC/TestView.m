//
//  TestView.m
//  SwiftiOS
//
//  Created by lian on 2021/3/4.
//

#import "TestView.h"
#import "SwiftiOS-Swift.h"

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       TestClass *c = [[TestClass alloc]init];
        [c log];
    }
    return self;
}

@end
