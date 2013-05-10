//
//  UploadWeiboViewController.m
//  CMWeibo
//
//  Created by Cameron on 13-5-8.
//  Copyright (c) 2013年 cm. All rights reserved.
//

#import "UploadWeiboViewController.h"
#import "TSPopoverController.h"

@interface UploadWeiboViewController ()

@end

static NSString *recevieDataType;

@implementation UploadWeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"新微薄";
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

- (id)initWithRetweetContent:(NSDictionary *)retweetContent
{
    self = [super init];
    if (self) {
        self.title = @"转发微博";
        self.type = @"retweet";
        self.retweetContent = retweetContent;
    }
    return self;
}

- (id)initWithCommentTweeter:(NSDictionary *)commentTweeter
{
    self = [super init];
    if (self) {
        self.title = @"评论微博";
        self.type = @"comment";
        self.retweetContent = commentTweeter;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"messages_toolbar_background"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self setToolBarButton];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];//指定进度轮的大小
    [self.activity setCenter:CGPointMake(160, 140)];//指定进度轮中心点
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    [self.view addSubview:self.activity];
    
    [self loadUserData];
    
    if (self.retweetContent != nil && [self.type isEqualToString:@"retweet"]) {
        NSDictionary *retweetUserInfo = [self.retweetContent objectForKey:@"user"];
        NSString *sourceText = [self.retweetContent objectForKey:@"text"];
        sourceText = [sourceText isEqualToString:@""]?@"转发微博":[NSString stringWithFormat:@"//@%@:%@",[retweetUserInfo objectForKey:@"screen_name"], sourceText];
        self.weiboContentTextView.text = sourceText;
    }
    if ([self.type isEqualToString:@"comment"] && self.commentToUser != nil) {
        self.weiboContentTextView.text = [NSString stringWithFormat:@"回复@%@:",self.commentToUser];
    }
    
    [self.weiboContentTextView becomeFirstResponder];
    
}


