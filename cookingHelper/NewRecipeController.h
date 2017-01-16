//
//  NewRecipeController.h
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRecipeController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *foodNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *FoodImageView;
@property (weak, nonatomic) IBOutlet UITextView *FoodInfoTextView;
- (IBAction)postBtnPressed:(id)sender;

@end
