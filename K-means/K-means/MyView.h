//
//  MyView.h
//  K-means
//
//  Created by FengYuZhuo on 15/6/21.
//  Copyright (c) 2015年 FengYuZhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POINT_NUM 50
#define POINT_KNUM 4

@interface MyPoint : NSObject

@property (nonatomic) int x;
@property (nonatomic) int y;
@property (strong, nonatomic) UIColor *color;

@end

@interface MyView : UIView

@property (strong, nonatomic) NSMutableArray *pointArray;
@property (strong, nonatomic) NSMutableArray *KPointArray;

@end