- (void)setToolBarButton
{
    UIButton *camera = [UIButton buttonWithType:UIButtonTypeCustom];
    camera.frame = CGRectMake(0, 0, 22, 22);
    [camera setImage:[UIImage imageNamed:@"messages_toolbar_camerabutton_background"] forState:UIControlStateNormal];
    [camera setImage:[UIImage imageNamed:@"messages_toolbar_camerabutton_background_highlighted"] forState:UIControlStateHighlighted];
    [camera addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    if (self.retweetContent != nil) {
        camera.userInteractionEnabled = NO;
    }
    self.toolBarBtn1.customView = camera;
    
    UIButton *photo = [UIButton buttonWithType:UIButtonTypeCustom];
    photo.frame = CGRectMake(0, 0, 22, 22);
    [photo setImage:[UIImage imageNamed:@"messages_toolbar_photobutton_background"] forState:UIControlStateNormal];
    [photo setImage:[UIImage imageNamed:@"messages_toolbar_photobutton_background_highlighted"] forState:UIControlStateHighlighted];
    [photo addTarget:self action:@selector(openMyPhoteLibary:) forControlEvents:UIControlEventTouchUpInside];
    if (self.retweetContent != nil) {
        photo.userInteractionEnabled = NO;
    }
    self.toolBarBtn2.customView = photo;
    
    UIButton *connectSomeone = [UIButton buttonWithType:UIButtonTypeCustom];
    connectSomeone.frame = CGRectMake(0, 0, 22, 22);
    [connectSomeone setImage:[UIImage imageNamed:@"compose_mentionbutton_background"] forState:UIControlStateNormal];
    [connectSomeone setImage:[UIImage imageNamed:@"compose_mentionbutton_background_highlighted"] forState:UIControlStateHighlighted];
    [connectSomeone addTarget:self action:@selector(friendsListShow: forEvent:) forControlEvents:UIControlEventTouchUpInside];
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
    [_friendsTableView release];
    [super dealloc];
}
- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendWeiboButtonClick:(UIBarButtonItem *)sender {
    recevieDataType = RECEVIE_UPDATE_WEIBO_RESULT;
    [self.weiboContentTextView resignFirstResponder];
    NSString *weiboContent = self.weiboContentTextView.text;
    if ([[weiboContent stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送空白文本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (self.retweetContent != nil) {
        if ([self.type isEqualToString:@"retweet"]) {
            NSString *retweeterId = nil;
            if ([self.retweetContent objectForKey:@"retweeted_status"] != nil) {
                NSDictionary *retweeted_status = [self.retweetContent objectForKey:@"retweeted_status"];
                retweeterId = [NSString stringWithFormat:@"%@",[retweeted_status objectForKey:@"id"]];
            } else {
                retweeterId = [NSString stringWithFormat:@"%@",[self.retweetContent objectForKey:@"id"]];
            }
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:weiboContent, @"status", retweeterId, @"id", nil];
            [self.activity startAnimating];
            [self.sinaweibo requestWithURL:@"statuses/repost.json" params:param httpMethod:@"POST" delegate:self];
            
        }
        if ([self.type isEqualToString:@"comment"]) {
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:weiboContent, @"comment", [NSString stringWithFormat:@"%@",[self.retweetContent objectForKey:@"id"]], @"id", nil];
            [self.sinaweibo requestWithURL:@"comments/create.json" params:param httpMethod:@"POST" delegate:self];
        }
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:weiboContent forKey:@"status"];
    if (self.pickerImage != nil) {
        [param setObject:self.pickerImage.image forKey:@"pic"];
        [self.sinaweibo requestWithURL:@"statuses/upload.json" params:param httpMethod:@"POST" delegate:self];
        [self.activity startAnimating];
        return;
    }
    [self.activity startAnimating];
    [self.sinaweibo requestWithURL:@"statuses/update.json" params:param httpMethod:@"POST" delegate:self];
}

#pragma mark -
#pragma mark load data
- (void)loadUserData
{
    recevieDataType = RECEVIE_USER_DATA;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.sinaweibo.userID], @"uid", @"200", @"count", nil];
    
    [self.sinaweibo requestWithURL:@"friendships/friends.json" params:param httpMethod:@"GET" delegate:self];
}

#pragma mark - SinaWeiboRequestDelegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"网络加载失败");
    [self.activity stopAnimating];
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *res = (NSDictionary *)result;
    if ([recevieDataType isEqualToString:RECEVIE_USER_DATA]) {
        self.friendsList = [[NSMutableArray alloc] initWithArray:[res objectForKey:@"users"]];
    }
    if ([recevieDataType isEqualToString:RECEVIE_UPDATE_WEIBO_RESULT]) {
        
        NSLog(@"%@",res);
        [self.activity stopAnimating];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
    [pickerImage release];
}

- (void)friendsListShow:(UIButton *)sender forEvent:(UIEvent*)event
{
    [self.weiboContentTextView resignFirstResponder];
    TSPopoverController *userPopoverController = [[[TSPopoverController alloc] initWithView:self.friendsTableView] autorelease];
    userPopoverController.cornerRadius = 5;
    userPopoverController.titleText = @"关注列表";
    userPopoverController.popoverBaseColor = [UIColor blackColor];
    userPopoverController.popoverGradient= NO;
    [userPopoverController showPopoverWithRect:CGRectMake(160, 430, 0, 0)];
//    [userPopoverController showPopoverWithTouch:event];
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
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.pickerImage = nil;
    self.pickerImage = [[UIImageView alloc] initWithImage:image];
    
    self.pickerImage.frame = CGRectMake(260, 430-64-2, 50, 50);
    [self.view addSubview:self.pickerImage];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *userInfo = [self.friendsList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"@",[userInfo objectForKey:@"screen_name"]];
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.weiboContentTextView.text = [NSString stringWithFormat:@"%@%@ ",self.weiboContentTextView.text,[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}



@end
