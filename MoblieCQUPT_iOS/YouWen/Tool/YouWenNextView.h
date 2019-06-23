//
//  YouWenTimeView.h
//  MoblieCQUPT_iOS
//
//  Created by xiaogou134 on 2018/3/10.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransparentView.h"

@protocol getInformation <NSObject>

@optional
- (void)sendInformation:(NSString *)inf;

@end


@interface YouWenNextView : TransparentView

@property (nonatomic, weak) id<getInformation> delegate;
@property (nonatomic, strong) NSMutableString *inf;

//下一步按钮
@property (nonatomic, strong) UIButton *confirBtn;
//取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//标题
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setUpThemeUI;

- (void)setUpUI;

- (void)confirm;

- (void)cancel;

@end
