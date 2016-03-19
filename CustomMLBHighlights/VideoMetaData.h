//
//  VideoMetaData.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLData.h"

@interface VideoMetaData : NSObject<XMLData>

@property (nonatomic, strong) NSString* url;

@end
