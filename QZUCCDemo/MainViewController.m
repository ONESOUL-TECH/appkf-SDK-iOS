//
//  MainViewController.m
//  QZUCCDemo
//
//  Created by tang.johannes on 15/9/9.
//  Copyright (c) 2015年 tang.johannes. All rights reserved.
//

#import "MainViewController.h"

#import "QZUCC.h"

#define kTagButtonCall 1
#define kTagButtonIM 2

#define kTagTextFieldAccountSeq  3

#define kUserIds @[];

@interface MainViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property(nonatomic, retain) UIButton *btn1;
@property(nonatomic, retain) UIButton *btn2;
@property(nonatomic, retain) UIButton *btn3;

@end

@implementation MainViewController

@synthesize btn1;
@synthesize btn2;
@synthesize btn3;

- (void)dealloc
{
    [btn1 release];
    [btn2 release];
    [btn3 release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"App 客服 SDK Demo";
    [self setTitle:self.title withColor:[UIColor whiteColor]];
  
    UIColor *btn2Color = [UIColor blueColor];
    self.btn2 = [self buttonWithTitle:@"消息" color:btn2Color frame:CGRectZero selector:@selector(doAction:)];
    btn2.frame = CGRectMake(15, 100, 290, 44);
    [btn2 setImage:[UIImage imageNamed:@"detail_sms_enable"] forState:UIControlStateNormal];
    btn2.userInteractionEnabled = YES;
    btn2.tag = kTagButtonIM;
    [self.view addSubview:btn2];
    
    //
    UIColor *btn3Color = [UIColor colorWithRed:68/255. green:171/255. blue:248/255. alpha:1.];
    self.btn3 = [self buttonWithTitle:@"用户鉴权" color:btn3Color frame:CGRectZero selector:@selector(doLoginAction:)];
    btn3.frame = CGRectMake(15, CGRectGetMaxY(btn2.frame) + 50, 290, 44);
    btn3.userInteractionEnabled = YES;
    
    [self.view addSubview:btn3];
    
    //
    [self checkAuth];
}

#pragma mark - view 


- (void)setTitle:(NSString *)title withColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [view setBackgroundColor:[UIColor clearColor]];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFrame:CGRectMake(0, 0, 200, 44)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
    [nameLabel setTextColor:color];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [nameLabel setText:title];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:nameLabel];
    [nameLabel release];
    
    self.navigationItem.titleView = view;
    
    [view release];
    
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

- (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)btnColor frame:(CGRect)frame selector:(SEL)selector
{
    
    UIImage *btnBgImage = [self imageWithColor:btnColor size:CGSizeMake(5, 5)];
    UIImage *btnBgImageStr = [btnBgImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize: 18.0f];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setBackgroundImage:btnBgImageStr forState:(UIControlStateNormal)];
    [btn addTarget:self action:selector forControlEvents:(UIControlEventTouchUpInside)];
    
    UIColor *disableBtnColor = [UIColor grayColor];
    UIImage *disableBtnBgImage = [self imageWithColor:disableBtnColor size:CGSizeMake(5, 5)];
    UIImage *disableBtnBgImageStr = [disableBtnBgImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    [btn setBackgroundImage:disableBtnBgImageStr forState:UIControlStateDisabled];
    
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action

- (void)doAction:(UIButton *)btn
{
    QZUCC *ucc = [QZUCC getInstance];
    
    if (ucc.isLogged == NO) {
        [self doLoginAction:nil];
        return;
    }
    
    int chtcltConnect = [ucc getAbilityState:AbilityIM];
    if (!chtcltConnect) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"相关服务正在连接中,请稍候。。。"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:nil] autorelease];
        [alert show];
        
        return;
    }
    
    //
   if (btn.tag ==kTagButtonIM) {
        
        QUserInfo *usrInfo = [[[QUserInfo alloc] init] autorelease];
        usrInfo.qzId = @"uckf.200000411201";
        usrInfo.name = @"客服";
        [ucc pushChatFromViewController:self target:usrInfo];
    }
}

- (void)doLoginAction:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择帐号并进行鉴权"
                                                    message:nil
                                                    /*message:@"\n\n\n\n\n"*/
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"鉴权",nil];
    
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.delegate = self;
    textField.tag = kTagTextFieldAccountSeq;
    [textField setPlaceholder:@"请输入帐号序号(1,2,3,4,5)"];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyDone;
    [textField becomeFirstResponder];
    
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //
    UITextField *textField = nil;
    UIAlertViewStyle style = alertView.alertViewStyle;
    if (style == UIAlertViewStylePlainTextInput) {
        textField = [alertView textFieldAtIndex:0];
    }
    
    if (textField) {
        [textField resignFirstResponder];
    }
    
    //
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    if (style != UIAlertViewStylePlainTextInput) {
        return;
    }
    
    
    NSString *seqText = textField.text;
    if (!seqText || ![seqText length]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"序号不能为空"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"确认"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        return;
    }
    
    int seqInt = seqText.intValue;
    NSArray *userIds = @[@"200000211101", @"200000211102", @"200000211103", @"200000211104", @"200000211105"];
    if (seqInt < 0 || seqInt > [userIds count]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"序号仅能在1至5范围内选择"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"确认"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        return;
    }
    
    NSString *userId = [userIds objectAtIndex:seqInt - 1];
    
    QZUCC *ucc = [QZUCC getInstance];
    [ucc connectWithUCMUrl:@"os.qyucc.com:809" qzId:userId authToken:@"" completion:^{
        
        NSLog(@"MainViewCtrl======授权成功=========");
        
        [self checkAuth];
        
    } fail:^(NSError *error) {
        NSLog(@"MainViewCtrl======授权失败=========%@", error);
    }];
    
    
}


#pragma mark - Method

- (void)onUserForcedToQuit
{
    [self checkAuth];
}

- (void)checkAuth
{
    //
    QZUCC *ucc = [QZUCC getInstance];
    if (ucc.isLogged) {
        self.btn1.enabled = YES;
        self.btn2.enabled = YES;
        self.btn3.enabled = NO;
        [self.btn3 setTitle:@"已鉴权" forState:UIControlStateNormal];
        
    } else {
        self.btn1.enabled = NO;
        self.btn2.enabled = NO;
        self.btn3.enabled = YES;
        [self.btn3 setTitle:@"用户鉴权" forState:UIControlStateNormal];
    }
}

@end
