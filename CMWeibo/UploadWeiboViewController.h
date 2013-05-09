//
//  UploadWeiboViewController.h
//  CMWeibo
//
//  Created by Cameron on 13-5-8.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "BaseUIViewController.h"

@interface UploadWeiboViewController : BaseUIViewController<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SinaWeiboRequestDelegate>

@property (retain, nonatomic) IBOutlet UITextView *weiboContentTextView;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property (retain, nonatomic) UIImageView *pickerImage;


@property (retain, nonatomic) IBOutlet UIBarButtonItem *toolBarBtn1;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *toolBarBtn2;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *toolBarBtn3;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *toolBarBtn4;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *toolBarBtn5;




- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)sendWeiboButtonClick:(UIBarButtonItem *)sender;

@end
