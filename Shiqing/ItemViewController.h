//
//  ItemViewController.h
//  Shiqing
//
//  Created by Xiuwei Zhao on 4/5/18.
//  Copyright © 2018 Xiuwei Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;
    NSArray *contentList;
    NSString *bookName;
    NSInteger nIndex;
}

@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, strong) NSString *bookName;

- (void)showNext;
- (void)showPrevios;

@end
