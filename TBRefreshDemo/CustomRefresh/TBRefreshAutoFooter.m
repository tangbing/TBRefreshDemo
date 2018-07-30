
//
//  TBRefreshAutoFooter.m
//  TBRefreshDemo
//
//  Created by Tb on 2018/7/28.
//  Copyright © 2018年 Tb. All rights reserved.
//

#import "TBRefreshAutoFooter.h"
#import "Masonry.h"
@interface TBRefreshAutoFooter()

@property (weak, nonatomic) UIView *container;
/**菊花**/
@property (weak, nonatomic) UIImageView *loadingView;
/**提示语**/
@property (weak, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) NSMutableDictionary *stateTips;


@end

@implementation TBRefreshAutoFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
     [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    int imageSize = 16;
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.container);
        make.left.mas_equalTo(self.container);
        make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
    }];
}
/*
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
    self.s.center = CGPointMake(self.mj_w - 20, self.mj_h - 20);
    
    self.loading.center = CGPointMake(30, self.mj_h * 0.5);
}
*/
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTips[@(state)] = title;
    self.tipLabel.text = self.stateTips[@(self.state)];
}

- (void)updateConstraints {
    if (!_tipLabel) {
        return;
    }
    
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.container);
        if (self.state == MJRefreshStateNoMoreData || self.state == MJRefreshStateIdle) {
            make.left.right.mas_equalTo(self.container);
        }else {
            make.left.mas_equalTo(self.loadingView.mas_right).offset(10);
            make.right.mas_equalTo(self.container);
        }
        
    }];
    
    [super updateConstraints];
}
#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    self.tipLabel.text = self.stateTips[@(state)];

    if (state == MJRefreshStateIdle || state == MJRefreshStateNoMoreData) {
        [self.loadingView.layer removeAllAnimations];
        self.loadingView.hidden = YES;
    } else if (MJRefreshStateRefreshing) {
         self.loadingView.hidden = NO;
         [self.loadingView.layer addAnimation:[self createRoteAnimation] forKey:@"transform.rotation.z"];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    [self layoutIfNeeded];
    
//    switch (state) {
//        case MJRefreshStateIdle:
//            self.label.text = @"赶紧上拉吖(开关是打酱油滴)";
//            [self.loading stopAnimating];
//            [self.s setOn:NO animated:YES];
//            break;
//        case MJRefreshStateRefreshing:
//            [self.s setOn:YES animated:YES];
//            self.label.text = @"加载数据中(开关是打酱油滴)";
//            [self.loading startAnimating];
//            break;
//        case MJRefreshStateNoMoreData:
//            self.label.text = @"木有数据了(开关是打酱油滴)";
//            [self.s setOn:NO animated:YES];
//            [self.loading stopAnimating];
//            break;
//        default:
//            break;
//    }
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
        [self.container addSubview: _loadingView = loadingView];
        
    }
    return _loadingView;
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
