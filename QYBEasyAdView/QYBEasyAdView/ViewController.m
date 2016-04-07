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
    easyAd.remoteImagesURL = @[@"http://www.68idc.cn/help/uploads/allimg/130813/09240XD8_0.jpg",
                               @"http://www.68idc.cn/help/uploads/allimg/130813/09240M4J_0.jpg",
                               @"http://avatar.csdn.net/2/3/7/3_yuquan0821.jpg",
                               @"http://avatar.csdn.net/A/A/1/3_u010180166.jpg"
                               ,@"http://avatar.csdn.net/1/E/5/3_oik_ios.jpg"];
    easyAd.shouldAutoScrolling = YES;
    easyAd.timeInterval = 5;
    [self.view addSubview:easyAd];
    
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
