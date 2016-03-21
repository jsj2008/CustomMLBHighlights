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

- (BOOL) isTodayOrYesterday
{
    if (!self.date_added)
        return NO;

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString* todayString = [formatter stringFromDate:[NSDate date]];
    NSString* yesterdayString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24]];
    return [self.date_added isEqualToString:todayString] || [self.date_added isEqualToString:yesterdayString];
}

@end
