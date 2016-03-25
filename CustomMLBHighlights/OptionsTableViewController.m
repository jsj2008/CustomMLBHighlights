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
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    self.title = @"Settings";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(reset:)];
    self.favorites = [JankDataAccess getFavorites];
}

- (void) addFavorite: (Favorite *) fav
{
    NSLog(@"Add favorite: %@", fav.name);
    [self.favorites addObject:fav];
    [JankDataAccess saveFavorites:self.favorites];
    [self.tableView reloadData];
}

- (IBAction)reset:(id)sender
{
    [JankDataAccess saveDefaultFavorites];
    self.favorites = [JankDataAccess getFavorites];
    [self.tableView reloadData];
}

- (IBAction)done:(id)sender
{
    [[ApplicationUIContext getInstance] dismissModal];
}

- (IBAction)stepper:(id)sender
{
    [JankDataAccess saveVideoLimit:(NSInteger)((UIStepper *)sender).value];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[JankDataAccess getVideoLimit]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Favorites";
        case 1:
            return @"Edit";
        case 2:
            return @"Limit for plays and teams";
            
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.favorites.count;
        case 1:
            return 3;
        case 2:
            return 1;
            
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if (indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    else if (indexPath.section == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
    else
    {
        NSInteger limit = [JankDataAccess getVideoLimit];
        UITableViewCell* stepCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StepCell"];
        stepCell.textLabel.text = @"Number of videos";
        stepCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)limit];
        
        UIStepper* stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
        stepper.minimumValue = 1.0;
        stepper.maximumValue = 20.0;
        stepper.stepValue = 1.0;
        stepper.value = limit;
        [stepper addTarget:self action:@selector(stepper:) forControlEvents:UIControlEventValueChanged];
        stepCell.accessoryView = stepper;
        
        cell = stepCell;
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.favorites removeObjectAtIndex:indexPath.row];
        [JankDataAccess saveFavorites:self.favorites];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


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

    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                PickTeamViewController* teams = [[PickTeamViewController alloc] init];
                teams.delegate = self;
                [self.navigationController pushViewController:teams animated:YES];
                break;
            }
            case 1:
            {
                UIAlertController *ask = [UIAlertController alertControllerWithTitle:@"Add Player" message:@"Type a player's name" preferredStyle:UIAlertControllerStyleAlert];
                [ask addTextFieldWithConfigurationHandler:^(UITextField *textField)
                {
                    textField.placeholder = @"name or keywords";
                    self.txtPlayerName = textField;
                }];
                UIAlertAction *cancelAction = [UIAlertAction
                        actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action)
                                {
                                }];

                __weak OptionsTableViewController* weakSelf = self;

                UIAlertAction *okAction = [UIAlertAction
                        actionWithTitle:@"ADD"
                                  style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    if (weakSelf && self.txtPlayerName != nil)
                                    {
                                        Favorite* f = [[Favorite alloc] init];
                                        f.name = weakSelf.txtPlayerName.text;
                                        f.keyword = [weakSelf.txtPlayerName.text lowercaseString];
                                        f.type = 2;
                                        [weakSelf addFavorite:f];
                                    }


                                }];

                [ask addAction:cancelAction];
                [ask addAction:okAction];

                [self presentViewController:ask animated:YES completion:nil];

                break;
            }
            case 2:
            {
                PickPlayTypeViewController* plays = [[PickPlayTypeViewController alloc] init];
                plays.delegate = self;
                [self.navigationController pushViewController:plays animated:YES];
                break;
            }
            default:
                break;
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
