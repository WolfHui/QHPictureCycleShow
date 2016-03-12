//
//  QHPictureShowView.m
//  QHPictureCycleShow
//
//  Created by 游强辉 on 16/3/12.
//  Copyright © 2016年 youqianghui. All rights reserved.
//

#import "QHPictureShowView.h"
#define COUNT 5

@interface QHPictureShowView ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) UIImageView *currentImageView;
@property (nonatomic, weak) UIImageView *nextImageView;
@property (nonatomic, weak) UIImageView *preImageView;

@property (nonatomic,weak) NSTimer *timer;

@end

@implementation QHPictureShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"QHPictureShow" owner:nil options:nil].lastObject;

    }
    return self;
}

+ (instancetype)pictureShowView
{
    return [[self alloc] init];
}

- (void)awakeFromNib
{
    //当前的View
    UIImageView *currentImageView = [[UIImageView alloc] init];
    self.currentImageView = currentImageView;
    [self.scrollView addSubview:currentImageView];
    
    //上一张View
    UIImageView *preImageView = [[UIImageView alloc] init];
    self.preImageView = preImageView;
    [self.scrollView addSubview:preImageView];
    
    //下一张View
    UIImageView *nextImageView = [[UIImageView alloc] init];
    self.nextImageView = nextImageView;
    [self.scrollView addSubview:nextImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageViewW = self.scrollView.frame.size.width;
    CGFloat imageViewH = self.scrollView.frame.size.height;
    
    self.currentImageView.frame = CGRectMake(imageViewW, 0, imageViewW, imageViewH);
    self.currentImageView.image = [UIImage imageNamed:@"img_01"];
    
    self.nextImageView.frame = CGRectMake(2 * imageViewW, 0, imageViewW, imageViewH);
    self.nextImageView.image = [UIImage imageNamed:@"img_02"];
    
    self.preImageView.frame = CGRectMake(0, 0, imageViewW, imageViewH);
    self.preImageView.image = [UIImage imageNamed:@"img_05"];
    
    //设置scrollView的属性
    self.scrollView.contentSize = CGSizeMake(3 * imageViewW, imageViewH);
    self.scrollView.contentOffset = CGPointMake(imageViewW, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.pageControl.numberOfPages = COUNT;
    self.scrollView.delegate = self;
    
    [self startTimer];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    //设当前是第一张图片
    static int i = 1;
    
    CGFloat offset = scrollView.contentOffset.x;
    
    if (self.preImageView.image == nil || self.nextImageView.image == nil) {
        NSString *nextImageName = [NSString stringWithFormat:@"img_%02d",i == COUNT ? 1 : i + 1];
        self.nextImageView.image = [UIImage imageNamed:nextImageName];
        
        NSString *preImageName = [NSString stringWithFormat:@"img_%02d",i == 1 ? COUNT : i - 1];
        self.preImageView.image = [UIImage imageNamed:preImageName];
    }
    
    if (offset == 2 * scrollView.bounds.size.width) {
        
        self.currentImageView.image = self.nextImageView.image;
        self.scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        self.nextImageView.image = nil;
        if (i == COUNT) {
            i = 1;
        }else
        {
            i = i + 1;
        }
    }
    
    if (offset == 0) {
        
        self.currentImageView.image = self.preImageView.image;
        self.scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        self.preImageView.image = nil;
        if (i == 1) {
            i = COUNT;
        }else
        {
            i = i - 1;
        }
    }
//    NSLog(@"%d",i);
    self.pageControl.currentPage = i - 1;
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timeChange:(NSTimer *)timer
{
    CGPoint offset = self.scrollView.contentOffset;
    
    offset.x += offset.x;
    
    [self.scrollView setContentOffset:offset animated:YES];
    
    if (offset.x == self.scrollView.bounds.size.width * 2) {
        offset.x = self.scrollView.bounds.size.width;
    }
}

@end
