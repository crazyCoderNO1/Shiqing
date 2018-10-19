//
//  searchTableViewController.m
//  Shiqing
//
//  Created by Xiuwei Zhao on 4/6/18.
//  Copyright © 2018 Xiuwei Zhao. All rights reserved.
//

#import "searchTableViewController.h"
#import "TextViewController.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController
@synthesize contentList, titleList;

extern UISearchBar *searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tableView.sectionHeaderHeight = 55;
}

- (void)viewWillAppear:(BOOL)animated
{
    searchBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    searchBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [titleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[contentList objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    return [titleList objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = [[contentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:20];

    return cell;
}

- (void)tableView:(UITableView *)aTableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:18];
    header.textLabel.textColor = [UIColor colorWithRed:0.65 green:0.25 blue:0.15 alpha:1.0];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemTxt = [[contentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TextViewController *itemView = [[TextViewController alloc] init];
    itemView.contents = itemTxt;
    itemView.bOnSearch = YES;
    [self.navigationController pushViewController:itemView animated:YES];
}

@end
