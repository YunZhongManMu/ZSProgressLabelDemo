//
//  ZSProgressLabel.m
//  UILabel字体的镂空效果
//
//  Created by 周顺 on 16/4/21.
//  Copyright © 2016年 AIRWALK. All rights reserved.
//

#import "ZSProgressLabel.h"

#define kTimeInterval 0.02 //默认定时器运行时间

@interface ZSProgressLabel ()

@property (nonatomic, strong) UILabel *foregroundLabel;//前景label
@property (nonatomic, strong) UILabel *backgroundLabel;//背景label
@property (nonatomic, strong) UIView *showView;//显示view

@property (nonatomic, strong) NSTimer *timer; //定时器
@property (nonatomic, assign) BOOL flag; //标记

@end

@implementation ZSProgressLabel

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUp];
}

- (void)setUp {
    _backgroundLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:_backgroundLabel];
    
    CGRect frame = self.bounds;
    frame.size.width = 0;
    _showView = [[UIView alloc] initWithFrame:frame];
    _showView.clipsToBounds = YES;
    [self addSubview:_showView];
    
    _foregroundLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [_showView addSubview:_foregroundLabel];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_showView addGestureRecognizer:pan];
}

#pragma mark - 拖动更新
- (void)pan:(UIPanGestureRecognizer *)pan {
    if (_isPanGesture) {
        CGPoint point = [pan translationInView:self];
        
        //拖动过程中回调
        if (self.panGestureScrollHandler) {
            self.panGestureScrollHandler(point.x, self.disProgress);
        }
        
        //更新视图进度
        CGFloat width = self.showWidth;
        CGFloat currentWidth = width + point.x;
        
        [self setShowWidth:currentWidth];
        
        //不让累加
        [pan setTranslation:CGPointZero inView:self];
    }
}

#pragma mark - 内容自适应
- (void)sizeToFit {
    // 1. 获取未自适应前的控制视图进度
    CGFloat disProgress = self.disProgress;
    
    // 2. 让文本自适应
    [self.backgroundLabel sizeToFit];
    
    // 3. 修改内部空间的frame
    CGRect frame = self.backgroundLabel.frame;
    self.bounds = frame;
    self.showView.frame = frame;
    self.foregroundLabel.frame = frame;
    
    // 4. 再次设置控制视图进度，达到与自适应前一样的效果
    [self setDisProgress:disProgress];
}

#pragma mark - 进度控制
-(void)setShowWidth:(CGFloat)showWidth {
    
    if (showWidth >= self.bounds.size.width) {
        showWidth = self.bounds.size.width;
    } else if (showWidth <= 0) {
        showWidth = 0;
    }
    
    CGRect frame = self.showView.frame;
    frame.size.width = showWidth;
    self.showView.frame = frame;
}

-(CGFloat)showWidth {
    return self.showView.frame.size.width;
}

-(void)setDisProgress:(CGFloat)disProgress {
    
    if (disProgress >= 1.0) {
        disProgress = 1.0;
    } else if (disProgress <= 0) {
        disProgress = 0;
    }
    
    CGRect frame = self.showView.frame;
    frame.size.width = disProgress * self.bounds.size.width;
    self.showView.frame = frame;
}

- (CGFloat)disProgress {
    return self.showView.frame.size.width / self.bounds.size.width;
}

 #pragma mark - 对定时器操作
 - (void)startTimer {
 
     if (self.timer) [self stopTimer]; //如果定时器存在，先关闭定时器
     
     CGFloat interval = _timeInterval ? _timeInterval : kTimeInterval;
     self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(move:) userInfo:nil repeats:YES];
 
    /**..
     if (!self.timer) {
     self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(move:) userInfo:nil repeats:YES];
     } else {
     [self.timer setFireDate:[NSDate date]];//如果定时器不为空，就让定时器一直运行下去
     }
     */

}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate], self.timer = nil;
    }
}

#pragma mark - 两种滚动方式，自行选择
- (void)move:(NSTimer *)timer {
    
    // 使用两种方式更新进度，选其一，两种方式更新进度的效果不一样
    
    // 1.
    //[self updateShowWidth];
    
    // 2.
    [self updateDisProgress];
    
}

//更新进度
- (void)updateDisProgress {
    self.disProgress += 0.003;
    
    //内部处理过，最大值即为1
    if (self.disProgress == 1) {
        self.disProgress = 0;
    }
}

//更新选中宽度
- (void)updateShowWidth {
    if (!_flag) {
        self.showWidth ++;
        
        //内部处理过，最大值即为_progressLabel.frame.size.width
        if (self.showWidth == self.frame.size.width) {
            _flag = !_flag;
        }
    } else {
        self.showWidth --;
        
        //内部处理过，最小值即为0
        if (self.showWidth == 0) {
            _flag = !_flag;
        }
    }
}

#pragma mark - setter
- (void)setText:(NSString *)text {
    _text = text;
    self.backgroundLabel.text = text;
    self.foregroundLabel.text = text;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.backgroundLabel.font = font;
    self.foregroundLabel.font = font;
}

-(void)setTextAlignment:(NSTextAlignment )textAlignment {
    _textAlignment = textAlignment;
    self.backgroundLabel.textAlignment = textAlignment;
    self.foregroundLabel.textAlignment = textAlignment;
}

- (void)setBackgroundTextColor:(UIColor *)backgroundTextColor {
    _backgroundTextColor = backgroundTextColor;
    self.backgroundLabel.textColor = backgroundTextColor;
}

- (void)setForegroundTextColor:(UIColor *)foregroundTextColor {
    _foregroundTextColor = foregroundTextColor;
    self.foregroundLabel.textColor = foregroundTextColor;
}

- (void)setIsPanGesture:(BOOL)isPanGesture {
    _isPanGesture = isPanGesture;
}

- (void)setIsAutoScroll:(BOOL)isAutoScroll {
    _isAutoScroll = isAutoScroll;
    isAutoScroll ? [self startTimer] : [self stopTimer];
}

- (BOOL)isRolling {
    return self.timer ? YES : NO;
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
