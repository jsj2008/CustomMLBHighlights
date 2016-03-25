//
//  ApplicationUIContext.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "ApplicationUIContext.h"
#import "ApplicationColors.h"

@implementation ApplicationUIContext

static ApplicationUIContext* instance_;

+ (ApplicationUIContext *) getInstance
{
    if (instance_ == nil)
    {
        instance_ = [[ApplicationUIContext alloc] init];
    }
    
    return instance_;
}


- (UIWindow *) getPrimaryWindow
{
    return primaryWindow_;
}

- (void) setPrimaryWindow: (UIWindow *) window
{
    primaryWindow_ = window;
    UIColor* primary = [ApplicationColors primaryColor];
    primaryWindow_.tintColor = primary;
    [UINavigationBar appearance].tintColor = primary;
}

- (void) openModal:(UIViewController *)modal
{
    if (self.currentModal == nil)
    {
        UINavigationController* modalNav = [[UINavigationController alloc] initWithRootViewController:modal];
        modalNav.navigationBar.tintColor = [UIColor whiteColor];
        modalNav.navigationBar.barTintColor = [ApplicationColors primaryColor];
        modalNav.navigationBar.barStyle = UIBarStyleBlack;
        self.currentModal = modalNav;
        
        if (![self isPhone])
            modalNav.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [primaryWindow_.rootViewController presentViewController:modalNav animated:YES completion:nil];
    }
}

- (void) dismissModal
{
    if (self.currentModal != nil)
    {
        [self.currentModal dismissViewControllerAnimated:YES completion:^{
            self.currentModal = nil;
        }];
    }
}

- (void) showLoadingPanel
{
    if (self.loadingPanel != nil && self.loadingPanel.superview != nil)
    {
        return;
    }
    
    if (primaryWindow_ != nil)
    {
        if (self.loadingPanel == nil)
        {
            UIView* lp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            lp.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
            lp.layer.cornerRadius = 12.0f;
            
            UIActivityIndicatorView* loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [lp addSubview:loading];
            loading.center = CGPointMake(50.0f,50.0f);
            [loading startAnimating];
            
            lp.center = CGPointMake((primaryWindow_.frame.size.width) / 2.0f, (primaryWindow_.frame.size.height) / 2.0);
            
            self.loadingPanel = lp;
        }
        
        [primaryWindow_ addSubview:self.loadingPanel];
    }
}

- (void) hideLoadingPanel
{
    if (self.loadingPanel != nil && self.loadingPanel.superview != nil)
    {
        [self.loadingPanel removeFromSuperview];
    }
}

- (BOOL) isPhone
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return YES;
    }
    
    return NO;
}

@end
