//
//  RecipeViewController.m
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import "RecipeViewController.h"
#import "RecipeModel.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "RecipeDetailViewController.h"



@interface RecipeViewController ()
@property(nonatomic,strong)NSMutableArray * datasource;
@property(nonatomic,strong)FIRDatabaseReference * recipeRef;
#define DATABASE_REF @"https://cookinghelper-dcad5.firebaseio.com/news"



@end

@implementation RecipeViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //new mutablearray can save data
    self.datasource = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
// notifaction
    [[FIRAuth auth]addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            //have user get new 20
            FIRDatabaseQuery * query =[[weakSelf.recipeRef queryOrderedByPriority] queryLimitedToFirst:20];

            FIRDatabaseHandle handle = [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary * dict = snapshot.value;
                [self.datasource removeAllObjects];
                //Inquire's key
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    RecipeModel * model = [RecipeModel new];
                    model.recipeId      = key;//only one
                    model.recipeDesc    = obj[@"topicDesc"];
                    model.recipeImageURL = obj[@"topicImageURL"];
                    model.authName      = obj[@"auth"] ?: @"unknown" ;
                    model.recipeTitle    = obj[@"topicTitle"];
                    model.recipeHTMLString = obj[@"topicHtml"];
                    NSTimeInterval interval = [obj[@"createdate"] doubleValue];
                    if (interval > 0) {
                        model.postDate      = [NSDate dateWithTimeIntervalSince1970:[obj[@"createdate"] doubleValue]];
                    }
                    [weakSelf.datasource addObject:model];
                    //reload view
                    [weakSelf.tableView reloadData];
                }];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // data's count
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // get firebase data in cell
    RecipeModel * model = self.datasource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = model.recipeTitle;
    cell.detailTextLabel.text = model.recipeDesc;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    RecipeModel * model = self.datasource[indexPath.row];
    
//    FIRDatabaseReference * childRef = self.recipeRef.childByAutoId;
//    [childRef removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//        [self.tableView reloadData];
//    }]; test
    [self.datasource removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // cell's height
    return 44.f;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        // cell get info
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        RecipeModel * model =  self.datasource[indexPath.row];
        RecipeDetailViewController * detailVC = segue.destinationViewController;
        detailVC.htmlString = model.recipeHTMLString;
    }
}


-(FIRDatabaseReference *)recipeRef{
    if (!_recipeRef) {
        _recipeRef = [[FIRDatabase database]referenceFromURL:DATABASE_REF];
    }
    return _recipeRef;
}

@end
