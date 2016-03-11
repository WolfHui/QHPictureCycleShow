//
//  ViewController.m
//  UIScrollView的使用
//
//  Created by 游强辉 on 16/1/26.
//  Copyright © 2016年 youqianghui. All rights reserved.
//

#define COUNt 5

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property(nonatomic,weak)UIImageView *currentImageView;
@property(nonatomic,weak)UIImageView *nextImageView;
@property(nonatomic,weak)UIImageView *preImageView;
//计时器属性
@property(nonatomic,weak)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat imageViewW = self.scrollView.frame.size.width;
    CGFloat imageViewH = self.scrollView.frame.size.height;
    
    //当前的ImageView
    UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewW, 0, imageViewW, imageViewH)];
    currentImageView.image = [UIImage imageNamed:@"img_01"];
    [self.scrollView addSubview:currentImageView];
    self.currentImageView = currentImageView;
    
    
//    下一张ImageView
    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*imageViewW, 0, imageViewW, imageViewH)];
    nextImageView.image = [UIImage imageNamed:@"img_02"];
    [self.scrollView addSubview:nextImageView];
    self.nextImageView = nextImageView;
//
//    //上一张ImageView
    UIImageView *preImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewW, imageViewH)];
    preImageView.image = [UIImage imageNamed:@"img_05"];
    [self.scrollView addSubview:preImageView];
    self.preImageView = preImageView;
   
    // 设置scrollView滚动范围(只要3个宽度)
    self.scrollView.contentSize = CGSizeMake(3 * imageViewW, 0);

    //设置滚动条不显示
    self.scrollView.showsHorizontalScrollIndicator = NO;

    //设置分页功能
    self.scrollView.pagingEnabled = YES;
    
    //设置代理
    self.scrollView.delegate = self;
    
    //设置偏移
    self.scrollView.contentOffset = CGPointMake(imageViewW, 0);
    
    //关闭弹簧效果
    self.scrollView.bounces = NO;
    
    //设置定时器
    [self startTimer];
    
    //设置pagecontrol的点的个数
    self.pageControl.numberOfPages = COUNt;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//实现代理中的部分协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //   当前展示的是第几张图片
    static int i = 1;
    
    //该方法在scrollView滚动过程中不断调用
    //取得当前图片与scrollView X方向的偏移量
    CGFloat offset = self.scrollView.contentOffset.x;
    
        //判断
    if (self.nextImageView.image == nil || self.preImageView.image == nil) {
        //  加载下一个视图
        NSString *imageName1 = [NSString stringWithFormat:@"img_%02d",i == COUNt ? 1:i + 1];
        _nextImageView.image = [UIImage imageNamed:imageName1];
        // 加载上一个视图
        NSString *imageName2 = [NSString stringWithFormat:@"img_%02d",i == 1 ? COUNt :i - 1];
        _preImageView.image = [UIImage imageNamed:imageName2];
    }
    if(offset == 0){
        _currentImageView.image = _preImageView.image;
        //不管图片内容怎么变动，永远保证当前窗口是currentImageView,人眼觉察不到窗口的变动（实际上imageView的窗口飞快的移动到currentView）
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        _preImageView.image = nil;
        if (i == 1) {
            i = COUNt;
        } else{
            i -= 1;
        }
    }
    if (offset == scrollView.bounds.size.width * 2) {
        _currentImageView.image = _nextImageView.image;
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        _nextImageView.image = nil;
        if (i == COUNt) {
            i  = 1 ;
        }else{
            i += 1 ;
        }
    }
    self.pageControl.currentPage = i - 1;
    
}
//自动滚动到下一张
- (void)scrolling:(NSTimer *)timer
{
    CGPoint offSet = self.scrollView.contentOffset;
    offSet.x +=offSet.x;
    //设置偏移
    [self.scrollView setContentOffset:offSet animated:YES];
    
    if (offSet.x >= self.scrollView.frame.size.width *2) {
        //保证当前偏移量永远都是一个scrollView的宽度
        offSet.x = self.scrollView.frame.size.width;
    }
    

    
}

//监听scrollView手动滚动过程中停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

//当手动滚动结束时候创建计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        [self startTimer];
    }
}
//减速完成之后创建计时器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimer];
}

//计时器抽取方法
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrolling:) userInfo:nil repeats:YES];
    // 作用:修改timer在runLoop中的模式为NSRunLoopCommonModes;
    // 目的:不管主线程在做什么操作,都会分配一定的时间处理timer
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


@end














