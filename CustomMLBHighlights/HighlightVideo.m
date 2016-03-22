//
//  HighlightVideo.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "HighlightVideo.h"
#import "XMLParser.h"
#import "VideoMetaData.h"

@implementation HighlightVideo

- (id) initWithDictionary: (NSDictionary *) dict
{
    self = [super init];
    if (self)
    {
        self.metaUrl = [dict objectForKey:@"metaUrl"];
        self.videoUrl = [dict objectForKey:@"videoUrl"];
        self.headline = [dict objectForKey:@"headline"];
        self.duration = [dict objectForKey:@"duration"];
        self.thumbnailUrl = [dict objectForKey:@"thumbnailUrl"];
        self.bigBlurb = [dict objectForKey:@"bigBlurb"];
        self.dayCreated = [dict objectForKey:@"dayCreated"];
        self.keyword = [dict objectForKey:@"keyword"];
    }
    return self;
}

- (NSDictionary *) toDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:self.metaUrl forKey:@"metaUrl"];
    [dict setObject:self.videoUrl forKey:@"videoUrl"];
    [dict setObject:self.headline forKey:@"headline"];
    [dict setObject:self.duration forKey:@"duration"];
    [dict setObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [dict setObject:self.bigBlurb forKey:@"bigBlurb"];
    [dict setObject:self.dayCreated forKey:@"dayCreated"];
    [dict setObject:self.keyword forKey:@"keyword"];
    return dict;
}

- (void) initializeVideoURL: (void(^)()) onComplete
{
    if (self.videoUrl != nil && self.videoUrl.length > 0)
    {
        if (onComplete)
            onComplete();
    }
    else if (self.metaUrl != nil && self.metaUrl.length > 0)
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.metaUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1000];
        NSURLSession *urlSession = [NSURLSession sharedSession];
        NSURLSessionDataTask *getTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error)
            {
                XMLParser* xml = [[XMLParser alloc] init];
                NSMutableArray* obj = [xml getObjectsOfType:[VideoMetaData class] fromXMLData:data];
                if (obj != nil && obj.count > 0)
                {
                    self.videoUrl = ((VideoMetaData *)[obj objectAtIndex:0]).url;
                    if (onComplete)
                        onComplete();
                }
            }			
        }];
        [getTask resume];
    }
}

@end
