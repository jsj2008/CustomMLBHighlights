//
//  Thumbnail.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JSONObject.h"

@interface Thumbnail : JSONObject

@property (nonatomic, strong) NSString* src;
@property (nonatomic, strong) NSString* type;

@end
