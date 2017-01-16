//
//  SignInViewController.h
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)SignInBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
