//
//  VideoMetaData.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "VideoMetaData.h"

@implementation VideoMetaData

+ (NSString *) rootElementName
{
    return @"media";
}

- (void) processElement: (NSString *) name withValue: (NSString *) value
{
    if ([name isEqualToString:@"url"])
    {
        if (value != nil)
        {
            NSArray* split = [value componentsSeparatedByString:@","];
            for (NSString* quality in split)
            {
                if ([quality hasSuffix:@"_1200K.mp4"])
                {
                    self.url = quality;
                    break;
                }
            }
        }
    }
}

@end
