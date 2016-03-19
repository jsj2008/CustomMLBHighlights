//
//  ViewController.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "FeedViewController.h"
#import "HighlightPackage.h"
#import "HighlightVideo.h"
#import "JankDataAccess.h"
#import "OptionsTableViewController.h"
#import "ApplicationUIContext.h"
#import "APIClient.h"
#import "APIRequest.h"
#import "SearchResponse.h"
#import "VideoPlayer.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellOld"];
    
    self.title = @"Feed";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(openOptions:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)], nil];
}

- (IBAction)openOptions:(id)sender
{
    OptionsTableViewController* opt = [[OptionsTableViewController alloc] initWithNibName:@"OptionsTableViewController" bundle:nil];
    [[ApplicationUIContext getInstance] openModal:opt];
}

- (IBAction)refresh:(id)sender
{
    //[JankDataAccess saveDefaultFavorites];
    [self getVideos];
//    self.packages = [JankDataAccess getFeed];
    [self.tableView reloadData];
}

- (IBAction)play:(id)sender
{
    if (self.package != nil && self.package.videos != nil && self.package.videos.count > 0)
    {
        VideoPlayer* player = [[VideoPlayer alloc] initWithPackage:self.package];
        [self presentViewController:player animated:YES completion:^{
            [player loadVideo];
        }];
    }
}

- (void) getVideos
{
    self.package = [[HighlightPackage alloc] init];
    self.package.keywordsUsed = [NSMutableArray array];
    self.package.videos = [NSMutableArray array];
    
    [[ApplicationUIContext getInstance] showLoadingPanel];
    
    for (Favorite* f in [JankDataAccess getFavorites])
    {
        [self.package.keywordsUsed addObject:f.name];
        
        [APIClient processRequest:[APIRequest requestForFavorite:f] completion:^(APIRequestResult result, NSMutableArray* objs) {
            if (result == Success)
            {
                if (objs != nil && objs.count > 0)
                {
                    SearchResponse* resp = (SearchResponse*)[objs objectAtIndex:0];
                    NSLog(@"%@ videos for %@", resp.total, resp.query);
                    
                    if (resp.mediaContent != nil && resp.mediaContent.count > 0)
                    {
                        MediaContent* media = [resp.mediaContent objectAtIndex:0];
                        HighlightVideo* video = [[HighlightVideo alloc] init];
                        video.metaUrl = media.url;
                        video.headline = media.title;
                        video.duration = media.duration;
                        video.bigBlurb = media.bigBlurb;
                        video.dayCreated = media.date_added;
                        if (media.thumbnails != nil && media.thumbnails.count > 0)
                            video.thumbnailUrl = ((Thumbnail *)[media.thumbnails objectAtIndex:0]).src;
                        
                        [video initializeVideoURL:nil];
                        
                        [self.package.videos addObject:video];
                    }
                    
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [[ApplicationUIContext getInstance] hideLoadingPanel];
            });
            
            
        }];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.package == nil)
            return 0;
        
        return self.package.videos.count;
    }
    else
    {
        return [JankDataAccess getFavorites].count;
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Playlist";
    }
    else
    {
        return @"Keywords";
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
        HighlightVideo* video = [self.package.videos objectAtIndex:indexPath.row];
        
        cell.textLabel.text = video.headline;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", video.dayCreated, video.bigBlurb];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:video.thumbnailUrl]]];
        return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellOld"];
        Favorite* f = [[JankDataAccess getFavorites] objectAtIndex:indexPath.row];
        cell.textLabel.text = f.name;
        return cell;
    }
}

@end
