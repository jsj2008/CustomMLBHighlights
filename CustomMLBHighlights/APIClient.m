//
//  APIClient.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "APIClient.h"
#import "JSONObject.h"

@implementation APIClient

+ (void) processRequest: (APIRequest *) apiRequest completion: (completionBlock) onComplete
{
    NSMutableURLRequest *request = [APIClient getRequestForAPI:apiRequest];
    if (request == nil)
    {
        onComplete(YES, nil);
        return;
    }
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *getTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [APIClient processResults:data fromResponse:response withError:error returnType:apiRequest.returnType completion:onComplete];
    }];
    [getTask resume];
}

+ (NSMutableURLRequest *) getRequestForAPI: (APIRequest *) apiRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiRequest.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1000];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    if (apiRequest.postData != nil)
    {
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)[apiRequest.postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: apiRequest.postData];
    }
    
    return request;
}

+ (void) processResults: (NSData *) data fromResponse: (NSURLResponse *) response withError: (NSError *) error returnType: (Class) type completion: (completionBlock) onComplete
{
    if (error != nil || ((NSHTTPURLResponse*)response).statusCode != 200 || data == nil)
    {
        NSString* url = @"(response or url was nil)";
        if (response != nil && response.URL != nil)
            url = response.URL.absoluteString;
        
        NSString* errorReported = @"(no error reported)";
        if (error != nil)
            errorReported = [NSString stringWithFormat:@"%@", error];
        
        APIRequestResult result = Error;
        //If status code is 401, mark that auth is required and let UI determine how to ask for credentials
        if (((NSHTTPURLResponse*)response).statusCode == 401)
        {
            result = Unauthorized;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(result, nil);
        });
    }
    else
    {
        NSError *myError = nil;
        NSMutableArray *retrieved = nil;
        
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&myError];
        
        if(res != nil) {
            BOOL multiItems = NO;
            for(id t in res) {
                if([t isKindOfClass:[NSDictionary class]]) {
                    multiItems = YES;
                    if(![t isKindOfClass:[NSNull class]]) {
                        JSONObject *temp = [(JSONObject *)[type alloc] initWithJSON:t];
                        if(retrieved == nil) {
                            retrieved = [[NSMutableArray alloc] init];
                        }
                        [retrieved addObject:temp];
                    }
                }
            }
            
            if(!multiItems) {
                if(res.count > 0) {
                    JSONObject *temp = [(JSONObject *)[type alloc] initWithJSON:res];
                    retrieved = [NSMutableArray arrayWithObject:temp];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onComplete(Success, retrieved);
        });
    }
}

@end
