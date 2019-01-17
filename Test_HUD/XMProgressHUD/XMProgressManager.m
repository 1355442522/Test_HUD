//
//  XMProgressHUD.h
//  Test_HUD
//
//  Created by Damo on 2018/12/6.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "XMProgressManager.h"

@interface XMProgressManager () <MBProgressHUDDelegate>

//全都可以使用的参数
@property (nonatomic, strong) UIView        *xm_inView;     /**<hud加在那个view上*/
@property (nonatomic, assign) BOOL          xm_animated;    /**<是否动画显示、消失*/
@property (nonatomic, assign) XMHUDMaskType xm_maskType;    /**<hud背后的view是否还可以操作*/

//只有showHandleMessage可以使用的属性
@property (nonatomic, strong) UIView            *xm_customView;     /**<自定义的view*/
@property (nonatomic, strong) NSString          *xm_customIconName; /**<自定义的小图标*/
@property (nonatomic, strong) NSString          *xm_message;        /**<hud上面的文字*/
@property (nonatomic, assign) NSTimeInterval    xm_afterDelay;      /**<自动消失时间*/
@property (nonatomic, strong) UIColor           *xm_HUDColor;       /**自定义弹框颜色*/
@property (nonatomic, strong) UIColor           *xm_ContentColor;   /**自定义内容颜色*/
@property (nonatomic, assign) MBProgressHUDMode xm_hudMode;         /**弹窗模式*/

/**
 *设置全局的HUD
 */
@property (nonatomic, assign) XMHUDShowStateType xm_hudState;

/**
 *进度条进度
 */
@property (nonatomic, assign) CGFloat xm_progressValue;

/**
 *自定义动画的持续时间
 */
@property (nonatomic, assign) CGFloat xm_animationDuration;

/**
 *自定义动画的图片数组
 */
@property (nonatomic, strong) NSArray *xm_imageArray;

/**
 *自定义的图片名称
 */
@property (nonatomic, strong) NSString *xm_imageStr;
@end


@implementation XMProgressManager

#pragma mark - 简单的显示方法
+ (MBProgressHUD *)XM_showLoadingOrdinary:(NSString *)loadingString {
    return [XMProgressManager XM_showHUDCustom:^(XMProgressManager *make) {
        make.message(loadingString);
    }];
}

#pragma mark - 简单的显示方法(加在指定view上)
+ (MBProgressHUD *)XM_showLoadingOrdinary:(NSString *)loadingString inView:(UIView *)inView {
    return [XMProgressManager XM_showHUDCustom:^(XMProgressManager *make) {
        make.inView(inView).message(loadingString);
    }];
}

#pragma mark - 复杂的显示方式可以用此方法自定义
+ (MBProgressHUD *)XM_showHUDCustom:(void (^)(XMProgressManager *make))block {
    XMProgressManager *makeObj = [[XMProgressManager alloc] init];
    if (block) {
        block(makeObj);
    }
    __block MBProgressHUD *hud = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [XMProgressManager configHUDWithMakeObj:makeObj];
        
        switch (makeObj.xm_hudMode) {
            case MBProgressHUDModeIndeterminate:
                hud.minSize=CGSizeMake(90, 100);
                break;
            case MBProgressHUDModeDeterminate:
                
                break;
            case MBProgressHUDModeDeterminateHorizontalBar:
                
                break;
            case MBProgressHUDModeAnnularDeterminate:
                
                break;
            case MBProgressHUDModeCustomView: {
                if (makeObj.xm_imageArray.count > 0) {
                    UIImage *image = [[makeObj.xm_imageArray firstObject] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    
                    UIImageView* mainImageView= [[UIImageView alloc] initWithImage:image];
                    mainImageView.animationImages = makeObj.xm_imageArray;
                    [mainImageView setAnimationDuration:makeObj.xm_animationDuration];
                    [mainImageView setAnimationRepeatCount:0];
                    [mainImageView startAnimating];
                    hud.customView = mainImageView;
                }else if (makeObj.xm_imageStr.length > 0) {
                    
                    hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:makeObj.xm_imageStr] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
                }
                
                if (CGColorEqualToColor(makeObj.xm_HUDColor.CGColor, rgba(0, 0, 0, 0.7).CGColor)) {
                    hud.bezelView.color = rgba(255, 255, 255, 0.8);
                    hud.contentColor = [UIColor blackColor];
                }else {
                    hud.bezelView.color = makeObj.xm_HUDColor;
                    hud.contentColor = makeObj.xm_ContentColor;
                }
            }
                
                break;
            case MBProgressHUDModeText:
                
                break;
            default:
                break;
        }
    });
    return hud;
}

#pragma mark - 简单的改变进度条值
+ (void)XM_uploadProgressOrdinary:(CGFloat)progressValue {
    [XMProgressManager XM_uploadProgressValue:^(XMProgressManager *make) {
        make.progressValue(progressValue);
    }];
}

