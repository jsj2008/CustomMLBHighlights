//
//  TeamAll.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JSONObject.h"
#import "TeamQueryResults.h"

@interface TeamAll : JSONObject

@property (nonatomic, strong) TeamQueryResults* queryResults;

@end
