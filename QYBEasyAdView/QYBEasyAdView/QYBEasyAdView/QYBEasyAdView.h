//
//  QYBEasyAdView.h
//  QYBEasyAdView
//
//  Created by qianyb on 16/4/7.
//  Copyright © 2016年 qianyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYBEasyAdView : UIView

@property (nonatomic, strong) NSArray<NSString *> *remoteImagesURL;
@property (nonatomic, strong) UIImage *placeholder;

@property (nonatomic, assign) BOOL shouldAutoScrolling;

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

//add tap event callback by xusion
typedef void(^QYBEasyAdViewOnTap)(NSInteger index,NSString* imageURL);
@property (nonatomic, copy) QYBEasyAdViewOnTap onTap;
@end
