//
//  MediaContent.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JSONObject.h"
#import "Thumbnail.h"

@interface MediaContent : JSONObject

@property (nonatomic, strong) NSString* blurb;
@property (nonatomic, strong) NSString* kicker;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* duration;
@property (nonatomic, strong) NSString* bigBlurb;
@property (nonatomic, strong) NSString* date_added;
@property (nonatomic, strong) NSMutableArray<Thumbnail*>* thumbnails;

- (BOOL) isTodayOrYesterday;

@end
