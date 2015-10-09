//
//  MainViewController.m
//  QZUCCDemo
//
//  Created by tang.johannes on 15/9/9.
//  Copyright (c) 2015年 tang.johannes. All rights reserved.
//

#import "MainViewController.h"

//#import <QZUCC/QZUCC.h>
#import "QZUCC.h"

#define kTagButtonCall 1
#define kTagButtonIM 2

#define kTagTextFieldAccountSeq  3

#define kUserIds @[];

CG_INLINE CGRect CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat ScreenHeight = bounds.size.height;
    CGFloat ScreenWidth = bounds.size.width;
    
    CGRect rect;
    rect.origin.x = (ScreenHeight > 480 ? ScreenWidth/320 : 1.0)*x;
    rect.origin.y = (ScreenHeight > 480 ? ScreenHeight/568 : 1.0)*y;
    rect.size.width = (ScreenHeight > 480 ? ScreenWidth/320 : 1.0)*width;
    rect.size.height = (ScreenHeight > 480 ? ScreenHeight/568 : 1.0)*height;
    
    return rect;
}

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
    
    self.title = @"App客服SDK-Demo";
    [self setTitle:self.title withColor:[UIColor whiteColor]];
    
    //
    UIColor *btn2Color = [UIColor blueColor];
    self.btn2 = [self buttonWithTitle:@"消息" color:btn2Color frame:CGRectZero selector:@selector(doAction:)];
    btn2.frame = CGRectMake1(15, 100, 290, 44);
    [btn2 setImage:[UIImage imageNamed:@"detail_sms_enable"] forState:UIControlStateNormal];
    btn2.userInteractionEnabled = YES;
    btn2.tag = kTagButtonIM;
    [self.view addSubview:btn2];
    
    //
    UIColor *btn3Color = [UIColor colorWithRed:68/255. green:171/255. blue:248/255. alpha:1.];
    self.btn3 = [self buttonWithTitle:@"连接服务器" color:btn3Color frame:CGRectZero selector:@selector(doLoginAction:)];
    btn3.frame = CGRectMake1(15, CGRectGetMaxY(btn2.frame) + 50, 290, 44);
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
    QZUCC *ucc = [QZUCC getInstance];
    if (!ucc.isLogged) {
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
    } else {
        [ucc disconnect];
        [self checkAuth];
    }
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
    if (seqInt < 0 || seqInt > 5) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"序号仅能在1至5范围内选择"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"确认"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        return;
    }
    
    NSString *appkey = @"NC4xF";
    NSString *user = nil;
    NSString *authToken = nil;
    switch (seqInt - 1) {
        case 0:
            user = @"test1";
            authToken = @"5b461ae8325877fb938ff20a2c213a0f";
            break;
        case 1:
            user = @"test2";
            authToken = @"30cac5530de0cea8be78d871778783bf";
            break;
        case 2:
            user = @"test3";
            authToken = @"7ee683db7713a7b3ffb0a25607947850";
            break;
        case 3:
            user = @"test4";
            authToken = @"1afad02f895b18a6087cc56822677c03";
            break;
        case 4:
            user = @"test5";
            authToken = @"5c01b0e5d670dd4ebe63425ae7c7d9e7";
            break;
            
        default:
            break;
    }
    
    QZUCC *ucc = [QZUCC getInstance];
    //    appKey: NC4xF , 用户列表如下：
    //    test5 / 5c01b0e5d670dd4ebe63425ae7c7d9e7
    //    test4 / 1afad02f895b18a6087cc56822677c03
    //    test3 / 7ee683db7713a7b3ffb0a25607947850
    //    test2 / 30cac5530de0cea8be78d871778783bf
    //    test1 / 5b461ae8325877fb938ff20a2c213a0f
    //appKey: Mi40MDEe, userName: test, Token(PasswordMD5):  c4ca4238a0b923820dcc509a6f75849b
    [ucc connectWithUCMUrl:@"os.qyucc.com:809" appKey:appkey user:user authToken:authToken completion:^{
        
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
        //self.btn3.enabled = NO;
        //[self.btn3 setTitle:@"已鉴权" forState:UIControlStateNormal];

        self.btn3.enabled = YES;
        [self.btn3 setTitle:@"与服务器断开" forState:UIControlStateNormal];
    } else {
        self.btn1.enabled = NO;
        self.btn2.enabled = NO;
        self.btn3.enabled = YES;
        [self.btn3 setTitle:@"连接服务器" forState:UIControlStateNormal];
    }
}

@end
