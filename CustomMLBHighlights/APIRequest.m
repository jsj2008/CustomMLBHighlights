//
//  APIRequest.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "APIRequest.h"
#import "SearchResponse.h"

@implementation APIRequest

+ (APIRequest *) requestForFavorite: (Favorite*) favorite
{
    //NSMutableString* qs = [[NSMutableString alloc] init];
    
    //int i = 0;
    
    /*
    for (Favorite* f in favorites)
    {
        [qs appendString:f.keyword];
        if (i < favorites.count - 1)
        {
            [qs appendString:@" "];
        }
        i++;
    }
     */
    
    NSString* url = [[NSString stringWithFormat:@"http://m.mlb.com/ws/search/MediaSearchService?query=%@&start=0&hitsPerPage=18&type=json&sort=desc&sort_type=date&bypass=y", favorite.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    APIRequest* sendRequest = [[APIRequest alloc] init];
    sendRequest.url = url;
    sendRequest.returnType = [SearchResponse class];
    return sendRequest;
}

@end
