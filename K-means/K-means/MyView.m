//
//  MyView.m
//  K-means
//
//  Created by FengYuZhuo on 15/6/21.
//  Copyright (c) 2015年 FengYuZhuo. All rights reserved.
//

#import "MyView.h"

@implementation MyPoint


@end

@implementation MyView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *pointArray = [NSMutableArray new];
        NSMutableArray *KPointArray = [NSMutableArray new];
        for (int i=0; i<POINT_NUM; ++i) {
            MyPoint *newPoint = [MyPoint new];
            newPoint.x = -1;
            [pointArray addObject:newPoint];
        }
        for (int i=0; i<POINT_KNUM; ++i) {
            MyPoint *newPoint = [MyPoint new];
            newPoint.x = -1;
            [KPointArray addObject:newPoint];
        }
        _pointArray = pointArray;
        _KPointArray = KPointArray;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code

    [self drawPoint];
}

- (void)drawPoint {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (int i=0; i<POINT_NUM; ++i) {
        MyPoint *curPoint = (MyPoint *)_pointArray[i];
        if (curPoint.x == -1) {
            break;
        }
        CGRect rectangle = CGRectMake(curPoint.x, curPoint.y, 5, 5);
        CGContextAddEllipseInRect(ctx, rectangle);
        CGContextSetFillColorWithColor(ctx, curPoint.color.CGColor);
        CGContextFillPath(ctx);
    }
    for (int i=0; i<POINT_KNUM; ++i) {
        MyPoint *curPoint = (MyPoint *)_KPointArray[i];
        if (curPoint.x == -1) {
            continue;
        }
        CGRect rectangle = CGRectMake(curPoint.x, curPoint.y, 5, 5);
        CGContextAddEllipseInRect(ctx, rectangle);
        CGContextSetFillColorWithColor(ctx, curPoint.color.CGColor);
        CGContextFillPath(ctx);
    }
   
}

@end
