//
//  RecipeDetailViewController.m
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webview loadHTMLString:self.htmlString baseURL:nil];
    
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
