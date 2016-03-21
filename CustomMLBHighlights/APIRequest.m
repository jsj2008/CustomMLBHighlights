//
//  APIRequest.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "APIRequest.h"
#import "SearchResponse.h"
#import "TeamsResponse.h"

@implementation APIRequest

+ (APIRequest *) requestForFavorite: (Favorite*) favorite
{    
    NSString* qs = [favorite.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString* url = [NSString stringWithFormat:@"http://m.mlb.com/ws/search/MediaSearchService?query=%@&start=0&hitsPerPage=18&type=json&sort=desc&sort_type=date&bypass=y", qs];
    
    APIRequest* sendRequest = [[APIRequest alloc] init];
    sendRequest.url = url;
    sendRequest.returnType = [SearchResponse class];
    return sendRequest;
}

+ (APIRequest *) requestForTeams
{
    APIRequest* sendRequest = [[APIRequest alloc] init];
    sendRequest.url = @"http://mlb.com/lookup/json/named.team_all.bam?sport_code=%27mlb%27&active_sw=%27Y%27&all_star_sw=%27N%27";
    sendRequest.returnType = [TeamsResponse class];
    return sendRequest;
}

@end
