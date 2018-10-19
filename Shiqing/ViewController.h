//
//  ViewController.h
//  Shiqing
//
//  Created by Xiuwei Zhao on 4/5/18.
//  Copyright © 2018 Xiuwei Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"
#import "TextViewController.h"

@interface ViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;
    NSArray *shiList;
    NSArray *ciList;
    NSArray *quList;
    NSArray *fuList;
    NSMutableArray *searchResults;
    NSMutableArray *sectionTitles;
    NSString *sourcePath;
}

extern UISearchBar *searchBar;
extern ItemViewController *itemView;
extern TextViewController *textView;

@end

