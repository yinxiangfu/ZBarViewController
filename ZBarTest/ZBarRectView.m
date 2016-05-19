//
//  ZBarRectView.m
//  ZBarTest
//
//  Created by biznest on 15/8/6.
//  Copyright (c) 2015年 xf. All rights reserved.
//

#import "ZBarRectView.h"

#define WIDTH_4     (_myFrame.size.width/4)
#define HEIGHT_4     (_myFrame.size.height/4)
@interface ZBarRectView ()
{
    CGRect _myFrame;
}
@end

@implementation ZBarRectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _myFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ref);
    
    CGPoint point1  = CGPointMake(WIDTH_4 * 0,    HEIGHT_4 * 0);
    CGPoint point2  = CGPointMake(WIDTH_4 * 1,    HEIGHT_4 * 0);
    CGPoint point3  = CGPointMake(WIDTH_4 * 3,    HEIGHT_4 * 0);
    CGPoint point4  = CGPointMake(WIDTH_4 * 4,    HEIGHT_4 * 0);
    CGPoint point5  = CGPointMake(WIDTH_4 * 4,    HEIGHT_4 * 1);
    CGPoint point6  = CGPointMake(WIDTH_4 * 4,    HEIGHT_4 * 3);
    CGPoint point7  = CGPointMake(WIDTH_4 * 4,    HEIGHT_4 * 4);
    CGPoint point8  = CGPointMake(WIDTH_4 * 3,    HEIGHT_4 * 4);
    CGPoint point9  = CGPointMake(WIDTH_4 * 1,    HEIGHT_4 * 4);
    CGPoint point10 = CGPointMake(WIDTH_4 * 0,    HEIGHT_4 * 4);
    CGPoint point11 = CGPointMake(WIDTH_4 * 0,    HEIGHT_4 * 3);
    CGPoint point12 = CGPointMake(WIDTH_4 * 0,    HEIGHT_4 * 1);
    
    const CGPoint line1[] = {point12, point1, point2};
    CGContextAddLines(ref, line1, 3);
    const CGPoint line2[] = {point3, point4, point5};
    CGContextAddLines(ref, line2, 3);
    const CGPoint line3[] = {point6, point7, point8};
    CGContextAddLines(ref, line3, 3);
    const CGPoint line4[] = {point9, point10, point11};
    CGContextAddLines(ref, line4, 3);
    CGContextMoveToPoint(ref, WIDTH_4 * 0, HEIGHT_4 * 3);
    CGContextClosePath(ref);
    CGContextSetLineWidth(ref, 2.0f);
    CGContextSetStrokeColorWithColor(ref, [UIColor whiteColor].CGColor);
    CGContextDrawPath(ref, kCGPathStroke);
}

- (void)readZBarWithCtr:(UIViewController *)ctr
{
    
}

@end
