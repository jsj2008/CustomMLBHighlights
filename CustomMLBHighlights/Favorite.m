//
//  Favorite.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "Favorite.h"

@implementation Favorite

- (id) initWithDictionary: (NSDictionary *) dict
{
    self = [super init];
    if (self)
    {
        self.type = ((NSNumber*)[dict objectForKey:@"type"]).integerValue;
        self.name = [dict objectForKey:@"name"];
        self.keyword = [dict objectForKey:@"keyword"];
    }
    return self;
}

- (NSDictionary *) toDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:self.keyword forKey:@"keyword"];
    return dict;
}

@end
