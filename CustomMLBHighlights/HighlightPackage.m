//
//  HighlightPackage.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "HighlightPackage.h"

@implementation HighlightPackage

- (id) initWithDictionary: (NSDictionary *) dict
{
    self = [super init];
    if (self)
    {
        NSMutableArray* savedVideos = (NSMutableArray *)[dict objectForKey:@"videos"];
        NSMutableArray<HighlightVideo*>* videos = [NSMutableArray array];
        for (NSDictionary *videoDict in savedVideos)
        {
            HighlightVideo* v = [[HighlightVideo alloc] initWithDictionary:videoDict];
            [videos addObject:v];
        }
        self.videos = videos;
    }
    return self;
}

- (id) initWithSingleVideo: (HighlightVideo *) video
{
    self = [super init];
    if (self)
    {
        self.videos = [NSMutableArray arrayWithObject:[[HighlightVideo alloc] initWithDictionary:[video toDictionary]]];
    }
    return self;
}

- (NSDictionary *) toDictionary
{
    NSMutableArray* videos = [NSMutableArray array];
    
    for (HighlightVideo* v in self.videos)
    {
        [videos addObject:v];
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:videos forKey:@"videos"];
    return dict;
}

@end
