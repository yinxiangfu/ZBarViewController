//
//  GridAnimationView.m
//  ZBarTest
//
//  Created by biznest on 15/8/6.
//  Copyright (c) 2015年 xf. All rights reserved.
//

#import "GridAnimationView.h"
#define LINE_NUM 30
@interface GridAnimationView ()
{
    CGFloat _height;
    CGFloat _width;
    NSTimer *_timer;
    UIImageView *_myImgView;
}
@end

@implementation GridAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _width = frame.size.width;
        _height = frame.size.height;
        self.backgroundColor = [UIColor clearColor];
        [self drawMyImg];
    }
    return self;
}

- (void)drawMyImg
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ref, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(ref, 0.5f);
    CGFloat width = self.bounds.size.width/LINE_NUM;
    for (int i = 0; i < LINE_NUM; i ++) {
        float index = i+0.5;
        float all = LINE_NUM;
        CGContextSetAlpha(ref,index/all/2.0f);
        for (int j = 0; j < LINE_NUM; j ++) {
            CGRect rect = CGRectMake(width * j, width * i, width, width);
            CGContextStrokeRectWithWidth(ref, rect, 1.0f);
        }
    }
//    CGContextStrokeRectWithWidth(ref, CGRectInset(self.bounds, 0.5, 0.5), 1.0f);
    
    //竖线
//    for (int i = 1; i < LINE_NUM; i ++) {
//        const CGPoint line[] = {CGPointMake((self.frame.size.width/LINE_NUM) * i, 0), CGPointMake((self.frame.size.width/LINE_NUM) * i, self.frame.size.height)};
//        CGContextSetAlpha(ref, i/LINE_NUM);
//        if (i == 1)CGContextSetAlpha(ref, 0.2);
//        if(i == 2)CGContextSetAlpha(ref, 0.5);
//        CGContextStrokeLineSegments(ref, line, 2);
//    }
    //横线
//    for (int i = 1; i < LINE_NUM; i ++) {
//        CGContextSetAlpha(ref, 1);
//        const CGPoint line[] = {CGPointMake(0, (self.frame.size.height/LINE_NUM) * i), CGPointMake(self.frame.size.width, (self.frame.size.height/LINE_NUM) * i)};
//        CGContextStrokeLineSegments(ref, line, 2);
//    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _myImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -_height, _width, _height)];
    _myImgView.image = img;
    [self addSubview:_myImgView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.015f target:self selector:@selector(beginAnimation) userInfo:nil repeats:YES];
}

- (void)beginAnimation
{
    if (_myImgView.frame.origin.y >= _height) {
        _myImgView.frame = CGRectMake(0, -_height, _width, _height);
    }else{
        _myImgView.frame = CGRectMake(0, _myImgView.frame.origin.y + _height/LINE_NUM, _width, _height);
    }
}

- (void)dealloc
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
