//
//  OptionsTableViewController.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "OptionsTableViewController.h"
#import "JankDataAccess.h"
#import "ApplicationColors.h"
#import "ApplicationUIContext.h"
#import "PickTeamViewController.h"
#import "PickPlayTypeViewController.h"

@interface OptionsTableViewController ()

@end

@implementation OptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Settings";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.favorites = [JankDataAccess getFavorites];
}

- (void) addFavorite: (Favorite *) fav
{
    NSLog(@"Add favorite: %@", fav.name);
    [self.favorites addObject:fav];
    [JankDataAccess saveFavorites:self.favorites];
    [self.tableView reloadData];
}

- (IBAction)done:(id)sender
{
    [[ApplicationUIContext getInstance] dismissModal];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Favorites";
    }
    
    return @"Edit";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.favorites.count;
    }
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if (indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [ApplicationColors secondaryColor];
        
        Favorite* f = (Favorite*)[self.favorites objectAtIndex:indexPath.row];
        cell.textLabel.text = f.name;
        switch (f.type) {
            case 1:
                cell.detailTextLabel.text = @"Team";
                break;
                
            case 2:
                cell.detailTextLabel.text = @"Player";
                break;
                
            default:
                cell.detailTextLabel.text = @"Type of play";
                break;
        }
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = @"";
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Teams";
                break;
                
            case 1:
                cell.textLabel.text = @"Players";
                break;
                
            default:
                cell.textLabel.text = @"Types of plays";
                break;
        }
    }
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        PickTeamViewController* teams = [[PickTeamViewController alloc] init];
        teams.delegate = self;
        [self.navigationController pushViewController:teams animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        PickPlayTypeViewController* plays = [[PickPlayTypeViewController alloc] init];
        plays.delegate = self;
        [self.navigationController pushViewController:plays animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
