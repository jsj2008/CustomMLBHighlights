//
//  JSONObject.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONObject : NSObject

- (id) initWithJSON: (NSDictionary *) dict;
- (NSDictionary *) toJSON;
- (NSData *) toJSONData;
- (NSString *) toJSONString;
- (NSMutableArray *) convertChildArrayToClass: (Class) c withValues: (NSObject *) child;
- (NSData *) convertJSON: (NSDictionary *) dict;

@end
