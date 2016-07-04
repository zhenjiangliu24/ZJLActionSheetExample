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
static const CGFloat ItemSpacing = 20.0;

@interface ZJLActionSheet()
@property (nonatomic, assign) CGRect sheetRect;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *dimView;
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
        [self initDimView];
        [self calculateHeight];
        [self initBackgoundView];
        [self initAllSubviews];
    }
    return self;
}

#pragma mark - dim view
- (void)initDimView
{
    _dimView = [[UIView alloc] initWithFrame:_sheetRect];
    _dimView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_dimView addGestureRecognizer:tap];
}

#pragma mark - background view
- (void)initBackgoundView
{
    self.backgroundColor = [UIColor clearColor];
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _sheetRect.size.width, _sheetHeight)];
    [self addBlurView];
    [self addSubview:_backgroundView];
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
        _backgroundView.backgroundColor = [UIColor lightGrayColor];
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

#pragma mark - init all subviews
- (void)initAllSubviews
{
    CGFloat height = 0.0;
    for (id item in _items) {
        if ([item isKindOfClass:[NSString class]]) {
            NSString *title = (NSString *)item;
            if ([title isEqualToString:@""]) {
                UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(0, height, _sheetRect.size.width, LineNoneTitleHeight)];
                [self addSubview:marginView];
                height += LineNoneTitleHeight;
            }else{
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height, _sheetRect.size.width, LineTitleHeight)];
                titleLabel.font = [UIFont systemFontOfSize:14.0];
                titleLabel.text = title;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:titleLabel];
                height += LineTitleHeight;
            }
        }else if ([item isKindOfClass:[NSArray class]]){
            NSArray *list = (NSArray *)item;
            UIScrollView *lineView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, _sheetRect.size.width, (ItemSize+ItemTitleHeight))];
            lineView.directionalLockEnabled = YES;
            lineView.showsVerticalScrollIndicator = NO;
            lineView.showsHorizontalScrollIndicator = NO;
            lineView.contentSize = CGSizeMake((ItemSize+ItemSpacing)*list.count+ItemSpacing, (ItemSize+ItemTitleHeight));
            [self addSubview:lineView];
            NSInteger index = 0;
            for (ZJLActionItem *actionItem in list) {
                UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
                icon.frame = CGRectMake(ItemSpacing+index*(ItemSize+ItemSpacing), 0, ItemSize, ItemSize);
                [icon setImage:[UIImage imageNamed:actionItem.iconName] forState:UIControlStateNormal];
                [icon addTarget:self action:@selector(iconClicked:) forControlEvents:UIControlEventTouchUpInside];
                [lineView addSubview:icon];
                [_buttons addObject:icon];
                
                UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(ItemSpacing+index*(ItemSize+ItemSpacing), ItemSize, ItemSize, ItemTitleHeight)];
                iconLabel.font = [UIFont systemFontOfSize:13.0];
                iconLabel.text = actionItem.title;
                iconLabel.textAlignment = NSTextAlignmentCenter;
                [lineView addSubview:iconLabel];
                [_actions addObject:actionItem.actionHandler];
                
                index++;
            }
            height += ItemSize+ItemTitleHeight;
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, height, _sheetRect.size.width, 0.5)];
            separator.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:separator];
        }
    }
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, height, _sheetRect.size.width, CancelButtonHeight);
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [cancelButton setTitle:NSLocalizedString(@"Cancel", @"cancel button name") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [self addSubview:cancelButton];
}

#pragma mark - icon clicked
- (void)iconClicked:(UIButton *)button
{
    NSInteger index = [_buttons indexOfObject:button];
    void(^handler)(void) = _actions[index];
    handler();
    [self dismiss];
}

#pragma mark - show
- (void)show
{
    self.window = [[UIWindow alloc] initWithFrame:self.sheetRect];
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = [UIViewController new];
    self.window.rootViewController.view.backgroundColor = [UIColor clearColor];
    
    [self.window.rootViewController.view addSubview:self.dimView];
    
    [self.window.rootViewController.view addSubview:self];
    
    self.window.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        self.frame = CGRectMake(0, self.sheetRect.size.height-self.sheetHeight, self.sheetRect.size.width, self.sheetHeight);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - dismiss
- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.dimView.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, _sheetRect.size.height, _sheetRect.size.width, _sheetHeight);
    } completion:^(BOOL finished) {
        self.window = nil;
    }];
}

@end

@implementation ZJLActionItem
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)iconName action:(void (^)(void))actionHandler
{
    if (self = [super init]) {
        _title = title;
        _iconName = iconName;
        _actionHandler = actionHandler;
    }
    return self;
}
@end