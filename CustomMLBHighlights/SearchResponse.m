//
//  SearchResponse.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "SearchResponse.h"

@implementation SearchResponse

- (id) initWithJSON: (NSDictionary *) dict
{
    self = [super initWithJSON:dict];
    
    if (self) {
        self.mediaContent = [self convertChildArrayToClass:[MediaContent class] withValues:self.mediaContent];
    }
    
    return self;
}

@end
