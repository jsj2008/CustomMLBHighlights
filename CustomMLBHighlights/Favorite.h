//
//  Favorite.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Favorite : NSObject

@property NSInteger type;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* keyword;

- (id) initWithDictionary: (NSDictionary *) dict;
- (NSDictionary *) toDictionary;

@end
