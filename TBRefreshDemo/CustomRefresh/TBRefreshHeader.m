
//
//  TBRefreshHeader.m
//  TBRefreshDemo
//
//  Created by Tb on 2018/7/29.
//  Copyright © 2018年 Tb. All rights reserved.
//

// 图片路径
#ifndef MJRefreshFrameworkSrcName
#define MJRefreshFrameworkSrcName(file) [@"Frameworks/MJRefresh.framework/MJRefresh.bundle" stringByAppendingPathComponent:file]
#endif

#import "TBRefreshHeader.h"
#import "Masonry.h"
@interface TBRefreshHeader()
@property (weak, nonatomic) UIView *container;
/**菊花**/
@property (weak, nonatomic) UIImageView *loadingView;
/**提示语**/
@property (weak, nonatomic) UILabel *tipLabel;
/**箭头**/
@property (weak, nonatomic) UIImageView *arrowView;

@property (strong, nonatomic) NSMutableDictionary *stateTips;

@end

@implementation TBRefreshHeader

#pragma mark 监听控件的刷新状态

- (void)refreshAnimation {
    if (self.state == MJRefreshStateRefreshing) {
        if(self.superview && self.window) {
            [self.loadingView.layer removeAllAnimations];
            self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
            self.loadingView.hidden = NO;
            [self.loadingView.layer addAnimation:[self createRoteAnimation] forKey:@"transform.rotation.z"];
            self.arrowView.hidden = YES;
        }
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self refreshAnimation];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self refreshAnimation];
}

- (void)prepare
{
    [super prepare];
    
    self.mj_h = 50;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    int imageSize = 16;

    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
    }];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.container);
        make.left.equalTo(self.container);
        make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.container);
        make.left.equalTo(self.container);
        make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.arrowView.mas_right).offset(10);
        make.centerY.equalTo(self.container);
        make.right.equalTo(self.container);
    }];
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.tipLabel.text = self.stateTips[@(self.state)];
}


- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTips[@(state)] = title;
    self.tipLabel.text = self.stateTips[@(self.state)];
    
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView.layer removeAllAnimations];
                self.loadingView.hidden = YES;
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingView.layer removeAllAnimations];
            self.loadingView.hidden = YES;
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loadingView.layer removeAllAnimations];
        self.loadingView.hidden = YES;
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        self.loadingView.hidden = NO;
        [self.loadingView.layer addAnimation:[self createRoteAnimation] forKey:@"transfrom.rotation.z"];
        self.arrowView.hidden = YES;
    }
   
    [self layoutIfNeeded];
}


- (CABasicAnimation *)createRoteAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = 0;
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    animation.duration = 1.f;
    animation.repeatCount = MAXFLOAT;
    return animation;
}

- (UIView *)container
{
    if (!_container) {
        UIView *container = [UIView new];
        [self addSubview:container];
        _container = container;
    }
    return _container;
}
- (UIImageView *)loadingView
{
    if (!_loadingView) {
        UIImage *loadingImage = [UIImage imageNamed:@"followme_v2.0_loading_small"];
        UIImageView * loadingView = [[UIImageView  alloc] initWithImage:loadingImage];
        loadingView.hidden = YES;
        [self.container addSubview: _loadingView = loadingView];
    }
    return _loadingView;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImage *image = [UIImage imageNamed:@"followme_v2.0_loading_down"];
        if (!image) {
            image = [UIImage imageNamed:MJRefreshFrameworkSrcName(@"arrow.png")];
        }
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:image];
        [self.container addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        UILabel *tipLabel = [UILabel mj_label];
        tipLabel.font = [UIFont systemFontOfSize:14];
        [self.container addSubview:tipLabel];
        _tipLabel = tipLabel;
    }
    return _tipLabel;
}
- (NSMutableDictionary *)stateTips {
    if (!_stateTips) {
        _stateTips = [NSMutableDictionary new];
    }
    return _stateTips;
}


@end
