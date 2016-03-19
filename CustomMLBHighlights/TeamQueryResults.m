//
//  TeamQueryResults.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "TeamQueryResults.h"

@implementation TeamQueryResults

- (id) initWithJSON: (NSDictionary *) dict
{
    self = [super initWithJSON:dict];
    
    if (self) {
        self.row = [self convertChildArrayToClass:[Team class] withValues:self.row];
    }
    
    return self;
}

@end
