//
//  RecipeModel.h
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeModel : NSObject
@property(nonatomic,strong) NSString * recipeId;
@property(nonatomic,strong) NSString * recipeTitle;
@property(nonatomic,strong) NSString * recipeDesc;
@property(nonatomic,strong) NSString * recipeImageURL;
@property(nonatomic,strong) NSString * authName;
@property(nonatomic,strong) NSString * recipeHTMLString;
@property(nonatomic,strong) NSDate * postDate;



@end
