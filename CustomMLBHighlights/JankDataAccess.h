//
//  JankDataAccess.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighlightPackage.h"
#import "Favorite.h"

@interface JankDataAccess : NSObject

+ (NSMutableArray<HighlightPackage*>*) getFeed;
+ (void) saveHighlightPackage: (HighlightPackage *) package;
+ (NSMutableArray<Favorite*>*) getFavorites;
+ (void) saveDefaultFavorites;

@end
