//
//  OptionsTableViewController.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorite.h"

@interface OptionsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<Favorite*>* favorites;
@property (nonatomic, weak) UITextField* txtPlayerName;

- (void) addFavorite: (Favorite *) fav;

@end
