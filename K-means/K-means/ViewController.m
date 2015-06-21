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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupView];
    [self setupConstraints];
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
    coordinateView.backgroundColor = [UIColor whiteColor];
    _coordinateView = coordinateView;
    
    UIButton *initialButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 60, 30)];
    [initialButton setTitle:@"初始化" forState:UIControlStateNormal];
    [initialButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [initialButton addTarget:self action:@selector(initialParam) forControlEvents:UIControlEventTouchUpInside];
    _initialButton = initialButton;
    
    UIButton *beginButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 500, 100, 30)];
    [beginButton setTitle:@"开始算法" forState:UIControlStateNormal];
    [beginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginKmeans) forControlEvents:UIControlEventTouchUpInside];
    _beginButton = beginButton;
    
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_coordinateView];
    [self.view addSubview:_initialButton];
    [self.view addSubview:_beginButton];
    
    
}

- (void)setupConstraints {

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
        curPoint.color = [UIColor redColor];
    }
    [_coordinateView setNeedsDisplay];
}

/**
 * 开始K-means算法
 */
- (void)beginKmeans {
    int i;
    int maxWidth = self.view.bounds.size.width-40;
    for (i = 0; i < POINT_KNUM; ++i) {
        MyPoint *curPoint = (MyPoint *)_coordinateView.KPointArray[i];
        curPoint.x = 10+rand() % maxWidth;
        curPoint.y = 10+rand() % maxWidth;
        curPoint.color = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.5];
    }
    [_coordinateView setNeedsDisplay];
    
}

#pragma mark - K-means辅助函数


@end
