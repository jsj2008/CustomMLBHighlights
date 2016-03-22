//
//  HighlightPackage.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighlightVideo.h"

@interface HighlightPackage : NSObject

@property (nonatomic, strong) NSMutableArray<HighlightVideo*>* videos;

- (id) initWithDictionary: (NSDictionary *) dict;
- (id) initWithSingleVideo: (HighlightVideo *) video;

@end
