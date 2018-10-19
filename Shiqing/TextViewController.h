//
//  TextViewController.h
//  Shiqing
//
//  Created by Xiuwei Zhao on 4/6/18.
//  Copyright © 2018 Xiuwei Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController
{
    UIImageView *imageView;
    UITextView *textView;
    NSString *contents;
    UIBarButtonItem *nextButton;
    BOOL bOnSearch;
    BOOL bLastOne;
}
@property (nonatomic, strong) NSString *contents;
@property (nonatomic) BOOL bOnSearch;
@property (nonatomic) BOOL bLastOne;

- (void)showContents:(BOOL)bNext;

@end
