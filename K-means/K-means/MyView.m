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
            newPoint.color = [UIColor redColor];
            newPoint.closestSeedIndex = 0;
            [pointArray addObject:newPoint];
        }
        for (int i=0; i<POINT_KNUM; ++i) {
            MyPoint *newPoint = [MyPoint new];
            newPoint.x = -1;
            newPoint.color = [UIColor colorWithRed:0 green:200 blue:0 alpha:0.6];
            [KPointArray addObject:newPoint];
        }
        _pointArray = pointArray;
        _KPointArray = KPointArray;
        _ifNeedDrawLine = false;
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
        CGRect rectangle = CGRectMake(curPoint.x, curPoint.y, 8, 8);
        CGContextAddEllipseInRect(ctx, rectangle);
        CGContextSetFillColorWithColor(ctx, curPoint.color.CGColor);
        CGContextFillPath(ctx);
    }
    for (int i=0; i<POINT_KNUM; ++i) {
        MyPoint *curPoint = (MyPoint *)_KPointArray[i];
        if (curPoint.x == -1) {
            continue;
        }
        CGRect rectangle = CGRectMake(curPoint.x, curPoint.y, 8, 8);
        CGContextAddEllipseInRect(ctx, rectangle);
        CGContextSetFillColorWithColor(ctx, curPoint.color.CGColor);
        CGContextFillPath(ctx);
    }
    if (_ifNeedDrawLine) {
        CGContextSetLineWidth(ctx, 0.5);
        CGContextSetRGBStrokeColor(ctx, 0.314, 0.486, 0.859, 1.0);
        CGContextBeginPath(ctx);
        for (int i=0; i < POINT_NUM; ++i) {
            MyPoint *curPoint = (MyPoint *)_pointArray[i];
            // 如果还没这个点，就跳过
            if (curPoint.x == -1) {
                continue;
            }
            int j = curPoint.closestSeedIndex;
            MyPoint *seedPoint = (MyPoint *)_KPointArray[j];
            // 如果这个种子点还没找好，就跳过
            if (seedPoint.x == -1) {
                continue;
            }
            CGContextMoveToPoint(ctx, curPoint.x+4, curPoint.y+4);
            CGContextAddLineToPoint(ctx, seedPoint.x+4, seedPoint.y+4);
        }
        CGContextStrokePath(ctx);
    }
}

@end
