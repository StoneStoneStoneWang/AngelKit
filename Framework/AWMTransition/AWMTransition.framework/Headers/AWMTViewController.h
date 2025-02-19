//
//  AWMTViewController.h
//  ZTransiton
//
//  Created by three stone 王 on 2019/8/22.
//  Copyright © 2019 three stone 王. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AWMBase;
NS_ASSUME_NONNULL_BEGIN

@interface AWMTViewController : AWMBaseViewController 

@property(nonatomic,strong,readonly) UIPercentDrivenInteractiveTransition *awmInteractivePopTransition;

@property (nonatomic ,assign) BOOL canPanResponse;

- (void)handlePopRecognizer:(UIPanGestureRecognizer *)recognizer;

@end

NS_ASSUME_NONNULL_END
