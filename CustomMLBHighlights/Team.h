//
//  Team.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JSONObject.h"
@import UIKit;

@interface Team : JSONObject

@property (nonatomic, strong) NSString* name_abbrev;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* name_display_full;

- (UIImage *) getLogo;

@end