#pragma mark - 简单的改变进度条值(加在指定view上)
+ (void)XM_uploadProgressOrdinary:(CGFloat)progressValue inView:(UIView *)inView {
    [XMProgressManager XM_uploadProgressValue:^(XMProgressManager *make) {
        make.inView(inView).progressValue(progressValue);
    }];
}

#pragma mark - 复杂的改变进度条值可以用此方法自定义
+ (void)XM_uploadProgressValue:(void (^)(XMProgressManager *make))block {
    XMProgressManager *makeObj = [[XMProgressManager alloc] init];
    if (block) {
        block(makeObj);
    }
    __block MBProgressHUD *hud = [MBProgressHUD HUDForView:makeObj.xm_inView];
    hud.progress = makeObj.xm_progressValue;
}

#pragma mark - 显示成功并自动消失
+ (void)XM_showHUDWithSuccess:(NSString *)showString {
    [XMProgressManager XM_showHUDWithState:^(XMProgressManager *make) {
        make.hudState(XMProgressHUDTypeSuccess).message(showString);
    }];
}

#pragma mark - 显示成功并自动消失(指定view上)
+ (void)XM_showHUDWithSuccess:(NSString *)showString inView:(UIView *)inView {
    [XMProgressManager XM_showHUDWithState:^(XMProgressManager *make) {
        make.inView(inView).hudState(XMProgressHUDTypeSuccess).message(showString);
    }];
}

#pragma mark - 显示错误并自动消失
+ (void)XM_showHUDWithError:(NSString *)showString {
    [XMProgressManager XM_showHUDWithState:^(XMProgressManager *make) {
        make.hudState(XMProgressHUDTypeError).message(showString);
    }];
}

#pragma mark - 显示错误并自动消失(指定view上)
+ (void)XM_showHUDWithError:(NSString *)showString inView:(UIView *)inView {
    [XMProgressManager XM_showHUDWithState:^(XMProgressManager *make) {
        make.inView(inView).hudState(XMProgressHUDTypeError).message(showString);
    }];
}

#pragma mark - 显示警告并自动消失
+ (void)XM_showHUDWithWarning:(NSString *)showString {
    [XMProgressManager XM_showHUDWithState:^(XMProgressManager *make) {
        make.hudState(XMProgressHUDTypeWarning).message(showString);
    }];
}

#pragma mark - 显示警告并自动消失(指定view上)
+ (void)XM_showHUDWithWarning:(NSString *)showString inView:(UIView *)inView {
    [XMProgressManager XM_showHUDWithState:^(XMProgressManager *make) {
        make.inView(inView).hudState(XMProgressHUDTypeWarning).message(showString);
    }];
}

#pragma mark - 显示纯文字并自动消失
+ (void)XM_showHUDWithText:(NSString *)showString {
    [XMProgressManager XM_showHUDWithState:^(XMProgressManager *make) {
        make.message(showString);
    }];
}

#pragma mark - 显示纯文字并自动消失(指定view上)
+ (void)XM_showHUDWithText:(NSString *)showString inView:(UIView *)inView {
    [XMProgressManager XM_showHUDWithState:^(XMProgressManager *make) {
        make.inView(inView).message(showString);
    }];
}

#pragma mark - 显示状态自定义（自动消失）
+ (void)XM_showHUDWithState:(void (^)(XMProgressManager *make))block {
    XMProgressManager *makeObj = [[XMProgressManager alloc] init];
    if (block) {
        block(makeObj);
    }
    __block MBProgressHUD *hud = [MBProgressHUD HUDForView:makeObj.xm_inView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!hud) {
            hud = [XMProgressManager configHUDWithMakeObj:makeObj];
        }
        hud.mode = MBProgressHUDModeCustomView;
        hud.detailsLabel.text=makeObj.xm_message;
        hud.userInteractionEnabled=makeObj.xm_maskType;
        
        NSString *imageStr = @"";
        if (makeObj.xm_hudState == XMProgressHUDTypeSuccess) {
            imageStr = @"hudSuccess";
        }else if (makeObj.xm_hudState == XMProgressHUDTypeError) {
            imageStr = @"hudError";
        }else if (makeObj.xm_hudState == XMProgressHUDTypeWarning) {
            imageStr = @"hudInfo";
        }else {
            hud.minSize=CGSizeMake(40,30);
        }
        hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        [hud hideAnimated:makeObj.xm_animated afterDelay:makeObj.xm_afterDelay];
    });
    
}

#pragma mark - 直接消失
+ (void)dissmissHUDDirect {
    [XMProgressManager dissmissHUD:nil];
}

#pragma mark - 直接消失（指定view）
+ (void)dissmissHUDDirectInView:(UIView *)inView {
    [XMProgressManager dissmissHUD:^(XMProgressManager *make) {
        make.inView(inView);
    }];
}

