//
//  ViewController.m
//  UIScrollView的使用
//
//  Created by 游强辉 on 16/1/26.
//  Copyright © 2016年 youqianghui. All rights reserved.
//

#define COUNt 5

#import "ViewController.h"
#import "QHPictureShowView.h"

@interface ViewController () <UIScrollViewDelegate>
//计时器属性
//@property(nonatomic,weak)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QHPictureShowView *showView = [[QHPictureShowView alloc] init];
    showView.frame = CGRectMake(20, 200, 300, 200);
    [self.view addSubview:showView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end














