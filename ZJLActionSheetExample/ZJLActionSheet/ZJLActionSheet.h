//
//  ZJLActionSheet.h
//  ZJLActionSheetExample
//
//  Created by ZhongZhongzhong on 16/7/4.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJLActionItem;

@interface ZJLActionSheet : UIView
- (instancetype)initWithItemArray:(NSArray *)items;
- (void)show;
- (void)dismiss;
@end

@interface ZJLActionItem : NSObject
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^actionHandler)(void);

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)iconName action:(void(^)(void))actionHandler;
@end
