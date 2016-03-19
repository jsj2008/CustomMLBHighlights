//
//  PickTeamViewController.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "PickTeamViewController.h"
#import "APIClient.h"
#import "APIRequest.h"
#import "TeamsResponse.h"
#import "ApplicationUIContext.h"

@implementation PickTeamViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Select Team";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self getTeams];
}

- (void) getTeams
{
    [[ApplicationUIContext getInstance] showLoadingPanel];
    
    [APIClient processRequest:[APIRequest requestForTeams] completion:^(APIRequestResult result, NSMutableArray* objs) {
       if (result == Success)
       {
           if (objs != nil && objs.count > 0)
           {
               TeamsResponse* resp = (TeamsResponse *)[objs objectAtIndex:0];
               if (resp.team_all != nil && resp.team_all.queryResults != nil && resp.team_all.queryResults.row != nil)
               {
                   self.teams = resp.team_all.queryResults.row;
               }
           }
           
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.tableView reloadData];
               [[ApplicationUIContext getInstance] hideLoadingPanel];
           });
       }
    }];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.teams != nil)
        return self.teams.count;
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Team* t = [self.teams objectAtIndex:indexPath.row];
    cell.textLabel.text = t.name_display_full;
    cell.imageView.image = [t getLogo];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil)
    {
        Team* t = [self.teams objectAtIndex:indexPath.row];
        Favorite* f = [[Favorite alloc] init];
        f.type = 1;
        f.name = t.name_display_full;
        f.keyword = [t.name lowercaseString];
        [self.delegate addFavorite:f];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
