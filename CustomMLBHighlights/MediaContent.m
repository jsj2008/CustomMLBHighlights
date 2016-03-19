//
//  MediaContent.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "MediaContent.h"

@implementation MediaContent

- (id) initWithJSON: (NSDictionary *) dict
{
    self = [super initWithJSON:dict];
    
    if (self) {
        self.thumbnails = [self convertChildArrayToClass:[Thumbnail class] withValues:self.thumbnails];
    }
    
    return self;
}

@end
