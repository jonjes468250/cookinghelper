//
//  NewRecipeController.m
//  cookingHelper
//
//  Created by 陳毅麟 on 2017/1/7.
//  Copyright © 2017年 Rin. All rights reserved.
//

#import "NewRecipeController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseStorage/FirebaseStorage.h>
#import <MBProgressHUD.h>

#define STORAGE_REF @"gs://cookinghelper-dcad5.appspot.com"
#define DATABASE_REF @"https://cookinghelper-dcad5.firebaseio.com/news"


@interface NewRecipeController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) FIRDatabaseReference * databaseRef;
@property(nonatomic,strong) FIRDatabaseReference * storageRef;

@end

@implementation NewRecipeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // new TapGestureRecognizer
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidTap)];
    self.FoodImageView.userInteractionEnabled = YES;
    //tap on imageview
    [self.FoodImageView addGestureRecognizer:tap];
    
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

- (IBAction)postBtnPressed:(id)sender {
    NSString * title = self.foodNameTextField.text;
    NSString * content = self.FoodInfoTextView.text;
    UIImage * image = self.FoodImageView.image;
    
    if (title == nil || content == nil || image == nil) {
        return;
    }
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    NSTimeInterval timeinterval = [[NSDate date]timeIntervalSince1970];
    
    FIRStorageReference * picRef = [self.storageRef child:[NSString stringWithFormat:@"%lf",timeinterval]];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FIRStorageUploadTask * dataTask = [picRef putData:imageData];
    
    [dataTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
        if (snapshot.status == FIRStorageTaskStatusResume) {
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.label.text = @"正在上傳中";
            hud.progress = 0;
        }
        float progress = (float)snapshot.progress.completedUnitCount / (float)snapshot.progress.totalUnitCount;
        hud.progress = progress;//進度
     }];
    [dataTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = snapshot.error.localizedDescription;
        [hud hideAnimated:YES afterDelay:2];
    }];
    
    __weak typeof(self) weakSelf = self;
    NSString * contentHTMLPath = [[NSBundle mainBundle]pathForResource:@"Content" ofType:@"html"];
    NSError * error = nil;
    NSString * contentHTMLString = [NSString stringWithContentsOfFile:contentHTMLPath
                                                             encoding:NSUTF8StringEncoding
                                                                error:&error];
    
    
    [dataTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
        hud.mode =  MBProgressHUDModeIndeterminate;
        hud.label.text = @"發佈中";
        
        NSString * perfectHTMLString = [[[contentHTMLString stringByReplacingOccurrencesOfString:@"$$title" withString:title]stringByReplacingOccurrencesOfString:@"$$imageurl" withString:snapshot.metadata.downloadURL.absoluteString]stringByReplacingOccurrencesOfString:@"$$content" withString:content];
        FIRDatabaseReference * childRef = self.databaseRef.childByAutoId;
        [childRef setValue:@{@"recipeTitle"    : title,
                             @"recipeImageURL" : snapshot.metadata.downloadURL.absoluteString,
                             @"recipeDesc"     : content,
                             @"recipeHtml"     : perfectHTMLString,
                             @"auth"          : [[FIRAuth auth] currentUser].email,                             @"createdate"    : @([[NSDate date]timeIntervalSince1970])}
               andPriority:@"createdate"
       withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
           hud.mode = MBProgressHUDModeText;
           if (error) {
               hud.label.text = error.localizedDescription;
               
           }
           else{
               hud.label.text = @"發佈出去摟";
           }
           [hud hideAnimated:YES afterDelay:2];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [weakSelf.navigationController popViewControllerAnimated:YES];
           });
       }];
        
    }];


}
-(FIRStorageReference *)storageRef{
    if (!_storageRef) {
        _storageRef = [[FIRStorage storage]referenceForURL:STORAGE_REF];
    }
    return _storageRef;
}
-(FIRDatabaseReference *)databaseRef{
    if (!_databaseRef) {
        _databaseRef = [[FIRDatabase database]referenceFromURL:DATABASE_REF];
    }
    return _databaseRef;
}
-(void)imageDidTap{
    UIImagePickerController * imagePickerController =[UIImagePickerController new];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * pickedImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.FoodImageView.image = pickedImage;
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
