//
//  MyView.h
//  K-means
//
//  Created by FengYuZhuo on 15/6/21.
//  Copyright (c) 2015年 FengYuZhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POINT_NUM 100
#define POINT_KNUM 5
#define THRESHOLD 1

@interface MyPoint : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) int closestSeedIndex;
@property (strong, nonatomic) UIColor *color;

@end

@interface MyView : UIView

@property (strong, nonatomic) NSMutableArray *pointArray;
@property (strong, nonatomic) NSMutableArray *KPointArray;
@property (nonatomic) BOOL ifNeedDrawLine;

@end
