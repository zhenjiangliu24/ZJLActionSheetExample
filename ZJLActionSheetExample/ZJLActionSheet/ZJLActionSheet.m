//
//  ZJLActionSheet.m
//  ZJLActionSheetExample
//
//  Created by ZhongZhongzhong on 16/7/4.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLActionSheet.h"

static const CGFloat LineTitleHeight = 40.0;
static const CGFloat LineNoneTitleHeight = 20.0;
static const CGFloat ItemSize = 60.0;
static const CGFloat ItemTitleHeight = 30.0;
static const CGFloat CancelButtonHeight = 60.0;

@interface ZJLActionSheet()
@property (nonatomic, assign) CGRect sheetRect;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, assign) CGFloat sheetHeight;

@end

@implementation ZJLActionSheet
- (instancetype)initWithItemArray:(NSArray *)items
{
    self = [super init];
    if (self) {
        _items = items;
        _buttons = [NSMutableArray array];
        _actions = [NSMutableArray array];
        _sheetRect = [UIScreen mainScreen].bounds;
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.5 &&
            UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
            _sheetRect = CGRectMake(0, 0, _sheetRect.size.width, _sheetRect.size.height);
        }
        [self initBackgoundView];
        [self calculateHeight];
    }
    return self;
}

#pragma mark - background view
- (void)initBackgoundView
{
    _backgroundView = [[UIView alloc] initWithFrame:_sheetRect];
    [self addBlurView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView:)];
    [_backgroundView addGestureRecognizer:tap];
}

- (void)tapBackgroundView:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)addBlurView
{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        _backgroundView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = _backgroundView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_backgroundView addSubview:blurEffectView];
    }
    else {
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
}

#pragma mark - calculate sheet height
- (void)calculateHeight
{
    _sheetHeight = 0.0;
    for (id item in _items) {
        if ([item isKindOfClass:[NSString class]]) {
            NSString *title = (NSString *)item;
            if ([title isEqualToString:@""]) {
                _sheetHeight += LineNoneTitleHeight;
            }else{
                _sheetHeight += LineTitleHeight;
            }
        }else if ([item isKindOfClass:[NSArray class]]){
            _sheetHeight += ItemSize + ItemTitleHeight;
        }
    }
    _sheetHeight += CancelButtonHeight;
    self.frame = CGRectMake(0, _sheetRect.size.height, _sheetRect.size.width, _sheetHeight);
}

#pragma mark - show
- (void)show
{
    
}

#pragma mark - dismiss
- (void)dismiss
{
    
}
@end
