//
//  SignUpViewController.m
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import "SignUpViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <MBProgressHUD.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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

- (IBAction)signUpBtnPressed:(id)sender {
    // check email & password != nil
    if (self.signUpEmailTextField.text.length ==0) return;
    if (self.signUpPasswordBtn.text.length ==0) return;
    
    //create hud
    MBProgressHUD * hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ [FIRAuth auth]createUserWithEmail:self.signUpEmailTextField.text password:self.signUpPasswordBtn.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        hud.mode = MBProgressHUDModeText;
        if (error) {
            hud.label.text = [error localizedDescription];
            
            [hud hideAnimated:YES afterDelay:2];
        }else{
            hud.label.text = @"註冊成功";
            [hud hideAnimated:YES afterDelay:2];            
        }
    }];
}
@end
