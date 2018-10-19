//
//  ViewController.m
//  Shiqing
//
//  Created by Xiuwei Zhao on 4/5/18.
//  Copyright © 2018 Xiuwei Zhao. All rights reserved.
//

#import "ViewController.h"
#import "searchTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UISearchBar *searchBar = nil;
UIView *aboutBackView = nil;
UIImageView *aboutImageView = nil;
ItemViewController *itemView = nil;
TextViewController *textView = nil;
NSString *shiPath = @"";
NSString *ciPath = @"";
NSString *quPath = @"";
NSString *fuPath = @"";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    searchResults = [[NSMutableArray alloc] init];
    sectionTitles = [[NSMutableArray alloc] init];

    NSURL *bundleRoot = [[NSBundle mainBundle] bundleURL];
    sourcePath = [bundleRoot path];
    shiPath = [NSString stringWithFormat:@"%@/Articles/Shi", sourcePath];
    shiList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:shiPath error:NULL];
    ciPath = [NSString stringWithFormat:@"%@/Articles/Ci", sourcePath];
    ciList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ciPath error:NULL];
    quPath = [NSString stringWithFormat:@"%@/Articles/Qu", sourcePath];
    quList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:quPath error:NULL];
    fuPath = [NSString stringWithFormat:@"%@/Articles/Fu", sourcePath];
    fuList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fuPath error:NULL];
    [self sortShiCi];
    
    CGRect rt = self.navigationController.navigationBar.frame;
    rt.origin.y += rt.size.height;
    searchBar = [[UISearchBar alloc] initWithFrame:rt];
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor colorWithRed:0.25 green:0.4 blue:0.2 alpha:1.0];
    searchBar.showsCancelButton = YES;
    [self.navigationController.view addSubview:searchBar];
    UIView *theView = searchBar.subviews[0];
    for(UIView *subView in theView.subviews)
    {
        if( [subView isKindOfClass:[UIButton class]] )
        {
            [(UIButton *)subView setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
            [(UIButton *)subView setTitle:@"取消搜索" forState:UIControlStateNormal];
        }
    }

    rt = searchBar.frame;
    rt.origin.y += searchBar.frame.size.height;
    rt.size.height = self.navigationController.view.frame.size.height - rt.origin.y;
    tableView = [[UITableView alloc] initWithFrame:rt style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 65;
    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back.png"]];
    [self.view addSubview:tableView];
    UIImage *image = [[UIImage imageNamed:@"Question.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showAbout)];
    self.navigationItem.rightBarButtonItem = aboutButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view bringSubviewToFront:searchBar];
}

- (void)sortShiCi
{
    for(int i=0; i<2; i++)
    {
        NSArray *ar1 = i==0 ? [NSArray arrayWithArray:shiList] : [NSArray arrayWithArray:ciList];
        NSArray *array = [ar1 sortedArrayUsingComparator: ^(id obj1, id obj2)
                          {
                              NSArray *a1 = [obj1 componentsSeparatedByString:@"-"];
                              NSArray *a2 = [obj2 componentsSeparatedByString:@"-"];
                              if( a1 && a2 )
                              {
                                  NSString *str1 = [a1 objectAtIndex:1];
                                  NSString *str2 = [a2 objectAtIndex:1];
                                  NSArray *b1 = [str1 componentsSeparatedByString:@"."];
                                  NSArray *b2 = [str2 componentsSeparatedByString:@"."];
                                  if( b1 && b2 )
                                  {
                                      int n1 = [[b1 objectAtIndex:0] intValue];
                                      int n2 = [[b2 objectAtIndex:0] intValue];
                                      if (n1 > n2)
                                          return (NSComparisonResult)NSOrderedDescending;
                                      if (n1 < n2)
                                          return (NSComparisonResult)NSOrderedAscending;
                                  }
                              }
                              return (NSComparisonResult)NSOrderedSame;
                          }];
        if( i == 0 ) shiList = array;
        if( i == 1 ) ciList = array;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    if( section == 0 ) return [shiList count];
    if( section == 1 ) return [ciList count];
    if( section == 2 ) return [quList count];
    if( section == 3 ) return [fuList count];

    return 0;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    if( section == 0 ) return @"诗";
    if( section == 1 ) return @"词";
    if( section == 2 ) return @"戏，曲";
    if( section == 3 ) return @"赋，文";

    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *filePath = @"";
    NSString *fileName = @"";
    if( indexPath.section == 0 )
    {
        fileName = [shiList objectAtIndex:indexPath.row];
        filePath = [shiPath stringByAppendingPathComponent:fileName];
    }
    if( indexPath.section == 1 )
    {
        fileName = [ciList objectAtIndex:indexPath.row];
        filePath = [ciPath stringByAppendingPathComponent:fileName];
    }
    if( indexPath.section == 2 )
    {
        fileName = [quList objectAtIndex:indexPath.row];
        filePath = [quPath stringByAppendingPathComponent:fileName];
    }
    if( indexPath.section == 3 )
    {
        fileName = [fuList objectAtIndex:indexPath.row];
        filePath = [fuPath stringByAppendingPathComponent:fileName];
    }

    NSArray *item = [fileName componentsSeparatedByString:@"."];
    NSString *sdata = @"";
    long count = 0;
    if( [fileName isEqualToString:@"陆游诗全集"] ) //It is too big that takes time to count it.
    {
        count = 9134;
    }
    else
    {
        sdata = [self readDataFromFile:filePath];
        if( [fileName isEqualToString:@"诗经"] )
        {
            NSArray *ar1 = [sdata componentsSeparatedByString:@"Title:"];
            count = [ar1 count]-1;
            NSArray *ar2 = [sdata componentsSeparatedByString:@"====="];
            count += [ar2 count]-1;
        }
        else
        {
            NSArray *arr = [sdata componentsSeparatedByString:@"Title:"];
            count = [arr count]-1;
        }
    }
    
    cell.textLabel.text = [item objectAtIndex:0];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:20];
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.75];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.75];
    [cell setSelectedBackgroundView:bgColorView];
    if( indexPath.section == 3 )
    {
        NSArray *arr = [sdata componentsSeparatedByString:@"Title:"];
        NSString *str = [arr objectAtIndex:1];
        NSRange r1 = [str rangeOfString:@"\r\n"];
        NSString *td = [str substringFromIndex:r1.location+2];
        NSRange r2 = [td rangeOfString:@"\r\n"];
        td = [td substringToIndex:r2.location];
        NSRange r3 = [td rangeOfString:@"〕"];
        if( r3.location != NSNotFound )
            td = [td substringFromIndex:r3.location+1];
        cell.detailTextLabel.text = td;
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%ld 首)", count];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:18];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rt = CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight);
    UIGraphicsBeginImageContext(rt.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSString *file = [NSString stringWithFormat:@"Header%d.png", (int)section+1];
    if( section == 0 ) file = @"Mountain.png";
    if( section == 1 ) file = @"River.png";
    if( section == 2 ) file = @"Woods.png";
    if( section == 3 ) file = @"Stones.png";
    UIImage *image = [UIImage imageNamed:file];
    CGContextDrawImage(ctx, rt, image.CGImage);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 0.65);
    CGRect rc = CGRectMake(30, 25, 90, rt.size.height-30);
//    CGContextFillRect(ctx, rc);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    UIColor *color = [UIColor colorWithRed:0.85 green:0.25 blue:0.15 alpha:1.0];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                  NSForegroundColorAttributeName: color,
                                  NSParagraphStyleAttributeName: style
                                  };
    NSString *text;
    if( section == 0 ) text = @"诗";
    if( section == 1 ) text = @"词";
    if( section == 2 ) text = @"戏，曲";
    if( section == 3 ) text = @"赋，文";
    rc.origin.y += 0;
    rc.size.height -= 10;
    [text drawInRect:rc withAttributes:attributes];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rt];
    imgView.image = img;
    imgView.alpha = 0.95;
    return (UIView *)imgView;
}

