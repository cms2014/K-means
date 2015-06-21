//
//  ViewController.m
//  K-means
//
//  Created by FengYuZhuo on 15/6/21.
//  Copyright (c) 2015年 FengYuZhuo. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MyView.h"

@interface ViewController ()
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) MyView *coordinateView;
@property (weak, nonatomic) UIButton *initialButton;
@property (weak, nonatomic) UIButton *beginButton;
@end

@implementation ViewController {
    double dist[POINT_NUM];
    double oldSeedX[POINT_KNUM];
    double oldSeedY[POINT_KNUM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
- (void)setupView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 20)];
    titleLabel.text = @"K-means算法演示";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    
    MyView *coordinateView = [[MyView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.width)];
    coordinateView.layer.borderWidth = 1.0;
    coordinateView.layer.borderColor = [UIColor blackColor].CGColor;
    coordinateView.backgroundColor = [UIColor whiteColor];
    _coordinateView = coordinateView;
    
    UIButton *initialButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 460, 60, 30)];
    [initialButton setTitle:@"初始化" forState:UIControlStateNormal];
    [initialButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [initialButton addTarget:self action:@selector(initialParam) forControlEvents:UIControlEventTouchUpInside];
    _initialButton = initialButton;
    
    UIButton *beginButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 460, 100, 30)];
    [beginButton setTitle:@"开始算法" forState:UIControlStateNormal];
    [beginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginKmeans) forControlEvents:UIControlEventTouchUpInside];
    _beginButton = beginButton;
    
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_coordinateView];
    [self.view addSubview:_initialButton];
    [self.view addSubview:_beginButton];
    
    
}

#pragma mark - Actions
/**
 * 初始化50个点
 */
- (void)initialParam {
    int i;
    int maxWidth = self.view.bounds.size.width-40;
    for (i = 0; i < POINT_NUM; ++i) {
        MyPoint *curPoint = (MyPoint *)_coordinateView.pointArray[i];
        curPoint.x = 10+rand() % maxWidth;
        curPoint.y = 10+rand() % maxWidth;
    }
    [_coordinateView setNeedsDisplay];
}

/**
 * 开始K-means算法
 */
- (void)beginKmeans {
    srand((unsigned int)time(NULL));
    [self chooseInitSeeds];
    int TCount = 0;
    while (true) {
        ++TCount;
        NSLog(@"%i", TCount);
        [self caculateDistToSeed];
        [self caculateNewSeed];
        if ([self ifShouldEnd]) {
            break;
        } else {
            [self updateOldSeed];
        }
    }
    [_coordinateView setNeedsDisplay];
    
}

#pragma mark - K-means辅助函数
/**
 * 选取最初始的种子点
 */
- (void)chooseInitSeeds {
    int i, j, k;
    int firstSeedIndex = rand() % POINT_NUM;
    double curDist, minDist, sumDist;
    
    // 随机选取一个点为第一个种子点
    MyPoint *curPoint = (MyPoint *)_coordinateView.pointArray[firstSeedIndex];
    MyPoint *seedPoint = (MyPoint *)_coordinateView.KPointArray[0];
    seedPoint.x = curPoint.x;
    seedPoint.y = curPoint.y;
    _coordinateView.ifNeedDrawLine = true;
    
    for (i = 1; i < POINT_KNUM; ++i) {
        sumDist = 0;
        // 计算所有点到最近的种子点的距离
        for (j = 0; j < POINT_NUM; ++j) {
            curPoint = (MyPoint *)_coordinateView.pointArray[j];
            minDist = 99999;
            // 计算当前点到所有种子点的距离，选出最小的
            for (k = 0; k < i; ++k) {
                seedPoint = (MyPoint *)_coordinateView.KPointArray[k];
                curDist = [self distFromAPoint:curPoint toAnotherPoint:seedPoint];
                if (curDist < minDist) {
                    curPoint.closestSeedIndex = k;
                    minDist = curDist;
                }
            }
            sumDist += minDist;
            // 储存到数组中
            dist[j] = minDist;
        }
        double randDist = rand() % 1000/1000.0 * sumDist;
        // 类似遗传算法中转盘赌选择距离“较远”的那一个，这里其实有选重复的风险，但是不管了，几率很小，假装不知道^_^
        for (j = 0; j < POINT_NUM; ++j) {
            randDist -= dist[j];
            if (randDist <= 0) {
                curPoint = (MyPoint *)_coordinateView.pointArray[j];
                seedPoint = (MyPoint *)_coordinateView.KPointArray[i];
                seedPoint.x = curPoint.x;
                seedPoint.y = curPoint.y;
                break;
            }
        }
    }
    for (i = 0; i < POINT_KNUM; ++i) {
        seedPoint = (MyPoint *)_coordinateView.KPointArray[i];
        oldSeedX[i] = seedPoint.x;
        oldSeedY[i] = seedPoint.y;
    }
}

