//
//  SearchResponse.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JSONObject.h"
#import "MediaContent.h"

@interface SearchResponse : JSONObject

@property (nonatomic, strong) NSNumber* total;
@property (nonatomic, strong) NSString* query;
@property (nonatomic, strong) NSMutableArray<MediaContent*>* mediaContent;

@end
