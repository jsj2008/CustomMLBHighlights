//
//  ApplicationUIContext.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ApplicationUIContext : NSObject
{
    @private __weak UIWindow* primaryWindow_;
}

@property (nonatomic, strong) UINavigationController* currentModal;
@property (nonatomic, strong) UIView* loadingPanel;

+ (ApplicationUIContext *) getInstance;

- (UIWindow *) getPrimaryWindow;
- (void) setPrimaryWindow: (UIWindow *) window;
- (void) openModal: (UIViewController *) modal;
- (void) dismissModal;
- (void) showLoadingPanel;
- (void) hideLoadingPanel;

@end