- (NSString *)readDataFromFile:(NSString *)fname
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingDOSChineseSimplif);
    NSError *error;
    NSString *sdata = [NSString stringWithContentsOfFile:fname encoding:enc error:&error];
    if( sdata == nil )
    {
        sdata = [NSString stringWithContentsOfFile:fname encoding:NSUTF8StringEncoding error:&error];
    }
    sdata = [sdata stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
    sdata = [sdata stringByReplacingOccurrencesOfString:@"\r\r\n" withString:@"\r\n"];
    return sdata;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = @"";
    NSString *fileName = @"";
    if( indexPath.section == 0 )
    {
        fileName = [shiList objectAtIndex:indexPath.row];
        filePath = [shiPath stringByAppendingPathComponent:fileName];
    }
    if( indexPath.section == 1 )
    {
        fileName = [ciList objectAtIndex:indexPath.row];
        filePath = [ciPath stringByAppendingPathComponent:fileName];
    }
    if( indexPath.section == 2 )
    {
        fileName = [quList objectAtIndex:indexPath.row];
        filePath = [quPath stringByAppendingPathComponent:fileName];
    }
    if( indexPath.section == 3 )
    {
        fileName = [fuList objectAtIndex:indexPath.row];
        filePath = [fuPath stringByAppendingPathComponent:fileName];
    }
    
    NSString *sdata = [self readDataFromFile:filePath];
    if( sdata == nil )
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle: @"Error"
                                                                        message: @"Cannot read this data file."
                                                                 preferredStyle: UIAlertControllerStyleAlert];        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString *currentBook = @"";
    NSArray *arr = [sdata componentsSeparatedByString:@"Book:"];
    if( [arr count] > 1 )
    {
        NSString *td = [arr objectAtIndex:1];
        NSRange rg = [td rangeOfString:@"\r\n"];
        currentBook = [td substringToIndex:rg.location];
    }
    
    NSMutableArray *itemList = (NSMutableArray *)[sdata componentsSeparatedByString:@"Title:"];
    [itemList removeObjectAtIndex:0];
    itemView = [[ItemViewController alloc] init];
    if( [itemList count] == 1 )
    {
        NSString *itemTxt = [itemList objectAtIndex:0];
        textView = [[TextViewController alloc] init];
        textView.contents = itemTxt;
        textView.bOnSearch = NO;
        textView.bLastOne = YES;
        [self.navigationController pushViewController:textView animated:YES];
    }
    else
    {
        itemView.bookName = currentBook;
        itemView.contentList = itemList;
        [self.navigationController pushViewController:itemView animated:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
    [searchBar resignFirstResponder];
}

//Convert files from other encoding to UTF8
- (void)saveAllFiles
{
    for(int i=0; i<4; i++)
    {
        NSArray *artList = nil;
        NSString *path = @"";
        if( i==0 ) {artList = shiList; path = shiPath;}
        if( i==1 ) {artList = ciList; path = ciPath;}
        if( i==2 ) {artList = quList; path = quPath;}
        if( i==3 ) {artList = fuList; path = fuPath;}
        int num = (int)[artList count];
        for(int j=0; j<num; j++)
        {
            NSString *fileName = [artList objectAtIndex:j];
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            NSString *sdata = [self readDataFromFile:filePath];
            if( sdata != nil )
            {
                NSString *str[4] = {@"Shi", @"Ci", @"Qu", @"Fu"};
                
                NSString *savePath = [NSString stringWithFormat:@"/Users/zhaoxw/Documents/Articles/%@/%@", str[i], fileName];
                NSError *err = nil;
                [sdata writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&err];
                if( err )
                {
                    NSLog(@"Error: %@", err.localizedDescription);
                }
            }
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchResults removeAllObjects];
    [sectionTitles removeAllObjects];
    
    for(int i=0; i<4; i++)
    {
        NSArray *artList = nil;
        NSString *path = @"";
        if( i==0 ) {artList = shiList; path = shiPath;}
        if( i==1 ) {artList = ciList; path = ciPath;}
        if( i==2 ) {artList = quList; path = quPath;}
        if( i==3 ) {artList = fuList; path = fuPath;}
        int num = (int)[artList count];
        for(int j=0; j<num; j++)
        {
            NSString *fileName = [artList objectAtIndex:j];
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            NSString *sdata = [self readDataFromFile:filePath];
            if( sdata != nil )
            {
                NSMutableArray *items = [[NSMutableArray alloc] init];
                NSArray *array = [sdata componentsSeparatedByString:@"Title:"];
                NSString *txt = [array objectAtIndex:0];
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@", "];
                NSArray *arr = [searchBar.text componentsSeparatedByCharactersInSet:set];
                NSMutableArray *oks = [[NSMutableArray alloc] init];
                for(int m=0; m<[arr count]; m++)
                {
                    NSRange rg = [txt rangeOfString:[arr objectAtIndex:m]];
                    if( rg.location != NSNotFound )
                    {
                        [oks addObject:[NSNumber numberWithInt:2]];
                    }
                    else
                    {
                        [oks addObject:[NSNumber numberWithInt:0]];
                    }
                }
                for(int k=1; k<[array count]; k++)
                {
                    NSString *txt = [array objectAtIndex:k];
                    for(int m=0; m<[arr count]; m++)
                    {
                        NSRange rg = [txt rangeOfString:[arr objectAtIndex:m]];
                        if( rg.location != NSNotFound && [[oks objectAtIndex:m] intValue] == 0 )
                        {
                            [oks replaceObjectAtIndex:m withObject:[NSNumber numberWithInt:1]];
                        }
                    }
                    bool OK = true;
                    for(int m=0; m<[arr count]; m++)
                    {
                        if( [[oks objectAtIndex:m] intValue] == 0 )
                        {
                            OK = false;
                        }
                        else
                            if( [[oks objectAtIndex:m] intValue] == 1 )
                            {
                                [oks replaceObjectAtIndex:m withObject:[NSNumber numberWithInt:0]];
                            }
                    }
                    if( OK )
                    {
                        [items addObject:txt];
                    }
                }
                
                if( [items count] > 0 )
                {
                    [searchResults addObject:items];
                    NSArray *arr = [sdata componentsSeparatedByString:@"Book:"];
                    if( [arr count] > 1 )
                    {
                        NSString *td = [arr objectAtIndex:1];
                        NSRange rg = [td rangeOfString:@"\r\n"];
                        [sectionTitles addObject:[td substringToIndex:rg.location]];
                    }
                    else
                    {
                        [sectionTitles addObject:@"Unknown"];
                    }
                }
            }
        }
    }
    
    // hides the keyboard
    [searchBar resignFirstResponder];
    
    int ct = 0;
    for(int i=0; i<[searchResults count]; i++)
    {
        ct += [[searchResults objectAtIndex:i] count];
    }
    
    if( ct > 0 )
    {
        SearchTableViewController *itemView = [[SearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
        itemView.titleList = sectionTitles;
        itemView.contentList = searchResults;
        itemView.navigationItem.title = [NSString stringWithFormat:@"搜索结果:%d首", ct];
        [self.navigationController pushViewController:itemView animated:YES];

    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle: @"抱歉"
                                                                        message: @"没有找到对应的诗词文件."
                                                                 preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

UIButton *okButton = nil;
- (void)showAbout
{
    CGRect box = self.view.frame;
    int y = box.size.height / 2 - 120;
    CGRect rect = CGRectMake(0, y, box.size.width, 240);
    UIGraphicsBeginImageContext(rect.size);
    
    UIImage *image = [UIImage imageNamed:@"Icon.png"];
    [image drawInRect:CGRectMake(30, 30, 70, 70)];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:24],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:0.2 green:0.35 blue:0.7 alpha:1.0],
                                  NSParagraphStyleAttributeName: style
                                  };
    int x = 130;
    NSString *text = @"诗赋名家";
    [text drawAtPoint:CGPointMake(x, 30) withAttributes:attributes1];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:16],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:0.2 green:0.35 blue:0.7 alpha:1.0],
                                  NSParagraphStyleAttributeName: style
                                  };
    text = @"Version 3.2";
    [text drawAtPoint:CGPointMake(x, 60) withAttributes:attributes];
    text = @"软件设计：赵修伟";
    [text drawAtPoint:CGPointMake(x, 100) withAttributes:attributes];
    text = @"程序编写：赵修伟";
    [text drawAtPoint:CGPointMake(x, 125) withAttributes:attributes];
    text = @"2018.4";
    [text drawAtPoint:CGPointMake(x, 165) withAttributes:attributes];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 1);
    CGContextMoveToPoint(ctx, 0, 200);
    CGContextAddLineToPoint(ctx, box.size.width, 200);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
    CGContextStrokePath(ctx);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    aboutBackView = [[UIView alloc] initWithFrame:self.view.frame];
    aboutBackView.backgroundColor = [UIColor blackColor];
    aboutBackView.alpha = 0.55f;
    aboutImageView = [[UIImageView alloc] initWithFrame:rect];
    aboutImageView.backgroundColor = [UIColor whiteColor];
    aboutImageView.image = newImage;
    y = rect.origin.y + rect.size.height - 40;
    okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, box.size.width, 40)];
    okButton.backgroundColor = [UIColor whiteColor];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(aboutOk) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:aboutBackView];
    [self.navigationController.view addSubview:aboutImageView];
    [self.navigationController.view addSubview:okButton];

    CGRect rt = aboutBackView.frame;
    rt.origin.x = -rt.size.width;
    aboutBackView.frame = rt;
    rt = aboutImageView.frame;
    rt.origin.x = -rt.size.width;
    aboutImageView.frame = rt;
    rt = okButton.frame;
    rt.origin.x = -rt.size.width;
    okButton.frame = rt;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    rt = aboutBackView.frame;
    rt.origin.x = 0;
    aboutBackView.frame = rt;
    rt = aboutImageView.frame;
    rt.origin.x = 0;
    aboutImageView.frame = rt;
    rt = okButton.frame;
    rt.origin.x = 0;
    okButton.frame = rt;
    [UIView commitAnimations];
}

- (void)aboutOk
{
    if( aboutImageView )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect rt = aboutBackView.frame;
        rt.origin.x = rt.size.width;
        aboutBackView.frame = rt;
        rt = aboutImageView.frame;
        rt.origin.x = rt.size.width;
        aboutImageView.frame = rt;
        rt = okButton.frame;
        rt.origin.x = rt.size.width;
        okButton.frame = rt;
        [UIView commitAnimations];
        
        [self performSelector:@selector(postAbout) withObject:nil afterDelay:0.3];
    }
}

- (void)postAbout
{
    [aboutImageView removeFromSuperview];
    [aboutBackView removeFromSuperview];
    [okButton removeFromSuperview];
    aboutImageView = nil;
    okButton = nil;
}

@end
