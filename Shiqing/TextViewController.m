//
//  TextViewController.m
//  Shiqing
//
//  Created by Xiuwei Zhao on 4/6/18.
//  Copyright © 2018 Xiuwei Zhao. All rights reserved.
//

#import "ViewController.h"
#import "ItemViewController.h"
#import "TextViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController
@synthesize contents, bOnSearch, bLastOne;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    CGRect rt = searchBar.frame;
    if( !bOnSearch ) rt.origin.y += searchBar.frame.size.height;
    rt.size.height = self.navigationController.view.frame.size.height - rt.origin.y;
    textView = [[UITextView alloc] initWithFrame:rt textContainer:nil];
    textView.opaque = NO;
    textView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont systemFontOfSize:20];
    textView.editable = NO;
    rt.origin.x = -rt.size.width;
    imageView = [[UIImageView alloc] initWithFrame:rt];
    [self.view addSubview:imageView];
    [self.view addSubview:textView];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:itemView action:@selector(showNext)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [textView addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:itemView action:@selector(showPrevios)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [textView addGestureRecognizer:swipeRight];

    nextButton = [[UIBarButtonItem alloc] initWithTitle:@"下一篇"  style:UIBarButtonItemStylePlain target:itemView action:@selector(showNext)];
    [self showContents:YES];
}

- (void)showContents:(BOOL)bNext
{
    static int Index = 1;
    
    if( !bLastOne && self.navigationItem.rightBarButtonItem==nil )
    {
        self.navigationItem.rightBarButtonItem = nextButton;
    }
    NSURL *bundleRoot = [[NSBundle mainBundle] bundleURL];
    NSString *sourcePath = [NSString stringWithFormat:@"%@/Flowers", [bundleRoot path]];
    CGRect rt = imageView.frame;
    rt.origin.x = bNext ? rt.size.width : -rt.size.width;
    imageView.frame = rt;
    NSString *fname = [NSString stringWithFormat:@"%@/Flower%d.png", sourcePath, Index++];
    if( Index == 17 ) Index = 1;
    imageView.image = [UIImage imageNamed:fname];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    rt.origin.x = 0;
    imageView.frame = rt;
    [UIView commitAnimations];

    NSRange rg1 = [contents rangeOfString:@"\r\n"];
    if( rg1.location == NSNotFound )
        rg1 = [contents rangeOfString:@"\n"];
    NSString *title = [contents substringToIndex:rg1.location];
    self.navigationItem.title = title;
    NSRange rg2 = [contents rangeOfString:@"//"];
    if( rg2.location == NSNotFound )
    {
        rg2.location = [contents length];
    }
    NSRange rg = {rg1.location+rg1.length, rg2.location-rg1.location-rg1.length};
    NSString *text = [contents substringWithRange:rg];
    NSRange rg3 = [text rangeOfString:@"\n"];
    if( rg3.location <= 1 )
        textView.text = text;
    else
        textView.text = [NSString stringWithFormat:@"\r\n%@", text];
    [textView scrollRangeToVisible:NSMakeRange(0, 20)];
}

- (void)viewWillAppear:(BOOL)animated
{
    if( bOnSearch )
    {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
        NSInteger length = [textView.text length];
        NSRange rg = {0, length};
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:rg];
        
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@", "];
        NSArray *arr = [searchBar.text componentsSeparatedByCharactersInSet:set];
        for(int i=0; i<[arr count]; i++)
        {
            NSString *text = [arr objectAtIndex:i];
            NSInteger start = 0;
            NSInteger length = [textView.text length];
            while( 1 )
            {
                NSRange rg = {start, length};
                NSRange range = [textView.text rangeOfString:text options:NSCaseInsensitiveSearch range:rg];
                if( range.location == NSNotFound )
                    break;
                [string addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0] range:range];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
                start = range.location + [text length];
                length = [textView.text length] - start;
                if( length < [text length] )
                    break;
            }
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
        textView.attributedText = string;
        searchBar.hidden = YES;
    }
    else
    {
        [self.navigationController.view bringSubviewToFront:searchBar];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
