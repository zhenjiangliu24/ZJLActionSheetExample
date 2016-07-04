//
//  ViewController.m
//  ZJLActionSheetExample
//
//  Created by ZhongZhongzhong on 16/7/4.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ViewController.h"
#import "ZJLActionSheet/ZJLActionSheet.h"

@interface ViewController ()
@property (nonatomic, copy) NSArray *items;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZJLActionItem *google = [[ZJLActionItem alloc] initWithTitle:@"Google" icon:@"google" action:^{
        NSLog(@"you clicked google");
    }];
    
    ZJLActionItem *wechat = [[ZJLActionItem alloc] initWithTitle:@"Wechat" icon:@"wechat" action:^{
        NSLog(@"you clicked wechat");
    }];
    ZJLActionItem *facebook = [[ZJLActionItem alloc] initWithTitle:@"Facebook" icon:@"facebook" action:^{
        NSLog(@"you clicked facebook");
    }];
    ZJLActionItem *twitter = [[ZJLActionItem alloc] initWithTitle:@"Twitter" icon:@"twitter" action:^{
        NSLog(@"you clicked twitter");
    }];
    ZJLActionItem *sns = [[ZJLActionItem alloc] initWithTitle:@"Sns" icon:@"sns" action:^{
        NSLog(@"you clicked sns");
    }];
    _items = [NSArray arrayWithObjects:google,twitter,wechat,sns,facebook, nil];
    
}
- (IBAction)showOneLine:(id)sender {
    NSArray *action = [NSArray arrayWithObjects:_items[0],_items[1],_items[4],_items[2],_items[3], nil];
    NSArray *list = @[@"",action];
    ZJLActionSheet *asView = [[ZJLActionSheet alloc] initWithItemArray:list];
    [asView show];
}
- (IBAction)showTwoLines:(id)sender {
    NSArray *action1 = [NSArray arrayWithObjects:_items[0],_items[1], nil];
    NSArray *action2 = [NSArray arrayWithObjects:_items[0],_items[1],_items[4],_items[2],_items[3], nil];
    NSArray *list = @[@"Line 1",action1,@"Line 2",action2];
    ZJLActionSheet *asView2 = [[ZJLActionSheet alloc] initWithItemArray:list];
    [asView2 show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
