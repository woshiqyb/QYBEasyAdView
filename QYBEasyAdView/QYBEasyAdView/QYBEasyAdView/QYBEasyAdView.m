//
//  QYBEasyAdView.m
//  QYBEasyAdView
//
//  Created by qianyb on 16/4/7.
//  Copyright © 2016年 qianyb. All rights reserved.
//

#import "QYBEasyAdView.h"
#import "UIImageView+WebCache.h"

#define EASY_AD_CELL_IDENTIFIER @"UICollectionViewCell"

#define FULL_VIEW_WIDTH     CGRectGetWidth(self.bounds)
#define FULL_VIEW_HEIGHT    CGRectGetHeight(self.bounds)

#define DEFAULT_TIME_INTERVAL 2

@interface QYBEasyAdView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation QYBEasyAdView {
    UICollectionView *easyAdCollectionView;
    NSTimer *timer;
    
    NSUInteger currentPage;
    UIPageControl *pageControl;
}

#pragma mark - Life Circle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        currentPage = 1;
        
        _shouldAutoScrolling = NO;
        _timeInterval = DEFAULT_TIME_INTERVAL;
        
        _pageIndicatorTintColor = [UIColor whiteColor];
        _currentPageIndicatorTintColor = [UIColor orangeColor];
        
        [self setupContentView];
    }
    return self;
}

- (void)didMoveToWindow {
    if (self.window) {
		NSInteger count = [easyAdCollectionView numberOfItemsInSection:0];
		if(count >= currentPage){
			[easyAdCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
			
			if (_shouldAutoScrolling) {
				[self startTimer];
			}
		}
    }else {
        [self stopTimer];
    }
}

#pragma mark - Setter Method
- (void)setShouldAutoScrolling:(BOOL)shouldAutoScrolling {
    _shouldAutoScrolling = shouldAutoScrolling;

}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
}

- (void)setRemoteImagesURL:(NSArray<NSString *> *)remoteImagesURL {
	if (remoteImagesURL.count > 0) {
		NSMutableArray *tempArray = [NSMutableArray arrayWithObject:[remoteImagesURL lastObject]];
		[tempArray addObjectsFromArray:remoteImagesURL];
		[tempArray addObject:[remoteImagesURL firstObject]];
		_remoteImagesURL = [tempArray copy];
		
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[easyAdCollectionView reloadData];
			pageControl.numberOfPages = _remoteImagesURL.count > 1 ? _remoteImagesURL.count - 2 : _remoteImagesURL.count;
		});
	}
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
	_currentPageIndicatorTintColor = currentPageIndicatorTintColor;
	pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
	
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
	_pageIndicatorTintColor = pageIndicatorTintColor;
	pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}
	
#pragma mark - Initialization
- (void)setupContentView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    easyAdCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, FULL_VIEW_WIDTH, FULL_VIEW_HEIGHT) collectionViewLayout:flowLayout];
    easyAdCollectionView.delegate = self;
    easyAdCollectionView.dataSource = self;
    easyAdCollectionView.backgroundColor = [UIColor blackColor];
    easyAdCollectionView.pagingEnabled = YES;
    easyAdCollectionView.bounces = NO;
    easyAdCollectionView.showsHorizontalScrollIndicator = NO;
    easyAdCollectionView.contentSize = CGSizeMake(FULL_VIEW_WIDTH * _remoteImagesURL.count, FULL_VIEW_HEIGHT);
    [easyAdCollectionView registerClass:NSClassFromString(EASY_AD_CELL_IDENTIFIER) forCellWithReuseIdentifier:EASY_AD_CELL_IDENTIFIER];

    [self addSubview:easyAdCollectionView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, FULL_VIEW_HEIGHT - 40, FULL_VIEW_WIDTH, 40)];
    pageControl.userInteractionEnabled = NO;
    pageControl.hidesForSinglePage = YES;
    pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    [self addSubview:pageControl];
}
	
- (void)layoutSubviews {
	[super layoutSubviews];
	
	//auto resize view by xusion
	easyAdCollectionView.frame = CGRectMake(0, 0, FULL_VIEW_WIDTH, FULL_VIEW_HEIGHT);
	easyAdCollectionView.contentSize = CGSizeMake(FULL_VIEW_WIDTH * _remoteImagesURL.count, FULL_VIEW_HEIGHT);
	pageControl.frame = CGRectMake(0, FULL_VIEW_HEIGHT - 40, FULL_VIEW_WIDTH, 40);
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"被拖拽");
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //NSLog(@"结束拖拽");
    _shouldAutoScrolling ? [self startTimer] : nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidEndDecelerating");
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidEndScrollingAnimation");
    
    CGPoint offset = easyAdCollectionView.contentOffset;
    currentPage = offset.x / FULL_VIEW_WIDTH;
    
    //首尾的视图展示后需要进行转化，方便下一次的滚动
    if (currentPage == 0 || currentPage == _remoteImagesURL.count - 1) {
        if (currentPage == 0) {
            currentPage = _remoteImagesURL.count - 2;
        }else {
            currentPage = 1;
        }
        
        [easyAdCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    pageControl.currentPage = currentPage - 1;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger remoteImageItem = (NSInteger)indexPath.item;
	NSInteger remoteImageIndex = remoteImageItem - 1;
	NSString *remoteImageURL = _remoteImagesURL[remoteImageItem];
	//NSLog(@"点击的链接是%@",remoteImageURL);
	
	//add tap event callback by xusion
	self.onTap(remoteImageIndex,remoteImageURL);
}

#pragma mark - UICollectionView Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _remoteImagesURL.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EASY_AD_CELL_IDENTIFIER forIndexPath:indexPath];
    UIImageView *imageView = [cell.contentView viewWithTag:100];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FULL_VIEW_WIDTH, FULL_VIEW_HEIGHT)];
        imageView.backgroundColor = [UIColor blackColor];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 100;
        [cell addSubview:imageView];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:_remoteImagesURL[indexPath.item]] placeholderImage:_placeholder options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            NSLog(@"图片下载失败，imageURL = %@",imageURL);
        }
    }];
	
    return cell;
}

#pragma mark - UICollectionView Delegate Flow Layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(FULL_VIEW_WIDTH, FULL_VIEW_HEIGHT);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Timer Action
- (void)scrollEasyAdView {
    [easyAdCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - Private Method
- (void)startTimer {
    if (!timer) {
        timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(scrollEasyAdView) userInfo:nil repeats:YES];
    }
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
@end
