//
//  PickTeamViewController.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsTableViewController.h"

@interface PickTeamViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray* teams;
@property (nonatomic, weak) OptionsTableViewController* delegate;

@end
