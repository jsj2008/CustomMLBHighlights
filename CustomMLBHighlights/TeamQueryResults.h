//
//  TeamQueryResults.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JSONObject.h"
#import "Team.h"

@interface TeamQueryResults : JSONObject

@property (nonatomic, strong) NSMutableArray<Team*>* row;

@end
