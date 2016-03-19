//
//  ViewController.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightPackage.h"

@interface FeedViewController : UITableViewController

@property (nonatomic, strong) HighlightPackage* package;

@end