+ (void)dissmissHUD:(void (^)(XMProgressManager *make))block {
    XMProgressManager *makeObj = [[XMProgressManager alloc] init];
    if (block) {
        block(makeObj);
    }
    __block MBProgressHUD *hud = [MBProgressHUD HUDForView:makeObj.xm_inView];
    [hud hideAnimated:makeObj.xm_animated];
}

+ (MBProgressHUD *)configHUDWithMakeObj:(XMProgressManager *)makeObj {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:makeObj.xm_inView animated:makeObj.xm_animated];
    hud.detailsLabel.text = makeObj.xm_message;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0];
    hud.bezelView.color = makeObj.xm_HUDColor;
    hud.contentColor = makeObj.xm_ContentColor;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.userInteractionEnabled=makeObj.xm_maskType;
    hud.mode = makeObj.xm_hudMode;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

- (instancetype)init {
    
    self=[super init];
    if (self) {//这里可以设置一些默认的属性
        _xm_inView=[UIApplication sharedApplication].keyWindow;
        _xm_maskType=XMHUDMaskType_Clear;
        _xm_afterDelay=0.6;
        _xm_animated = YES;
        _xm_HUDColor = rgba(0, 0, 0, 0.7);
        _xm_ContentColor = [UIColor whiteColor];
        _xm_hudMode = MBProgressHUDModeIndeterminate;
    }
    return self;
}

- (XMProgressManager *(^)(UIView *))inView{
    return ^XMProgressManager *(id obj) {
        self.xm_inView=obj;
        return self;
    };
}

- (XMProgressManager *(^)(UIView *))customView{
    return ^XMProgressManager *(id obj) {
        self.xm_customView=obj;
        return self;
    };
}

- (XMProgressManager *(^)(NSString *))customIconName{
    return ^XMProgressManager *(id obj) {
        self.xm_customIconName=obj;
        return self;
    };
}

- (XMProgressManager *(^)(XMHUDMaskType))inViewType{
    
    return ^XMProgressManager *(XMHUDMaskType inViewType) {
        
        if (inViewType==XMHUDInViewType_KeyWindow) {
            self.xm_inView=[UIApplication sharedApplication].keyWindow;
        }else if(inViewType==XMHUDInViewType_CurrentView){
            self.xm_inView=[[UIApplication sharedApplication].delegate window].rootViewController.view;
        }
        return self;
    };
}


- (XMProgressManager *(^)(BOOL))animated {
    return ^XMProgressManager *(BOOL animated) {
        self.xm_animated=animated;
        return self;
    };
}

- (XMProgressManager *(^)(XMHUDMaskType))maskType{
    return ^XMProgressManager *(XMHUDMaskType maskType) {
        self.xm_maskType=maskType;
        return self;
    };
}

- (XMProgressManager *(^)(NSTimeInterval))afterDelay{
    return ^XMProgressManager *(NSTimeInterval afterDelay) {
        self.xm_afterDelay=afterDelay;
        return self;
    };
}

- (XMProgressManager *(^)(NSString *))message {
    
    return ^XMProgressManager *(NSString *msg) {
        self.xm_message=msg;
        return self;
    };
}

- (XMProgressManager *(^)(UIColor *))hudColor {
    return ^XMProgressManager *(UIColor *hudColor) {
        self.xm_HUDColor = hudColor;
        return self;
    };
}

- (XMProgressManager *(^)(MBProgressHUDMode))hudMode {
    return ^XMProgressManager *(MBProgressHUDMode hudMode) {
        self.xm_hudMode = hudMode;
        return self;
    };
}

- (XMProgressManager *(^)(XMHUDShowStateType))hudState {
    return ^XMProgressManager *(XMHUDShowStateType hudState) {
        self.xm_hudState = hudState;
        return self;
    };
}

- (XMProgressManager *(^)(CGFloat))progressValue {
    return ^XMProgressManager *(CGFloat value) {
        self.xm_progressValue = value;
        return self;
    };
}

- (XMProgressManager *(^)(CGFloat))animationDuration {
    return ^XMProgressManager *(CGFloat duration) {
        self.xm_animationDuration = duration;
        return self;
    };
}

- (XMProgressManager *(^)(NSArray *))imageArray {
    return ^XMProgressManager *(NSArray *imageArray) {
        self.xm_imageArray = [NSArray arrayWithArray:imageArray];
        return self;
    };
}

- (XMProgressManager *(^)(UIColor *))contentColor {
    return ^XMProgressManager *(UIColor *contentColor) {
        self.xm_ContentColor = contentColor;
        return self;
    };
}

- (XMProgressManager *(^)(NSString *))imageStr {
    return ^XMProgressManager *(NSString *imageString) {
        self.xm_imageStr = imageString;
        return self;
    };
}
@end
