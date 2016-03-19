//
//  APIClient.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"

typedef enum
{
    Success = 0,
    Error = 1,
    Unauthorized = 2
} APIRequestResult;

typedef void (^completionBlock)(APIRequestResult result, NSMutableArray *objsRetrieved);

@interface APIClient : NSObject

+ (void) processRequest: (APIRequest *) apiRequest completion: (completionBlock) onComplete;

@end
