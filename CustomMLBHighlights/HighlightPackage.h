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
@property (nonatomic, strong) NSMutableArray<NSString*>* keywordsUsed;

- (id) initWithDictionary: (NSDictionary *) dict;

@end
