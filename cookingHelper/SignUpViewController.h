//
//  SignUpViewController.h
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *signUpEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *signUpPasswordBtn;
- (IBAction)signUpBtnPressed:(id)sender;

@end
