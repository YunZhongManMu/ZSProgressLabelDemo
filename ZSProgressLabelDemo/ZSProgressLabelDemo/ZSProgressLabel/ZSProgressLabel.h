//
//  ZSProgressLabel.h
//  UILabel字体的镂空效果
//
//  Created by 周顺 on 16/4/21.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZSProgressLabel : UIView


/**
 *  显示进度，默认为0  ，取值范围为（0 - 1）
 *
 *  设置的值超出取值范围时，自动处理，取边界值
 *
 *  与控制视图进度同时设置一个为佳
 */
@property (nonatomic, assign) CGFloat disProgress;
/**
 *  控制视图进度，默认为0，取值范围为 （0 - self.bouns.size.width）
 *
 *  设置的值超出取值范围时，自动处理，取边界值
 *
 *  与显示进度同时设置一个为佳
 */
@property (nonatomic, assign) CGFloat showWidth;
 /** 文本 */
@property (nonatomic, copy) NSString *text;
/** 字体  */
@property (nonatomic, strong) UIFont *font;
/**  对齐方式 */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/** 背景字体颜色 */
@property (nonatomic, strong) UIColor *backgroundTextColor;
/** 前景背景颜色 */
@property (nonatomic, strong) UIColor  *foregroundTextColor;

/**
 *  内容自适应，只支持代码创建自适应，不支持Nib创建的自适应
 */
- (void)sizeToFit;
/**
 *  是否能够用手势拖动，默认是NO
 */
@property (nonatomic, assign) BOOL isPanGesture;

/**
 *  拖动过程中回调 
 * 
 *  @param pointX              拖动偏移的X
 *  @param disProgress    此时显示的进度
 */
@property (nonatomic, copy) void(^panGestureScrollHandler)(NSInteger pointX, CGFloat disProgress);


/**
 *  是否能够自动滚动，默认是NO
 */
@property (nonatomic, assign) BOOL isAutoScroll;
/**
 *  滚动时间，默认为 kTimeInterval  0.02s
 */
@property (nonatomic, assign) NSTimeInterval  timeInterval;
/**
 * 是否正在滚动
 */
@property (nonatomic, assign, readonly) BOOL isRolling;
/**
 *  开启定时器
*/
- (void)startTimer;
/**
 *  关闭定时器
 */
- (void)stopTimer;


@end
