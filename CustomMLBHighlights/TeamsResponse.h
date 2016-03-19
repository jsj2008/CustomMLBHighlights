//
//  TeamsResponse.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JSONObject.h"
#import "TeamAll.h"

@interface TeamsResponse : JSONObject

@property (nonatomic, strong) TeamAll* team_all;

@end
