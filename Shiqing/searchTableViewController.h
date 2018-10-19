//
//  searchTableViewController.h
//  Shiqing
//
//  Created by Xiuwei Zhao on 4/6/18.
//  Copyright © 2018 Xiuwei Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController
{
    NSArray *titleList;
    NSArray *contentList;
}
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *contentList;

@end
