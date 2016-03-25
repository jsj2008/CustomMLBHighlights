//
//  JankDataAccess.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JankDataAccess.h"


#define FAVORITES               @"favorites"
#define HIGHLIGHT_PACKAGES      @"highlight_packages"
#define VIDEO_LIMIT             @"video_limit"

@implementation JankDataAccess

+ (NSMutableArray<HighlightPackage*>*) getFeed
{
    NSMutableArray<HighlightPackage*>* typedPackages = [NSMutableArray array];
    NSMutableArray* packages = [JankDataAccess getArray:HIGHLIGHT_PACKAGES];
    for (NSDictionary* package in packages)
    {
        HighlightPackage* p = [[HighlightPackage alloc] initWithDictionary:package];
        [typedPackages addObject:p];
    }
    return typedPackages;
}

+ (void) saveHighlightPackage: (HighlightPackage *) package
{
    NSMutableArray* packages = [JankDataAccess getArray:HIGHLIGHT_PACKAGES];
    [packages addObject:package];
    [[NSUserDefaults standardUserDefaults] setObject:package forKey:HIGHLIGHT_PACKAGES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray<Favorite*>*) getFavorites
{
    NSMutableArray<Favorite*>* typeFavorites = [NSMutableArray array];
    NSMutableArray* favorites = [JankDataAccess getArray:FAVORITES];
    for (NSDictionary* fav in favorites)
    {
        Favorite* f = [[Favorite alloc] initWithDictionary:fav];
        [typeFavorites addObject:f];
    }
    return typeFavorites;
}

+ (NSMutableArray *) getArray: (NSString *) key
{
    id ar = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (ar == nil)
    {
        NSMutableArray* newAR = [NSMutableArray array];
        [[NSUserDefaults standardUserDefaults] setObject:newAR forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return newAR;
    }
    else
    {
        return (NSMutableArray*)ar;
    }
}

+ (NSMutableDictionary *) getDictionary: (NSString *) key
{
    id dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (dict == nil)
    {
        NSMutableDictionary* newDict = [NSMutableDictionary dictionary];
        [[NSUserDefaults standardUserDefaults] setObject:newDict forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return newDict;
    }
    else
    {
        return (NSMutableDictionary*)dict;
    }
}

+ (void) saveDefaultFavorites
{
    Favorite* team = [[Favorite alloc] init];
    team.name = @"Boston Red Sox";
    team.keyword = @"red sox";
    team.type = 1;
    
    Favorite* player = [[Favorite alloc] init];
    player.name = @"Kevin Gausman";
    player.keyword = @"gausman";
    player.type = 2;

    Favorite* player2 = [[Favorite alloc] init];
    player2.name = @"Aaron Nola";
    player2.keyword = @"aaron nola";
    player2.type = 2;

    Favorite* play = [[Favorite alloc] init];
    play.name = @"Homeruns";
    play.keyword = @"homerun";
    play.type = 3;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithObjects:[team toDictionary], [player toDictionary], [player2 toDictionary], [play toDictionary], nil] forKey:FAVORITES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void) saveFavorites: (NSMutableArray<Favorite*>*) favs
{
    NSMutableArray<NSDictionary*>* arr = [NSMutableArray array];
    for (Favorite* f in favs)
    {
        [arr addObject:[f toDictionary]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:FAVORITES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger) getVideoLimit
{
    id num = [[NSUserDefaults standardUserDefaults] objectForKey:VIDEO_LIMIT];
    if (num == nil)
    {
        NSInteger defaultLimit = 3;
        [JankDataAccess saveVideoLimit:defaultLimit];
        return defaultLimit;
    }
    
    return ((NSNumber *)num).integerValue;
}

+ (void) saveVideoLimit: (NSInteger) limit
{
    if (limit <= 0)
        return;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(limit) forKey:VIDEO_LIMIT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