/**
 * 计算两点之间的距离
 */
- (double)distFromAPoint:(MyPoint *)first toAnotherPoint:(MyPoint *)second {
    double distance = sqrt(pow((first.x - second.x), 2) + pow((first.y - second.y), 2.0));
    return distance;
}

/**
 * 计算所有点到质心的距离，并把它归到最近的质心的类
 */
- (void)caculateDistToSeed {
    int j, k;
    double curDist, minDist;
    MyPoint *curPoint;
    MyPoint *seedPoint;
    
    // 计算所有点到最近的种子点的距离
    for (j = 0; j < POINT_NUM; ++j) {
        curPoint = (MyPoint *)_coordinateView.pointArray[j];
        minDist = 99999;
        // 计算当前点到所有种子点的距离，选出最小的
        for (k = 0; k < POINT_KNUM; ++k) {
            seedPoint = (MyPoint *)_coordinateView.KPointArray[k];
            curDist = [self distFromAPoint:curPoint toAnotherPoint:seedPoint];
            if (curDist < minDist) {
                curPoint.closestSeedIndex = k;
                minDist = curDist;
            }
        }
    }
}

/**
 * 重新计算已经得到的各个类的质心
 */
- (void)caculateNewSeed {
    int i, j, count;
    MyPoint *curPoint;
    MyPoint *seedPoint;
    double sumX, sumY;
    
    for (i = 0; i < POINT_KNUM; ++i) {
        seedPoint = (MyPoint *)_coordinateView.KPointArray[i];
        sumX = 0;
        sumY = 0;
        count = 0;
        for (j = 0; j < POINT_NUM; ++j) {
            curPoint = (MyPoint *)_coordinateView.pointArray[j];
            if (curPoint.closestSeedIndex == i) {
                count ++ ;
                sumX += curPoint.x;
                sumY += curPoint.y;
            }
            seedPoint.x = sumX / count;
            seedPoint.y = sumY / count;
        }
    }
}

/**
 *
 */
- (BOOL)ifShouldEnd {
    int i;
    MyPoint *seedPoint;
    MyPoint *oldPoint = [MyPoint new];
    
    for (i = 0; i < POINT_KNUM; ++i) {
        seedPoint = (MyPoint *)_coordinateView.KPointArray[i];
        oldPoint.x = oldSeedX[i];
        oldPoint.y = oldSeedY[i];
        if ([self distFromAPoint:seedPoint toAnotherPoint:oldPoint] > THRESHOLD) {
            return false;
        }
    }
    return true;
}

- (void)updateOldSeed {
    int i;
    MyPoint *seedPoint;
    for (i = 0; i < POINT_KNUM; ++i) {
        seedPoint = (MyPoint *)_coordinateView.KPointArray[i];
        oldSeedX[i] = seedPoint.x;
        oldSeedY[i] = seedPoint.y;
    }
}
@end
