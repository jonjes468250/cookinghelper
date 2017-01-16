//
//  SignInViewController.m
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import "SignInViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <MBProgressHUD.h>
#import "MainNavigationController.h"



@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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

- (IBAction)SignInBtnPressed:(id)sender {
    // check textfield != nil
    if (self.emailTextField.text.length == 0) return;
    if (self.passwordTextField.text.length == 0) return;
    // ??
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;

    // create hud
    MBProgressHUD * hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FIRAuth auth]signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        hud.mode = MBProgressHUDModeText;
        if (error) {
            hud.label.text = [error localizedDescription];
            [hud hideAnimated:YES afterDelay:2];
        }else{
            hud.label.text = @"登入成功";
            [hud hideAnimated:YES afterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            
        }
    }];
    
}
@end
