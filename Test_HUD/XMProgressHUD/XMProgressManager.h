//
//  XMProgressHUD.h
//  Test_HUD
//
//  Created by Damo on 2018/12/6.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define kXMProgressManager [XMProgressManager now]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

typedef NS_ENUM(NSUInteger, XMHUDMaskType) {
    XMHUDMaskType_None = 0,                     //允许操作其他UI
    XMHUDMaskType_Clear,                        //不允许操作
};

typedef NS_ENUM(NSUInteger, XMHUDInViewType) {
    XMHUDInViewType_KeyWindow = 0,              //UIApplication.KeyWindow
    XMHUDInViewType_CurrentView,                //CurrentViewController.view
};

typedef NS_ENUM(NSUInteger, XMHUDShowStateType) {
    XMProgressHUDTypeSuccess = 1,               //成功
    XMProgressHUDTypeError,                     //失败
    XMProgressHUDTypeWarning,                   //警告
};

@interface XMProgressManager : NSObject

/**
 *简单的显示方法
 */
+ (MBProgressHUD *)XM_showLoadingOrdinary:(NSString *)loadingString;

/**
 *简单的显示方法(加在指定view上)
 */
+ (MBProgressHUD *)XM_showLoadingOrdinary:(NSString *)loadingString inView:(UIView *)inView;

/**
 *复杂的显示方式可以用此方法自定义
 */
+ (MBProgressHUD *)XM_showHUDCustom:(void (^)(XMProgressManager *make))block;

/**
 *简单的改变进度条值
 */
+ (void)XM_uploadProgressOrdinary:(CGFloat)progressValue;

/**
 *简单的改变进度条值(加在指定view上)
 */
+ (void)XM_uploadProgressOrdinary:(CGFloat)progressValue inView:(UIView *)inView;

/**
 *复杂的改变进度条值可以用此方法自定义
 */
+ (void)XM_uploadProgressValue:(void (^)(XMProgressManager *make))block;

/**
 *显示成功并自动消失
 */
+ (void)XM_showHUDWithSuccess:(NSString *)showString;

/**
 *显示成功并自动消失(指定view上)
 */
+ (void)XM_showHUDWithSuccess:(NSString *)showString inView:(UIView *)inView;

/**
 *显示错误并自动消失
 */
+ (void)XM_showHUDWithError:(NSString *)showString;

/**
 *显示错误并自动消失(指定view上)
 */
+ (void)XM_showHUDWithError:(NSString *)showString inView:(UIView *)inView;

/**
 *显示警告并自动消失
 */
+ (void)XM_showHUDWithWarning:(NSString *)showString;

/**
 *显示警告并自动消失(指定view上)
 */
+ (void)XM_showHUDWithWarning:(NSString *)showString inView:(UIView *)inView;

/**
 *显示纯文字并自动消失
 */
+ (void)XM_showHUDWithText:(NSString *)showString;

/**
 *显示纯文字并自动消失(指定view上)
 */
+ (void)XM_showHUDWithText:(NSString *)showString inView:(UIView *)inView;

/**
 *显示状态自定义（自动消失）
 */
+ (void)XM_showHUDWithState:(void (^)(XMProgressManager *make))block;

/**
 *直接消失
 */
+ (void)dissmissHUDDirect;

/**
 *直接消失（指定view）
 */
+ (void)dissmissHUDDirectInView:(UIView *)inView;
+ (void)dissmissHUD:(void (^)(XMProgressManager *make))block;


#pragma mark - 下面的代码，就是设置保存相应的参数，返回self，
// self=self.message(@"文字")，分两步
// (1)第一步：self.message首先是返回一个block;
// (2)第二步：self=self.messageblock(@"文字") block里面是{ self.msg=@"文字"; 返回self }.
// 对应一般的语法就是：self=[self message:@"文字"];就是这么个意思
/**
 .showMessage(@"需要显示的文字")
 */
- (XMProgressManager *(^)(NSString *))message;

/**
 .animated(YES)是否动画，YES动画，NO不动画
 */
- (XMProgressManager *(^)(BOOL))animated;

/**
 .inView(view)
 有特殊需要inView的才使用，一般使用.inViewType()
 */
- (XMProgressManager *(^)(UIView *))inView;

/**
 .inViewType(inViewType) 指定的InView
 PSHUDInViewType_KeyWindow--KeyWindow,配合MaskType_Clear，就是全部挡住屏幕不能操作了，只能等消失
 PSHUDInViewType_CurrentView--当前的ViewController,配合MaskType_Clear,就是view不能操作，但是导航栏能操作（例如返回按钮）。
 */
- (XMProgressManager *(^)(XMHUDMaskType))inViewType;

/**
 .maskType(MaskType) HUD显示是否允许操作背后,
 PSHUDMaskType_None:允许
 PSHUDMaskType_Clear:不允许
 */
- (XMProgressManager *(^)(XMHUDMaskType))maskType;

/**
 .customView(view),设置customView
 注：只对.showMessage(@"")有效
 */
- (XMProgressManager *(^)(UIView *))customView;

/**
 .customView(iconName)，带有小图标、信息,
 iconName:小图标名字
 注：只对.showMessage(@"")有效
 */
- (XMProgressManager *(^)(NSString *))customIconName;

/**
 .afterDelay(2)消失时间，默认是2秒
 注：只对.showHandleMessageCalculators有效
 */
- (XMProgressManager *(^)(NSTimeInterval))afterDelay;

/** 
 *设置弹窗颜色
 */
- (XMProgressManager *(^)(UIColor *))hudColor;

/**
 *设置显示模式（菊花、进度条、纯文字、自定义）
 */
- (XMProgressManager *(^)(MBProgressHUDMode))hudMode;

/**
 *显示状态(失败，成功，警告)
 */
- (XMProgressManager *(^)(XMHUDShowStateType))hudState;

/**
 *进度条进度
 */
- (XMProgressManager *(^)(CGFloat))progressValue;

/**
 *设置自定义动画的持续时间
 */
- (XMProgressManager *(^)(CGFloat))animationDuration;

/**
 *设置自定义动画的图片数组
 */
- (XMProgressManager *(^)(NSArray *))imageArray;

/**
 *内容颜色
 */
- (XMProgressManager *(^)(UIColor *))contentColor;

/**
 *一张图时的图片名字
 */
- (XMProgressManager *(^)(NSString *))imageStr;
@end
