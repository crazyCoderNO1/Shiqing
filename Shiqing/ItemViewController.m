//
//  ItemViewController.m
//  Shiqing
//
//  Created by Xiuwei Zhao on 4/5/18.
//  Copyright © 2018 Xiuwei Zhao. All rights reserved.
//

#import "ViewController.h"
#import "ItemViewController.h"
#import "TextViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController
@synthesize contentList, bookName;

int backIndex = 1;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rt = searchBar.frame;
    rt.origin.y += searchBar.frame.size.height;
    rt.size.height = self.navigationController.view.frame.size.height - rt.origin.y;
    tableView = [[UITableView alloc] initWithFrame:rt style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.opaque = NO;
    tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    NSString *sname = [NSString stringWithFormat:@"Back%d.png", backIndex++];
    if( backIndex == 12 ) backIndex = 1;
    UIImage *image = [UIImage imageNamed:sname];
    rt = self.view.frame;
    if( rt.size.height > 800 ) // iPhone X
    {
        rt = tableView.frame;
        UIGraphicsBeginImageContext(rt.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        rt.origin.y = 80;
        rt.size.height -= 160;
        CGContextTranslateCTM(ctx, 0, rt.size.height+160);
        CGContextScaleCTM(ctx, 1, -1);
        CGContextDrawImage(ctx, rt, image.CGImage);
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:tableView];
    self.navigationItem.title = bookName;
    nIndex = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view bringSubviewToFront:searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *td = [contentList objectAtIndex:indexPath.row];
    NSArray *ar = [td componentsSeparatedByString:@"\r\n"];
    NSString *title = [ar objectAtIndex:0];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.65];
    [cell setSelectedBackgroundView:bgColorView];
    if( [bookName isEqualToString:@"诗经"] )
    {
        NSArray *item = [td componentsSeparatedByString:@"====="];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d 首)", (int)[item count]];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:18];
    }
    else
    {
        cell.detailTextLabel.text = @"";
    }

    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nIndex = indexPath.row;
    NSString *itemTxt = [contentList objectAtIndex:nIndex];
    textView = [[TextViewController alloc] init];
    textView.contents = itemTxt;
    textView.bOnSearch = NO;
    textView.bLastOne = nIndex == [contentList count]-1;
    [self.navigationController pushViewController:textView animated:YES];
}

- (void)showNext
{
    if( nIndex+1 < [contentList count] && textView )
    {
        nIndex += 1;
        NSString *itemTxt = [contentList objectAtIndex:nIndex];
        textView.contents = itemTxt;
        [textView showContents:YES];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    if( nIndex+1 == [contentList count] )
    {
        textView.bLastOne = YES;
        textView.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)showPrevios
{
    if( nIndex > 0 && textView )
    {
        textView.bLastOne = NO;
        nIndex -= 1;
        NSString *itemTxt = [contentList objectAtIndex:nIndex];
        textView.contents = itemTxt;
        [textView showContents:NO];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

@end
