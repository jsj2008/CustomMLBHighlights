//
//  Team.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "Team.h"

@implementation Team

- (UIImage *) getLogo
{
    NSString* url = [NSString stringWithFormat:@"http://mlb.mlb.com/mlb/images/team_logos/logo_%@_79x76.jpg", [self.name_abbrev lowercaseString]];
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
}

@end
