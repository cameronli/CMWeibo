//
//  UploadWeiboViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-5-8.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "UploadWeiboViewController.h"

@interface UploadWeiboViewController ()

@end

@implementation UploadWeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
#endif
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"messages_toolbar_background"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self setToolBarButton];
    [self.weiboContentTextView becomeFirstResponder];
}


- (void)setToolBarButton
{
    UIButton *camera = [UIButton buttonWithType:UIButtonTypeCustom];
    camera.frame = CGRectMake(0, 0, 22, 22);
    [camera setImage:[UIImage imageNamed:@"messages_toolbar_camerabutton_background"] forState:UIControlStateNormal];
    [camera setImage:[UIImage imageNamed:@"messages_toolbar_camerabutton_background_highlighted"] forState:UIControlStateHighlighted];
    [camera addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    self.toolBarBtn1.customView = camera;
    
    UIButton *photo = [UIButton buttonWithType:UIButtonTypeCustom];
    photo.frame = CGRectMake(0, 0, 22, 22);
    [photo setImage:[UIImage imageNamed:@"messages_toolbar_photobutton_background"] forState:UIControlStateNormal];
    [photo setImage:[UIImage imageNamed:@"messages_toolbar_photobutton_background_highlighted"] forState:UIControlStateHighlighted];
    [photo addTarget:self action:@selector(openMyPhoteLibary:) forControlEvents:UIControlEventTouchUpInside];
    self.toolBarBtn2.customView = photo;
    
    UIButton *connectSomeone = [UIButton buttonWithType:UIButtonTypeCustom];
    connectSomeone.frame = CGRectMake(0, 0, 22, 22);
    [connectSomeone setImage:[UIImage imageNamed:@"compose_mentionbutton_background"] forState:UIControlStateNormal];
    [connectSomeone setImage:[UIImage imageNamed:@"compose_mentionbutton_background_highlighted"] forState:UIControlStateHighlighted];
    self.toolBarBtn3.customView = connectSomeone;
    
    UIButton *faceImage = [UIButton buttonWithType:UIButtonTypeCustom];
    faceImage.frame = CGRectMake(0, 0, 22, 22);
    [faceImage setImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background"] forState:UIControlStateNormal];
    [faceImage setImage:[UIImage imageNamed:@"messages_toolbar_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    self.toolBarBtn4.customView = faceImage;
    
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.frame = CGRectMake(0, 0, 22, 22);
    [more setImage:[UIImage imageNamed:@"navigationbar_add"] forState:UIControlStateNormal];
    [more setImage:[UIImage imageNamed:@"navigationbar_add_highlighted"] forState:UIControlStateHighlighted];
    self.toolBarBtn5.customView = more;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_weiboContentTextView release];
    [_navigationBar release];
    [_toolBar release];
    [_toolBarBtn1 release];
    [_toolBarBtn2 release];
    [_toolBarBtn3 release];
    [_toolBarBtn4 release];
    [_toolBarBtn5 release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendWeiboButtonClick:(UIBarButtonItem *)sender {
    [self.weiboContentTextView resignFirstResponder];
    NSString *weiboContent = self.weiboContentTextView.text;
    if ([[weiboContent stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送空白文本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:weiboContent forKey:@"status"];
    if (self.pickerImage != nil) {
        [param setObject:self.pickerImage.image forKey:@"pic"];
        [self.sinaweibo requestWithURL:@"statuses/upload.json" params:param httpMethod:@"POST" delegate:self];
        return;
    }
    [self.sinaweibo requestWithURL:@"statuses/update.json" params:param httpMethod:@"POST" delegate:self];
}

#pragma mark - SinaWeiboRequestDelegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"网络加载失败");
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *res = (NSDictionary *)result;
    
    NSLog(@"%@",res);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark action
- (void)openCamera:(UIButton *)sender
{
    [self.weiboContentTextView resignFirstResponder];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    [picker release];
}

- (void)openMyPhoteLibary:(UIButton *)sender
{
    [self.weiboContentTextView resignFirstResponder];
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
    [pickerImage release];
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:@"toolBarLocationChange" context:nil];
    self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT-keyboardRect.size.height-44-20, 320, 44);
    if (self.pickerImage != nil) {
        self.pickerImage.frame = CGRectMake(260, SCREEN_HEIGHT-keyboardRect.size.height-44-20-44-8, 50, 50);
    }
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:@"toolBarLocationChange" context:nil];
    self.toolBar.frame = CGRectMake(0, SCREEN_HEIGHT-44-20, 320, 44);
    if (self.pickerImage != nil) {
        self.pickerImage.frame = CGRectMake(260, 430-64-2, 50, 50);
    }
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

#pragma mark - 
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
    self.pickerImage = nil;
    self.pickerImage = [[UIImageView alloc] initWithImage:image];
    
    self.pickerImage.frame = CGRectMake(260, 430-64-2, 50, 50);
    [self.view addSubview:self.pickerImage];
    
    NSLog(@"%@",info);
}




@end
