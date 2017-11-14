//
//  ViewController.m
//  QYBEasyAdView
//
//  Created by qianyb on 16/4/7.
//  Copyright © 2016年 qianyb. All rights reserved.
//

#import "ViewController.h"
#import "QYBEasyAdView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QYBEasyAdView *easyAd = [[QYBEasyAdView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    easyAd.remoteImagesURL = @[@"https://wx1.sinaimg.cn/mw690/5d3dd8b7ly1flhbmgyqnmj20hs0hsabf.jpg",
                               @"https://wx2.sinaimg.cn/mw690/5d3dd8b7ly1flhbmhhom1j20hs0hsdgy.jpg",
                               @"https://wx1.sinaimg.cn/mw690/e7c25bb6gy1flcqljhhzmj20dw0o4770.jpg",
                               @"https://wx4.sinaimg.cn/mw690/a716fd45ly1flhdegaj8qj20b4075wgp.jpg"
                               ,@"https://wx3.sinaimg.cn/mw690/6670179bly1flh9x5g8b1j20m80m8jsk.jpg"];
    easyAd.shouldAutoScrolling = YES;
    easyAd.timeInterval = 5;
    [self.view addSubview:easyAd];
	
	//add tap event callback by xusion
	easyAd.onTap = ^(NSInteger index ,NSString* imageURL){
		NSLog(@"点击的imageURL:%@ index:%ld", imageURL, (long)index);
	};
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
