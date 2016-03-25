//
//  PickPlayType.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "PickPlayTypeViewController.h"

@implementation PickPlayTypeViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Select Play";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Diving catches";
            break;
        
        case 1:
            cell.textLabel.text = @"Double plays";
            break;
            
        case 2:
            cell.textLabel.text = @"Homeruns";
            break;
            
        case 3:
            cell.textLabel.text = @"Record Broken";
            break;
            
        case 4:
            cell.textLabel.text = @"Strikeouts";
            break;
            
        case 5:
            cell.textLabel.text = @"Walk offs";
            break;
            
        case 6:
            cell.textLabel.text = @"Must C";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil)
    {
        Favorite* f = [[Favorite alloc] init];
        f.type = 3;
        
        switch (indexPath.row) {
            case 0:
                f.name = @"Diving catches";
                f.keyword = @"diving";
                break;
                
            case 1:
                f.name = @"Double plays";
                f.keyword = @"double play";
                break;
                
            case 2:
                f.name = @"Homeruns";
                f.keyword = @"home run";
                break;
                
            case 3:
                f.name = @"Record Broken";
                f.keyword = @"record";
                break;
                
            case 4:
                f.name = @"Strikeouts";
                f.keyword = @"strike out";
                break;
                
            case 5:
                f.name = @"Walk offs";
                f.keyword = @"walk off";
                break;
                
            case 6:
                f.name = @"Must C";
                f.keyword = @"must c";
                break;
                
            default:
                break;
        }
        
        [self.delegate addFavorite:f];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
