//
//  AppDelegate.h
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

