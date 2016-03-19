//
//  APIRequest.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favorite.h"

@interface APIRequest : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *parameters;
@property Class returnType;
@property (nonatomic, strong) NSDictionary *body;
@property (nonatomic, strong) NSData* postData;

+ (APIRequest *) requestForFavorite: (Favorite*) favorite;

@end
